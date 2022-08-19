//
//  CocktailsListRouter.swift
//  Tonic
//

import Foundation
import UIKit
import SwiftUI

protocol CocktailsRoutable {
    /// Presents the cocktail details view.
    func routeToDetails(with cocktail: Cocktail)
}

class CocktailsListRouter: CocktailsRoutable {
    
    // MARK: - Properties: public
    
    weak var sourceViewController: UIViewController?
    
    // MARK: - Methods: public
    
    func routeToDetails(with cocktail: Cocktail) {
        let detailsView = CocktailsDetailView(cocktail) { [weak self] in
            self?.sourceViewController?.dismiss(animated: true)
        }
        
        let detailsController = UIHostingController(rootView: detailsView)
        
        sourceViewController?.present(detailsController, animated: true)
    }
}
