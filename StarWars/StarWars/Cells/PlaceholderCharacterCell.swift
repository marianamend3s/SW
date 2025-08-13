//
//  PlaceholderCharacterCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 16/07/2025.
//

import UIKit

// TODO: Inject dependencies

final class PlaceholderCharacterCell: UICollectionViewCell, ReusableCell {
    private var shimmerLayer: CAGradientLayer?
    private let placeholderView = ViewFactory.placeholderCellView()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shimmerLayer?.removeAllAnimations()
    }
}

// MARK: - Private

extension PlaceholderCharacterCell {
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
        let shimmer = CellStyle.Helpers.makeShimmer(
            on: contentView
        )
        
        contentView.layer.addSublayer(shimmer)
        shimmerLayer = shimmer
        
        contentView.layer.shadowColor = CellStyle.Constants.shadowTint
        contentView.layer.shadowOffset = CellStyle.Constants.shadowOffset
        contentView.layer.shadowOpacity = CellStyle.Constants.shimmerShadowOpacity
        contentView.layer.shadowRadius = CellStyle.Constants.cornerRadius
    }
}
