//
//  LabelFactory.swift
//  StarWars
//
//  Created by Mariana Mendes on 24/07/2025.
//

import UIKit

struct LabelFactory {
    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CellStyle.Constants.titleLabelFont
        label.textColor = CellStyle.Constants.titleLabelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        return label
    }
    
    static func subtitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CellStyle.Constants.subtitleLabelFont
        label.textColor = CellStyle.Constants.subtitleLabelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        return label
    }
}
