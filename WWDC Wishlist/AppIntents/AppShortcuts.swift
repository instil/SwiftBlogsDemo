//
//  AppShortcuts.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 11/04/2024.
//

import AppIntents

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
    }
}
