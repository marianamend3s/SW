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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupActivityIndicator()
        setupCollectionView()
        setupErrorLabel()
        bindViewModel()
        viewModel?.fetchCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cleanUpNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.Categories.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func cleanUpNavigationBar() {
        navigationItem.title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
                self?.collectionView.reloadData()
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
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return .zero }
        return viewModel.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            fatalError("Unable to dequeue cell")
        }
        guard let viewModel else { return UICollectionViewCell() }
        let categoryName = viewModel.categoryNames[indexPath.item]
        cell.configure(with: categoryName.capitalized)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = viewModel?.categoryNames[indexPath.item]
        onCategorySelected?(selectedCategory)
    }
}
