//
//  ViewController.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: For debug purposes - delete later
        printToDebug()
    }
    
    func printToDebug() {
        let networkService = NetworkServiceImpl()
        
        Task{
            do {
                let films = try await networkService.getFilms()
                print("Successfully fetched \(films.count) films:")
                for film in films {
                    print("- \(film.title) (Episode \(film.episodeId)) - Release Date: \(film.releaseDate.formatted(date: .numeric, time: .omitted))")
                }
            } catch {
                print("Failed to fetch films: \(error.localizedDescription)")
                if let filmsError = error as? NetworkError {
                    print("Specific error: \(filmsError.errorDescription ?? "Unknown FilmsError")")
                }
            }
        }
    }
}

