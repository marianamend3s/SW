//
//  NetworkService.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import Foundation

protocol NetworkService {
     func getFilms() async throws -> [Film]
}
