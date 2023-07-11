//
//  ContentView.swift
//  POC
//
//  Created by Jonathan Nguyen on 27/06/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: MasterView(), label: {
                    Text("Master Device")
                        .font(.headline)
                        .foregroundColor(.blue)
                })
                
                NavigationLink(destination: SlaveView(), label: {
                    Text("Slave Device")
                        .font(.headline)
                        .foregroundColor(.green)
                })
            }
            .navigationTitle("Menu")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
