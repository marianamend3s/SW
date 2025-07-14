//
//  CharacterCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    static let reuseIdentifier = "CharacterCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOpacity = Constants.shadowOpacity
        layer.masksToBounds = false
        
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.padding
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.padding
            )
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.contentView.alpha = self.isHighlighted
                    ? Constants.isHighlightedAlpha
                    : Constants.isNotHighlightedAlpha
                self.transform = self.isHighlighted
                    ? CGAffineTransform(
                        scaleX: Constants.highlightScaleX,
                        y: Constants.highlightScaleY
                    )
                    : .identity
            }
        }
    }
}
