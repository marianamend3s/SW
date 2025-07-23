//
//  FilmsViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 12/07/2025.
//

import Foundation

class FilmsViewModel {
    private let filmsService: FilmService

    var films: [Film] = [] {
        didSet {
            onFilmsUpdated?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    var errorMessage: String? {
        didSet {
            onError?(errorMessage)
        }
    }

    var onFilmsUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?

    init(filmsService: FilmService) {
        self.filmsService = filmsService
    }

    func fetchFilms() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedFilms = try await filmsService.fetchFilms()
                let orderedFilms = fetchedFilms.sorted { $0.episodeId < $1.episodeId }

                await MainActor.run {
                    self.films = orderedFilms
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
