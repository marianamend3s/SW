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
    
    private var characterItems: [CharacterDisplayItem] = []
    private var isLoadingCharacters: Bool = false
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, CharacterDisplayItem>!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let backgroundLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.cgColor,
            UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1).cgColor,
            UIColor.black.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
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
        return UICollectionView()
    }()
    
    private enum Section {
        case main
    }
    
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
        
        view.layer.insertSublayer(backgroundLayer, at: 0)
        
        setupCollectionView()
        setupViews()
        configureWithViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundLayer.frame = view.bounds
    }
    
    // MARK: - UI Configuration
    
    private func setupNavigationBar() {
        guard let viewModel else { return }
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 160)
        layout.minimumLineSpacing = 10
        
        charactersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        charactersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        charactersCollectionView.delegate = self
        charactersCollectionView.backgroundColor = .clear
        charactersCollectionView.showsHorizontalScrollIndicator = false
        
        charactersCollectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        charactersCollectionView.register(PlaceholderCharacterCell.self, forCellWithReuseIdentifier: PlaceholderCharacterCell.reuseIdentifier)
        
        configureDataSource()
    }
    
    private func setupViews() {
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
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
    // MARK: - View Model Configuration
    
    private func configureWithViewModel() {
        guard let viewModel else { return }
        
        viewModel.onCharactersLoading = { [weak self] in
            guard let self = self else { return }
            self.isLoadingCharacters = true
            
            let placeholders = Array(repeating: Character(), count: 20).map {
                CharacterDisplayItem(character: $0, isPlaceholder: true)
            }
            self.applyCharacterSnapshot(with: placeholders)
            
        }
        
        viewModel.onCharactersLoaded = { [weak self] characters in
            guard let self = self else { return }
            self.isLoadingCharacters = false
            let displayItems = characters.map { CharacterDisplayItem(character: $0, isPlaceholder: false) }
            DispatchQueue.main.async {
                self.applyCharacterSnapshot(with: displayItems)
            }
        }
        
        viewModel.getCharactersFromURL()
        
        episodeLabel.text = "Episode: \(viewModel.episodeId)"
        directorLabel.text = "Director: \(viewModel.director)"
        producerLabel.text = "Producer: \(viewModel.producer)"
        releaseDateLabel.text = "Release date: \(viewModel.releaseDate)"
        openingCrawlTextView.text = viewModel.openingCrawl
    }
    
    
    // MARK: - UICollectionViewDiffableDataSource
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CharacterDisplayItem>(
            collectionView: charactersCollectionView
        ) { collectionView, indexPath, item in
            if item.isPlaceholder {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlaceholderCharacterCell.reuseIdentifier,
                    for: indexPath
                ) as! PlaceholderCharacterCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CharacterCell.reuseIdentifier,
                    for: indexPath
                ) as! CharacterCell
                cell.configure(with: item.character)
                return cell
            }
        }
    }
    
    private func applyCharacterSnapshot(with items: [CharacterDisplayItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterDisplayItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension FilmDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath), !item.isPlaceholder else { return }
        onCharacterSelected?(item.character)
    }
}

