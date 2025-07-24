//
//  ViewFactory.swift
//  StarWars
//
//  Created by Mariana Mendes on 24/07/2025.
//

import UIKit

struct ViewFactory {
    static func verticalStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = CellStyle.Constants.stackSpacing
        
        return stack
    }
    
    static func secondaryVerticalStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = CellStyle.Constants.secondaryStackSpacing
        
        return stack
    }
    
    static func placeholderCellView() -> UIView {
        let view = UIView()
        view.backgroundColor = CellStyle.Constants.shimmerDark
        view.layer.cornerRadius = CellStyle.Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
