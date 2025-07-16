//
//  PlaceholderCharacterCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 16/07/2025.
//

import UIKit

class PlaceholderCharacterCell: UICollectionViewCell {
    static let reuseIdentifier = "PlaceholderCharacterCell"
    private var shimmerLayer: CAGradientLayer?
    
    private let placeholderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shimmerLayer?.frame = contentView.bounds
    }
    
    private func setupCell() {
        contentView.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        configureShimmer()
    }
    
    private func configureShimmer() {
        contentView.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let shimmer = CAGradientLayer()
        shimmer.colors = [
            UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1).cgColor,
            UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1).cgColor,
            UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
        ]
        shimmer.startPoint = CGPoint(x: -1, y: 0.5)
        shimmer.endPoint = CGPoint(x: 2, y: 0.5)
        shimmer.locations = [0, 0.5, 1]
        shimmer.frame = contentView.bounds
        shimmer.cornerRadius = 10
        shimmer.masksToBounds = true
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.4
        animation.repeatCount = .infinity
        
        shimmer.add(animation, forKey: "shimmer")
        contentView.layer.addSublayer(shimmer)
        shimmerLayer = shimmer
        
        contentView.layer.shadowColor = UIColor.systemIndigo.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 6
    }
}
