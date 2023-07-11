//
//  Ingredient.swift
//  POC
//
//  Created by Jonathan Nguyen on 10/07/2023.
//

import CoreData

// Ingredient model for core data
class Ingredient: NSManagedObject, Encodable {
    enum CodingKeys : String, CodingKey { case quantity, name }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
    }
}

// Ingredient model for slave

struct IngredientDataModel: Codable, Identifiable {
    var id: UUID { return UUID() }
    var name: String
    var quantity: Int
}
