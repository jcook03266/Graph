//
//  Graph_NetworksApp.swift
//  Graph Networks
//
//  Created by Justin Cook on 1/31/24.
//

import SwiftUI
import SwiftData

@main
struct Graph_NetworksApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}
