//
//  PeopleViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 13/07/2025.
//

import Foundation

class PeopleViewModel {
    private let peopleService: PeopleService

    var people: [People] = [] {
        didSet {
            onPeopleUpdated?()
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

    var onPeopleUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?

    init(peopleService: PeopleService) {
        self.peopleService = peopleService
    }

    func fetchPeople() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedPeople = try await peopleService.getPeople()

                DispatchQueue.main.async {
                    self.people = fetchedPeople
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

