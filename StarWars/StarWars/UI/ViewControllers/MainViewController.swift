//
//  MainViewController.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import UIKit

class MainViewController: UIViewController {

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupCollectionView()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Star Wars App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupCollectionView() {
        let layout = createCollectionViewLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            fatalError("Unable to dequeue cell")
        }
        cell.configure(with: Categories.allCases[indexPath.item].rawValue)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = Categories.allCases[indexPath.item].rawValue

        let destinationVC: UIViewController
        
        switch selectedItem {
        case Categories.films.rawValue:
            destinationVC = FilmsViewController()
        
        // TODO: - remove when all cases are done
        default:
            destinationVC = UIViewController()
        }
        
        destinationVC.title = selectedItem
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
