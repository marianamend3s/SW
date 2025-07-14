//
//  CategoriesViewController.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import UIKit

class CategoriesViewController: UIViewController {
    var viewModel: CategoriesViewModel?
    var onCategorySelected: ((String?) -> Void)?
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
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
    
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupActivityIndicator()
        setupCollectionView()
        setupErrorLabel()
        bindViewModel()
        viewModel?.getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = ""
    }

    
    private func setupNavigationBar() {
        self.title = "Star Wars"
        
        let titleColor = UIColor(red: 255/255, green: 232/255, blue: 31/255, alpha: 1.0)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.boldSystemFont(ofSize: 40)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
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
            CategoryCell.self,
            forCellWithReuseIdentifier: CategoryCell.reuseIdentifier
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
            widthDimension: .fractionalWidth(Constants.itemFractionalWidth),
            heightDimension: .fractionalHeight(Constants.itemFractionalHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.insets,
            leading: Constants.insets,
            bottom: Constants.insets,
            trailing: Constants.insets
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constants.groupFractionalWidth),
            heightDimension: .fractionalWidth(Constants.groupFractionalHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.insets,
            leading: Constants.insets,
            bottom: Constants.insets,
            trailing: Constants.insets
        )
        
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
                constant: Constants.errorMargin
            ),
            errorLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.errorMargin),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel?.onCategoriesUpdated = { [weak self] in
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
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(
            collectionView: collectionView
        ) { (collectionView, indexPath, categoryName) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.reuseIdentifier,
                for: indexPath
            ) as? CategoryCell else {
                return nil
            }
            cell.configure(with: categoryName)
            return cell
        }
    }

    private func applySnapshot() {
        guard let categoryNames = viewModel?.categoryNames else { return }
        
        let processedCategoryNames = categoryNames.map { name -> String in
            var modifiedName = name
            if name == "people" {
                modifiedName = "characters"
            }
            return modifiedName.capitalized
        }
        
        let capitalizedCategoryNames = processedCategoryNames.map { $0.capitalized }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(capitalizedCategoryNames, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = viewModel?.categoryNames[indexPath.item]
        onCategorySelected?(selectedCategory)
    }
}
