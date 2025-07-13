//
//  NetworkService.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

protocol NetworkService {
    var urlSession: URLSession { get }
    var urlString: String { get }
    var decoder: JSONDecoder { get }
}

