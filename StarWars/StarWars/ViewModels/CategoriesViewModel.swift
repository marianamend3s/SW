//
//  CategoriesViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.

import UIKit

class CategoriesViewModel {
    private let categoryService: CategoryService

    var categoryNames: [String] = [] {
        didSet {
            onCategoriesUpdated?()
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
    
    var onCategoriesUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?

    init(categoryService: CategoryService) {
        self.categoryService = categoryService
    }

    func getCategories() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedCategories = try await categoryService.fetchCategoryNames()

                DispatchQueue.main.async {
                    self.categoryNames = fetchedCategories
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
