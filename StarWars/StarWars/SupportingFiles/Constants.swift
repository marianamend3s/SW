//
//  Constants.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

enum Constants {
    static let cornerRadius: CGFloat = 10
    static let shadowOffset: CGSize = CGSize(width: 0, height: 2)
    static let shadowRadius: CGFloat = 4
    static let shadowOpacity: Float = 0.2
    static let padding: CGFloat = 8
    static let animationDuration: CGFloat = 0.1
    static let isHighlightedAlpha: CGFloat = 0.7
    static let isNotHighlightedAlpha: CGFloat = 1
    static let highlightScaleX: CGFloat = 0.98
    static let highlightScaleY: CGFloat = 0.98
    static let insets: CGFloat = 8
    static let itemFractionalWidth: CGFloat = 0.5
    static let itemFractionalHeight: CGFloat = 1.0
    static let groupFractionalWidth: CGFloat = 1.0
    static let groupFractionalHeight: CGFloat = 0.5
    static let errorMargin: CGFloat = 20
    static let separatorHeight: CGFloat = 0.5

    
    enum CategoryCell {
        static let reuseIdentifier: String = "CategoryCell"
    }
    
    enum FilmCell {
        static let reuseIdentifier: String = "FilmCell"
        static let stackSpacing: CGFloat = 4
        static let episode: String = "Episode"

    }
    
    enum FilmDetail {
        static let stackViewMargin: CGFloat = 20
        static let stackViewWidth: CGFloat = 40
        static let textViewHeight: CGFloat = 150
    }
    
    enum Categories {
        static let title = "Star Wars"
        static let films = "Films"
        static let people = "People"
    }
}
