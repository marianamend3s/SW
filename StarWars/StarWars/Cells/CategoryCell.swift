//
//  CategoryCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import UIKit

// TODO: Inject dependencies

final class CategoryCell: HighlightableCell, ReusableCell {
    private let titleLabel = LabelFactory.titleLabel()
    
    private let backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            CellStyle.Constants.darkBackgroundStart,
            CellStyle.Constants.darkBackgroundEnd
        ]
        gradient.startPoint = CellStyle.Constants.gradientStartPoint
        gradient.endPoint = CellStyle.Constants.gradientEndPoint
        return gradient
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
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        backgroundGradient.frame = contentView.bounds
        
        CATransaction.commit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        titleLabel.accessibilityLabel = nil
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        titleLabel.accessibilityLabel = titleLabel.text
    }
}

// MARK: - Private

extension CategoryCell {
    private func setupCell() {
        contentView.layer.insertSublayer(backgroundGradient, at: 0)
        contentView.layer.cornerRadius = CellStyle.Constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = CellStyle.Constants.shadowColor
        layer.shadowOffset = CellStyle.Constants.shadowOffset
        layer.shadowRadius = CellStyle.Constants.cornerRadius
        layer.shadowOpacity = CellStyle.Constants.shadowOpacity
        layer.masksToBounds = false
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: CellStyle.Constants.padding
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -CellStyle.Constants.padding
            )
        ])
    }
}
