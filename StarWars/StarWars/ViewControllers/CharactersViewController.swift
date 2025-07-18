//
//  CharactersViewController.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

class CharactersViewController: UIViewController {
    var viewModel: CharacterViewModel?
    var onCharacterSelected: ((Character) -> Void)?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Character>!
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView()
    }()
    
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupActivityIndicator()
        setupCollectionView()
        setupErrorLabel()
        
        configureWithViewModel()
        viewModel?.getCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    // MARK: - UI Configuration
    
    private func setupNavigationBar() {
        navigationItem.title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        let layout = createCollectionViewLayout()
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(
            CharacterCell.self,
            forCellWithReuseIdentifier: CharacterCell.reuseIdentifier
        )
        
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        configureDataSource()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupErrorLabel() {
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            errorLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - View Model Configuration
    
    private func configureWithViewModel() {
        viewModel?.onCharactersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.applySnapshot()
                self?.collectionView.isHidden = false
                self?.errorLabel.isHidden = true
            }
        }
        
        viewModel?.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.collectionView.isHidden = true
                    self?.errorLabel.isHidden = true
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel?.onError = { [weak self] message in
            DispatchQueue.main.async {
                if let errorMessage = message, !errorMessage.isEmpty {
                    self?.errorLabel.text = errorMessage
                    self?.errorLabel.isHidden = false
                    self?.collectionView.isHidden = true
                } else {
                    self?.errorLabel.text = nil
                    self?.errorLabel.isHidden = true
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDiffableDataSource
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Character>(
            collectionView: collectionView
        ) { (collectionView, indexPath, character) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterCell.reuseIdentifier,
                for: indexPath
            ) as? CharacterCell else {
                return nil
            }
            cell.configure(with: character)
            return cell
        }
    }
    
    private func applySnapshot() {
        guard let characters = viewModel?.pageCharacters else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel else { return }
        let selectedCharacter = viewModel.pageCharacters[indexPath.item]
        onCharacterSelected?(selectedCharacter)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 1.5 {
            viewModel.loadNextPage()
        }
    }
    
}
