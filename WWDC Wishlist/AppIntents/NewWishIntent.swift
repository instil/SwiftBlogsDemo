//
//  NewWishIntent.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 11/04/2024.
//

import AppIntents

enum IntentError: Error, CustomLocalizedStringResourceConvertible {
    case coordinatorNotFound
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .coordinatorNotFound:
            "Something went wrong"
        }
    }
}

struct NewWishIntent: AppIntent {
    static var title: LocalizedStringResource = "Create New WWDC Wish"
    static var openAppWhenRun = true
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let navigationCoordinator = AppNavigationCoordinator.activeCoordinator else {
            throw IntentError.coordinatorNotFound
        }
        guard let sheetCoordinator = AppSheetCoordinator.activeCoordinator else {
            throw IntentError.coordinatorNotFound
        }
        
        navigationCoordinator.clear()
        sheetCoordinator.activeSheet = .newWishlistItem
        
        return .result(dialog: "Creating New Wish")
    }
}
