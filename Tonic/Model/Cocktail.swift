//
//  Cocktail.swift
//  Tonic
//

import Foundation

/// Cocktail model.
class Cocktail: Decodable {
    
    /// Cocktail id.
    let id: String
    
    /// Cocktail name.
    let name: String
    
    /// Cocktail image url.
    let imageUrl: String
    
    /// Cocktail glass requirement.
    let glass: String?
    
    /// Cocktail instructions.
    let instructions: String?
    
    /// Cocktail ingredients list.
    let ingredients: [Ingredient]?
}

/// Ingredient model.
struct Ingredient: Decodable {
    
    /// Ingredient name.
    let name: String
    
    /// Ingredient measure.
    let measure: String?
}

/// Ingredient identifiable (with name as id).
extension Ingredient: Identifiable {
    var id: String { name }
}
