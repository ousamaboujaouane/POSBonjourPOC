//
//  SlaveViewModel.swift
//  POC
//
//  Created by Jonathan Nguyen on 11/07/2023.
//

import SwiftUI

class SlaveViewModel: ObservableObject {
    
    @Published var bonjourManager: BonjourManager = BonjourManager()
    @Published var ingredients: [IngredientDataModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.selectedIngredients = self.ingredients.map({
                    return IngredientDataModel(name: $0.name, quantity: 0)
                })
            }
        }
    }
    @Published var selectedIngredients: [IngredientDataModel] = []
    
    func startSession() {
        self.bonjourManager.onDataReceived = { data in
            guard let ingredients = try? JSONDecoder().decode([IngredientDataModel].self, from: data)
            else { return }
            DispatchQueue.main.async {
                self.ingredients = ingredients
            }
        }
        
        self.bonjourManager.startSession(with: BonjourManager.slaveConfiguration)
    }
    
    func onConfirmOrder() {
        guard let data = try? JSONEncoder().encode(selectedIngredients)
        else { return }
        bonjourManager.updateMaster(with: data)
        
    }
    
    func onIncrementIngredient(_ ingredient: IngredientDataModel) {
        if let index = selectedIngredients.firstIndex(where: {$0.name == ingredient.name}) {
            selectedIngredients[index].quantity += 1
        }
    }
    
    func onDecrementIngredient(_ ingredient: IngredientDataModel) {
        if ingredient.quantity > 0 {
            if let index = selectedIngredients.firstIndex(where: {$0.name == ingredient.name}) {
                selectedIngredients[index].quantity -= 1
            }
        }
    }
}


