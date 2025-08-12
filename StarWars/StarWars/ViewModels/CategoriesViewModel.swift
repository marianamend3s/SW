//
//  CategoriesViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.

import UIKit

@MainActor
class CategoriesViewModel: BaseViewModel {
    private let categoryService: CategoryService
    
    var categoryNames: [String] = [] {
        didSet {
            onCategoriesUpdated?()
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
                let fetchedCategories = try await categoryService.fetchCategories()

                let mirror = Mirror(reflecting: fetchedCategories)
                self.categoryNames = mirror.children.compactMap { $0.label }
                
                self.isLoading = false
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
