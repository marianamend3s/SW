//
//  FilmCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import UIKit

final class FilmCell: HighlightableCell, ReusableCell {    
    private let titleLabel = LabelFactory.titleLabel()
    private let episodeLabel = LabelFactory.subtitleLabel()
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
        
        titleLabel.text = nil
        titleLabel.accessibilityLabel = nil
        episodeLabel.text = nil
        episodeLabel.accessibilityLabel = nil
    }

    func configure(with film: Film) {
        titleLabel.text = film.title
        titleLabel.accessibilityLabel = titleLabel.text
        
        episodeLabel.text = "Episode \(film.episodeId)"
        episodeLabel.accessibilityLabel = episodeLabel.text
    }
}

// MARK: Private

extension FilmCell {
    private func setupCell() {
        contentView.layer.insertSublayer(backgroundGradient, at: 0)
        
        CellStyle.Helpers.applyRoundedCorners(to: contentView)
        CellStyle.Helpers.applyCardShadow(to: layer, color: UIColor.systemIndigo)
        
        let stackView = ViewFactory.verticalStack()
        stackView.addArrangedSubviews([titleLabel, episodeLabel])
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: CellStyle.Constants.padding
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -CellStyle.Constants.padding
            )
        ])
    }
}
