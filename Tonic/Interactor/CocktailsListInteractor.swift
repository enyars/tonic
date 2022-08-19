//
//  CocktailsListInteractor.swift
//  Tonic
//

import Foundation

protocol CocktailsListInteractorProtocol: Interactor {
    
    /// The cocktails view.
    var view: CocktailsListView? { get set }
    
    /// Returns number of cocktails.
    func numberOfCocktails() -> Int
    
    /// Returns cocktail model at specified index.
    func cocktail(at indexPath: IndexPath) -> Cocktail
    
    /// Selects cocktail at specified index.
    func selectCocktail(at indexPath: IndexPath)
}

class CocktailsListInteractor: CocktailsListInteractorProtocol {
    
    // MARK: - Properties: private
    
    private let service: CocktailService
    private let router: CocktailsListRouter
    
    private var cocktails: [Cocktail] = []
    
    // MARK: - Properties: public
    
    weak var view: CocktailsListView?
    
    // MARK: - Init
    
    init(router: CocktailsListRouter, service: CocktailService) {
        self.router = router
        self.service = service
    }
    
    // MARK: Public
    
    func load() {
        service.getCocktails(completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let cocktails):
                    self.cocktails = cocktails

                    self.view?.reload()
                case .failure(_):
                    self.view?.showAlert(Alert(title: "Oops...", message: NSLocalizedString("cocktails.error", comment: "")))
                    
                    self.view?.showReloadButton()
                }
            }
        })
    }
    
    func numberOfCocktails() -> Int {
        cocktails.count
    }
    
    func cocktail(at indexPath: IndexPath) -> Cocktail {
        cocktails[indexPath.row]
    }
    
    func selectCocktail(at indexPath: IndexPath) {
        router.routeToDetails(with: cocktail(at: indexPath))
    }
}
