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
            onLoadingStateChanged?(isLoading)
        }
    }
    
    var errorMessage: String? {
        didSet {
            Task {
                onError?(errorMessage)
            }
        }
    }
    
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String?) -> Void)?
}
