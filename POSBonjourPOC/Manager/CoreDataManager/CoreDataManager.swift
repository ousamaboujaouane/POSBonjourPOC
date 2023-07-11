//
//  KitchenManager.swift
//  POC
//
//  Created by Jonathan Nguyen on 27/06/2023.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataManager: NSObject, ObservableObject {

    var persistentContainer: NSPersistentContainer
        
    override init() {
        persistentContainer = NSPersistentContainer(name: "POC")
        super.init()
        loadPersistentStore()
    }
    
    func loadPersistentStore() {
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("Erreur lors du chargement du magasin persistant : \(error)")
            }
        }        
    }
    
    func fetchIngredients() -> [Ingredient] {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        do {
            let fetchedIngredients = try persistentContainer.viewContext.fetch(fetchRequest)
            return fetchedIngredients
        } catch {
            print("Erreur lors de la récupération des ingrédients : \(error)")
            return []
        }
    }
    
    func addIngredient(name: String, quantity: Int) {
        let managedContext = persistentContainer.viewContext
        
        // Créer une nouvelle instance d'Ingredient
        let newIngredient = Ingredient(context: managedContext)
        newIngredient.name = name
        newIngredient.quantity = Int32(quantity)
        
        // Enregistrer les modifications dans le contexte
        do {
            try managedContext.save()
            print("Nouvel ingrédient ajouté avec succès.")
        } catch {
            print("Erreur lors de l'ajout de l'ingrédient : \(error)")
        }
    }

    
    func updateIngredientQuantity(ingredientName: String, quantity: Int) {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        do {
            let fetchedIngredients = try persistentContainer.viewContext.fetch(fetchRequest)
            
            if fetchedIngredients.count > 0 {
                for ingredient in fetchedIngredients {
                    if ingredient.name == ingredientName {
                        print("already exist")
                        ingredient.quantity = ingredient.quantity - Int32(quantity)
                        saveContext()
                    }
                }
            }
            
        } catch {
            print("Erreur lors de la récupération des ingrédients : \(error)")
        }        
    }
    
    func decrementIngredient(ingredient: Ingredient) {
        ingredient.quantity -= 1
        saveContext()
    }
    
    func incrementIngredient(ingredient: Ingredient) {
        ingredient.quantity += 1
        saveContext()
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("Erreur lors de l'enregistrement du contexte : \(error)")
            }
        }
    }
    
}
