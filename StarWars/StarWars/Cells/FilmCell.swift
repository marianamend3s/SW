//
//  FilmCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import UIKit

class FilmCell: UICollectionViewCell {
    static let reuseIdentifier = Constants.FilmCell.reuseIdentifier
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
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
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, episodeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constants.FilmCell.stackSpacing
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.padding
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.padding
            )
        ])
    }
    
    func configure(with film: Film) {
        titleLabel.text = film.title
        episodeLabel.text = "\(Constants.FilmCell.episode) \(film.episodeId)"
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
