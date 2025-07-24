//
//  CellStyleHelper.swift
//  StarWars
//
//  Created by Mariana Mendes on 24/07/2025.
//

import UIKit

// TODO: Add CellStyleProvider protocol and implementation for testing and DI.

struct CellStyle {
    
    // MARK: - Constants
    
    struct Constants {
        // Corner Radius
        static let cornerRadius: CGFloat = 10
        
        // Padding
        static let padding: CGFloat = 8
        static let stackSpacing: CGFloat = 4
        static let secondaryStackSpacing: CGFloat = 15

        // Colors
        static let darkBackgroundStart = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1).cgColor
        static let darkBackgroundEnd = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
        static let shimmerDark = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
        static let shimmerMedium = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1).cgColor
        static let shimmerLight = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1).cgColor
        static let shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        static let shadowTint = UIColor.systemIndigo.cgColor
        static let titleLabelColor: UIColor = UIColor.white
        static let subtitleLabelColor: UIColor = UIColor(red: 1, green: 234/255, blue: 160/255, alpha: 1)
        static let textShadowColor = UIColor.yellow.cgColor
        static let textViewTextColor = UIColor(red: 240/255, green: 240/255, blue: 200/255, alpha: 1)
        static let gradientColors = [
            UIColor(red: 240/255, green: 210/255, blue: 80/255, alpha: 1).cgColor,
            UIColor(red: 190/255, green: 160/255, blue: 60/255, alpha: 1).cgColor
        ]
        
        // Fonts
        static let titleLabelFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let subtitleLabelFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        // Gradient
        static let gradientStartPoint = CGPoint(x: 0.0, y: 0.5)
        static let gradientEndPoint = CGPoint(x: 1.0, y: 0.5)

        // Shadows
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.4
        static let shimmerShadowOpacity: Float = 0.2
        static let shadowRadius: CGFloat = 4
        
        // Highlight
        static let highlightDuration: CGFloat = 0.1
        static let isHighlightedAlpha: CGFloat = 0.7
        static let isNotHighlightedAlpha: CGFloat = 1
        static let highlightScale: CGFloat = 0.98

        // Shimmer
        static let shimmerAnimationDuration: CFTimeInterval = 1.4
        static let shimmerStartPoint: CGPoint = CGPoint(x: -1, y: 0.5)
        static let shimmerEndPoint: CGPoint = CGPoint(x: 2, y: 0.5)
        static let shimmerLocations: [NSNumber] = [0, 0.5, 1]
        static let shimmerAnimationFromValues: [NSNumber] = [-1.0, -0.5, 0.0]
        static let shimmerAnimationToValues: [NSNumber] = [1.0, 1.5, 2.0]
    }

    // MARK: - Helpers
    
    struct Helpers {
        // Corner Radius
        static func applyRoundedCorners(
            to view: UIView,
            radius: CGFloat = Constants.cornerRadius
        ) {
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
        }
        
        // Gradient
        static func makeGoldenGradientLayer() -> CAGradientLayer {
            let gradient = CAGradientLayer()
            gradient.colors = Constants.gradientColors
            gradient.startPoint = Constants.gradientStartPoint
            gradient.endPoint = Constants.gradientEndPoint
            return gradient
        }
        
        // Shadow
        static func applyCardShadow(
            to layer: CALayer,
            color: UIColor = .black,
            opacity: Float = Constants.shadowOpacity
        ) {
            layer.shadowColor = color.cgColor
            layer.shadowOffset = Constants.shadowOffset
            layer.shadowRadius = Constants.shadowRadius
            layer.shadowOpacity = opacity
            layer.masksToBounds = false
        }
        
        // Shimmer
        static func makeShimmer(
            on contentView: UIView
        ) -> CAGradientLayer {
            let shimmer = CAGradientLayer()
            
            shimmer.colors = [
                CellStyle.Constants.shimmerMedium,
                CellStyle.Constants.shimmerLight,
                CellStyle.Constants.shimmerMedium
            ]
            
            shimmer.startPoint = CellStyle.Constants.shimmerStartPoint
            shimmer.endPoint = CellStyle.Constants.shimmerEndPoint
            shimmer.locations = CellStyle.Constants.shimmerLocations
            shimmer.frame = contentView.bounds
            shimmer.cornerRadius = CellStyle.Constants.cornerRadius
            shimmer.masksToBounds = true
            
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = CellStyle.Constants.shimmerAnimationFromValues
            animation.toValue = CellStyle.Constants.shimmerAnimationToValues
            animation.duration = CellStyle.Constants.shimmerAnimationDuration
            animation.repeatCount = .infinity
            
            shimmer.add(animation, forKey: "shimmer")
            
            return shimmer
        }
    }
}
