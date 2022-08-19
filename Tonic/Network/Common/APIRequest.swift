//
//  APIRequest.swift
//  Tonic
//

import Foundation

protocol Request {
    
    /// Compiles the destination url.
    static func destination(_ path: String) -> URL?
}

/// Implementation for the API requests.
final class APIRequest: Request {
    
    // MARK: - Properties: public
    
    public static let server = "http://recruitmenttaskapi-env-1.eba-yxp4bns6.eu-west-2.elasticbeanstalk.com"
            
    public let path: String
    public let method: APIRequest.Method
    
    // MARK: - Init
    
    init(path: String, method: APIRequest.Method = .get) {
        self.path = path
        self.method = method
    }
    
    convenience init(_ endpoint: Endpoint, method: APIRequest.Method = .get) {
        self.init(path: endpoint.path, method: method)
    }
    
    // MARK: - Methods: public
    
    static func destination(_ path: String) -> URL? {
        guard let url = URL(string: APIRequest.server + path) else {
            return nil
        }
        return url
    }
}

extension APIRequest {
    
    /// List of request methods.
    enum Method: String {
        case get = "GET"
    }
    
    /// List of request endpoints.
    enum Endpoint {
        case cocktails
        case cocktail(_ id: String)
        
        var path: String {
            switch self {
            case .cocktails:
                return "/cocktails"
            case .cocktail(let id):
                return "/cocktails/\(id)"
            }
        }
    }
}
