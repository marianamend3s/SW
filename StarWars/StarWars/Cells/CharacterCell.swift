//
//  CharacterCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

// TODO: Inject dependencies

final class CharacterCell: HighlightableCell, ReusableCell {
    private let nameLabel = LabelFactory.titleLabel()
    private let backgroundGradient = CellStyle.Helpers.makeGoldenGradientLayer()
    
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
        
        nameLabel.text = nil
        nameLabel.accessibilityLabel = nil
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        nameLabel.accessibilityLabel = nameLabel.text
    }
}

// MARK: - Private

extension CharacterCell {
    private func setupCell() {
        contentView.layer.insertSublayer(backgroundGradient, at: 0)
        
        CellStyle.Helpers.applyRoundedCorners(to: contentView)
        CellStyle.Helpers.applyCardShadow(to: layer, color: UIColor.systemIndigo)
        
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: CellStyle.Constants.padding
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -CellStyle.Constants.padding
            )
        ])
    }
}
