//
//  WWDC_WishlistApp.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 09/04/2024.
//

import SwiftUI
import SwiftData

@main
struct WWDC_WishlistApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WishlistItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup(for: UUID.self) { id in
            AppCoordinatorView()
        }
        .modelContainer(sharedModelContainer)
    }
}
