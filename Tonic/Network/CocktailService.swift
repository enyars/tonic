//
//  CocktailService.swift
//  Tonic
//

import Foundation
import UIKit

protocol CocktailService {
    
    /// Fetches the list of cocktails.
    func getCocktails(completion: @escaping (Result<[Cocktail], APIError>) -> Void)
}

class CocktailNetworkService: CocktailService {
    
    // MARK: Properties: private
    
    private let apiClient: APIClient
    
    // MARK: - Init
    
    init(apiClient: APIClient = APIClient.default) {
        self.apiClient = apiClient
    }
    
    // MARK: - Methods: public
    
    func getCocktails(completion: @escaping (Result<[Cocktail], APIError>) -> Void) {
        let request = APIRequest(.cocktails)
        
        apiClient.fetch(request) { result in
            switch result {
            case .success(let data):
                do {
                    let cocktails = try JSONDecoder().decode([Cocktail].self, from: data)
                    
                    completion(.success(cocktails))
                } catch _ {
                    completion(.failure(APIError.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
