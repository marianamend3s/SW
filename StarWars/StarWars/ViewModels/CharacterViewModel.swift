//
//  CharacterViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

class CharacterViewModel {
    private let characterService: CharacterService

    private var allCharacters: [Character] = []
    private(set) var pageCharacters: [Character] = []

    private let pageSize = 20
    private var currentPage = 0

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

    var onCharactersUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?

    init(characterService: CharacterService) {
        self.characterService = characterService
    }

    func getCharacters(reset: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedCharacters = try await characterService.fetchCharacters()
                await MainActor.run {
                    self.allCharacters = fetchedCharacters
                    self.currentPage = 0
                    self.pageCharacters = []
                    self.isLoading = false
                    self.loadNextPage()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func loadNextPage() {
        guard !isLoading else { return }

        let start = currentPage * pageSize
        let end = min(start + pageSize, allCharacters.count)

        guard start < end else { return }

        let nextPageItems = allCharacters[start..<end]
        pageCharacters += nextPageItems
        currentPage += 1
        onCharactersUpdated?()
    }
}
