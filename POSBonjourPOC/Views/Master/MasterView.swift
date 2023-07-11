//
//  MasterView.swift
//  POC
//
//  Created by Jonathan Nguyen on 11/07/2023.
//

import SwiftUI
import CoreData
import Bonjour

struct MasterView: View {
        
    @StateObject var viewModel = MasterViewModel()
    @State private var selectedIngredients: [Ingredient] = []
    @State var ingredientName: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section("Ingredients", content: {
                    List(viewModel.ingredients) { peer in
                        HStack {
                            Text(peer.name ?? "")
                                .font(.headline)
                            Spacer()
                            Text("\(peer.quantity)")
                                .font(.subheadline)
                        }
                    }
                })
                
                Section("Update Ingredients") {
                    List(viewModel.ingredients) { ingredient in
                        VStack {
                            Stepper(ingredient.name ?? "",
                                    onIncrement: {
                                viewModel.incrementIngredient(ingredient: ingredient)
                            },
                                    onDecrement: {
                                if ingredient.quantity > 0 {
                                    viewModel.decrementIngredient(ingredient: ingredient)
                                }
                            })
                        }
                    }
                }
                
                Section("Add new ingredient") {
                    HStack {
                        TextField("Ingredient name", text: $ingredientName)
                        Button {
                            viewModel.addIngredient(ingredientName: ingredientName)
                        } label: {
                            Text("Add")
                                .font(.headline)
                        }
                    }                                      
                }
            }
        }
        .onAppear {
            viewModel.startSession()
            viewModel.fetchIngredients()
        }
        .onDisappear {
            viewModel.bonjourManager.stopSession()
        }
        .navigationTitle("Master")
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}


