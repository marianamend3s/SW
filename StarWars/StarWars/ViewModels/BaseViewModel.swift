//
//  BaseViewModel.swift
//  StarWars
//
//  Created by Mariana Mendes on 23/07/2025.
//

import Foundation

class BaseViewModel {
    var isLoading: Bool = false {
        didSet {
            Task {
                await MainActor.run {
                    onLoadingStateChanged?(isLoading)
                }
            }
        }
    }
    
    var errorMessage: String? {
        didSet {
            Task {
                await MainActor.run {
                    onError?(errorMessage)
                }
            }
        }
    }
    
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?
}
