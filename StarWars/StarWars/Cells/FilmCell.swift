//
//  FilmCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import UIKit

class FilmCell: UICollectionViewCell {
    static let reuseIdentifier = "FilmCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 1, green: 234/255, blue: 160/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    
    private let backgroundGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 240/255, green: 210/255, blue: 80/255, alpha: 1).cgColor,
            UIColor(red: 190/255, green: 160/255, blue: 60/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
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
        episodeLabel.text = nil
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.contentView.alpha = self.isHighlighted ? 0.7 : 1
                self.transform = self.isHighlighted
                ? CGAffineTransform(scaleX: 0.98, y: 0.98)
                : .identity
            }
        }
    }
    
    func configure(with film: Film) {
        titleLabel.text = film.title
        episodeLabel.text = "Episode \(film.episodeId)"
    }
    
    private func setupCell() {
        contentView.layer.insertSublayer(backgroundGradient, at: 0)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor(red: 255/255, green: 215/255, blue: 100/255, alpha: 0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, episodeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}
