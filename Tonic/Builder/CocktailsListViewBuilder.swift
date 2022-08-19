//
//  CocktailsListViewBuilder.swift
//  Tonic
//

import Foundation
import UIKit

/// Responisble for building cocktails list view.
class CocktailsListViewBuilder {
    private init() {}
    
    /// Builds `CocktailsListViewController` with all it's dependencies.
    static func build() -> UINavigationController {
        let router = CocktailsListRouter()
        let service = CocktailNetworkService()
        let interactor = CocktailsListInteractor(router: router, service: service)
        
        let cocktailsListViewController = CocktailsListViewController(interactor: interactor)
        
        interactor.view = cocktailsListViewController
        
        let navigationController = UINavigationController(rootViewController: cocktailsListViewController)
        
        router.sourceViewController = navigationController
                
        return navigationController
    }
}
