//
//  POSBonjourPOCApp.swift
//  POSBonjourPOC
//
//  Created by ousama boujaouane on 05/06/2023.
//

import SwiftUI

@main
struct POSBonjourPOCApp: App {

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
