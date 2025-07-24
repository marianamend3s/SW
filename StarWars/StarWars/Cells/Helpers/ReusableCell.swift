//
//  ReusableCell.swift
//  StarWars
//
//  Created by Mariana Mendes on 24/07/2025.
//

import Foundation

protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
