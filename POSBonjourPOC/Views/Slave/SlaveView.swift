//
//  SlaveView.swift
//  POC
//
//  Created by Jonathan Nguyen on 11/07/2023.
//

import SwiftUI

struct SlaveView: View {
    @StateObject var viewModel = SlaveViewModel()
    
    var body: some View {
        Form {
            Section("Available Ingredients", content: {
                List(viewModel.ingredients) { peer in
                    HStack {
                        Text(peer.name)
                        Text("\(peer.quantity)")
                    }
                }
            })
            
            Section("Pick your ingredients", content: {
                List(viewModel.selectedIngredients) { ingredient in
                    VStack {
                        Stepper("\(ingredient.name)\nQuantity: \(ingredient.quantity)",
                                onIncrement: {
                            viewModel.onIncrementIngredient(ingredient)
                        },
                                onDecrement: {
                            viewModel.onDecrementIngredient(ingredient)
                        })
                    }
                }
            })
            
            Button {
                viewModel.onConfirmOrder()
            } label: {
                Text("Confirm order")
            }
        }
        .onAppear(perform: {
            viewModel.startSession()
        })
        .onDisappear {
            viewModel.bonjourManager.stopSession()
        }
        .navigationTitle("Slave")

    }
}

struct SlaveView_Previews: PreviewProvider {
    static var previews: some View {
        SlaveView()
    }
}

