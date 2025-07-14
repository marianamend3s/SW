//
//  CharacterViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

class CharacterViewModel {
    private let characterService: CharacterService

    var characters: [Character] = [] {
        didSet {
            onCharactersUpdated?()
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

    var onCharactersUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?

    init(characterService: CharacterService) {
        self.characterService = characterService
    }

    func fetchCharacters() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedCharacters = try await characterService.getCharacters()

                DispatchQueue.main.async {
                    self.characters = fetchedCharacters
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

