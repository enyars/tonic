//
//  APIClient.swift
//  Tonic
//

import Foundation
import UIKit

/// A protocol for performing API requests.
protocol Client {
    
    /// Fetches a request.
    func fetch(_ request: APIRequest, completion: @escaping (Result<Data, APIError>) -> Void)
    
    /// Downloads an image from a url.
    static func download(_ imageUrl: String, completion: @escaping ((UIImage?) -> Void))
}

final class APIClient: Client {
    
    // MARK: Properties: public
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: Methods: public
    
    func fetch(_ request: APIRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = APIRequest.destination(request.path) else {
            return completion(.failure(.invalidURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
                
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completion(.failure(.error(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 400...600:
                    completion(.failure(.serviceError))
                    return
                default:
                    break
                }
            }
            
            guard let data = data else {
                return completion(.failure(.unknown))
            }
        
            completion(.success(data))
        }
            
        task.resume()
    }
    
    static func download(_ imageUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imageUrl) else {
            return completion(nil)
        }
        
        if let cachedImage = APIClient.imageCache.object(forKey: imageUrl as NSString) {
            return completion(cachedImage)
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                return completion(nil)
            }
            
            APIClient.imageCache.setObject(image, forKey: imageUrl as NSString)
            
            return completion(image)
        }
            
        task.resume()
    }
}

extension APIClient {
    static let `default` = APIClient()
}
