//
//  HighlightableCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 24/07/2025.
//

import UIKit

class HighlightableCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: CellStyle.Constants.highlightDuration) {
                self.contentView.alpha = self.isHighlighted
                ? CellStyle.Constants.isHighlightedAlpha
                : CellStyle.Constants.isNotHighlightedAlpha

                self.transform = self.isHighlighted
                ? CGAffineTransform(
                    scaleX: CellStyle.Constants.highlightScale,
                    y: CellStyle.Constants.highlightScale)
                : .identity
            }
        }
    }
}
