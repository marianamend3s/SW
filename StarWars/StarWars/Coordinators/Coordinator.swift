//
//  Coordinator.swift
//  StarWars
//
//  Created by Mariana Mendes on 11/07/2025.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var children: [Coordinator] { get set }
    func start()
    func coordinatorDidFinish(_ coordinator: Coordinator)
}
