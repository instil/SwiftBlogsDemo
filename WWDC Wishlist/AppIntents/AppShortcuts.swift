//
//  AppShortcuts.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 11/04/2024.
//

import AppIntents
import SwiftData

class AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NewWishIntent(),
            phrases: [
                "create new wish in \(.applicationName)",
                "using \(.applicationName) create a new wish"
            ],
            shortTitle: "Create Wishlist Item",
            systemImageName: "sparkles"
        )
        
        AppShortcut(
            intent: OpenWishIntent(),
            phrases: [
                "open \(\.$wish) using \(.applicationName)"
            ],
            shortTitle: "Open Wish",
            systemImageName: "sparkles.square.filled.on.square"
        )
        
        AppShortcut(
            intent: UpdateWishStartusIntent(),
            phrases: [
                "update status of \(\.$wish) using \(.applicationName)"
            ],
            shortTitle: "Update Status",
            systemImageName: "wand.and.stars.inverse"
        )

    }
}


extension ModelContext {
    static func getContextForAppIntents() -> ModelContext {
        if let context = ModelContextProvider.context {
            return context
        }
        
        let schema = Schema([
            WishlistItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return .init(container)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
