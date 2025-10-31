//
//  Todo_AppApp.swift
//  Todo App
//
//  Created by Ghenadie Isacenco on 31/10/2025.
//

import SwiftUI

@main
struct Todo_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
