//
//  MasterViewModel.swift
//  POC
//
//  Created by Jonathan Nguyen on 11/07/2023.
//

import SwiftUI

class MasterViewModel: ObservableObject {
    
    @Published var bonjourManager = BonjourManager()
    @Published var coreDataManager = CoreDataManager()
    @Published var ingredients: [Ingredient] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updatePeers(with: self.ingredients)
            }
        }
    }
     
    func startSession() {
        self.bonjourManager.onDataReceived = { data in
            guard let ingredients = try? JSONDecoder().decode([IngredientDataModel].self, from: data)
            else { return }
                
                for ingredient in ingredients {
                    DispatchQueue.main.async {
                        self.coreDataManager.updateIngredientQuantity(ingredientName: ingredient.name, quantity: ingredient.quantity)
                        self.fetchIngredients()
                        self.updatePeers(with: self.ingredients)
                    }
                }
        }
        
        self.bonjourManager.onPeerConnected = { peer in
            self.updatePeers(with: self.ingredients)
        }
        
        self.bonjourManager.startSession(with: BonjourManager.masterConfiguration)
    }
    
    func fetchIngredients() {
        ingredients = coreDataManager.fetchIngredients()
    }
    
    func addIngredient(ingredientName: String) {
        coreDataManager.addIngredient(name: ingredientName, quantity: 1)
        fetchIngredients()
    }
    
    func decrementIngredient(ingredient: Ingredient) {
        ingredient.quantity -= 1
        coreDataManager.saveContext()
        fetchIngredients()
    }
    
    func incrementIngredient(ingredient: Ingredient) {
        ingredient.quantity += 1
        coreDataManager.saveContext()
        fetchIngredients()        
    }
    
    func updatePeers(with ingredients: [Ingredient])  {
        guard let data = try? JSONEncoder().encode(ingredients)
        else { return }
        bonjourManager.updatePeers(with: data)
    }
}
