//
//  CategoriesViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.

import UIKit

class CategoriesViewModel: BaseViewModel {
    private let categoryService: CategoryService

    var categoryNames: [String] = [] {
        didSet {
            Task {
                await MainActor.run {
                    onCategoriesUpdated?()
                }
            }
        }
    }
    
    var onCategoriesUpdated: (() -> Void)?

    init(categoryService: CategoryService) {
        self.categoryService = categoryService
    }

    func fetchCategories() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedCategories = try await categoryService.fetchCategoryNames()

                await MainActor.run {
                    self.categoryNames = fetchedCategories
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
