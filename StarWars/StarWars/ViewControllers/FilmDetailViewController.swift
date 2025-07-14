//
//  FilmDetailViewController.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import UIKit

class FilmDetailViewController: UIViewController {
    var viewModel: FilmDetailViewModel?
    var onCharacterSelected: ((Character) -> Void)?
    private var characters: [Character] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let directorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let producerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let synopsisLabel: UILabel = {
        let label = UILabel()
        label.text = "Synopsis:"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let openingCrawlTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textAlignment = .justified
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let charactersLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters:"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var charactersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 160)
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            episodeLabel,
            createSeparator(),
            directorLabel,
            producerLabel,
            releaseDateLabel,
            createSeparator(),
            synopsisLabel,
            openingCrawlTextView,
            createSeparator(),
            charactersLabel,
            charactersCollectionView,
            createSeparator()
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupUI()
        configureWithViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        guard let viewModel else { return }
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            openingCrawlTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            charactersCollectionView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    
    private func configureWithViewModel() {
        guard let viewModel else { return }
        
        viewModel.onCharactersLoaded = { [weak self] characters in
            self?.characters = characters
            DispatchQueue.main.async {
                self?.charactersCollectionView.reloadData()
            }
        }

        viewModel.getCharactersFromURL()

        episodeLabel.text = viewModel.episodeId
        directorLabel.text = viewModel.director
        producerLabel.text = viewModel.producer
        releaseDateLabel.text = viewModel.releaseDate
        openingCrawlTextView.text = viewModel.openingCrawl
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
        ])
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
}

// MARK: - UICollectionViewDataSource

extension FilmDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = characters[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as! CharacterCell
        cell.configure(with: character)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FilmDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = characters[indexPath.item]
        onCharacterSelected?(selectedCharacter)
    }
}

