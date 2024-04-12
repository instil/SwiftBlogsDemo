//
//  NewWishIntent.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 11/04/2024.
//

import AppIntents

enum IntentError: Error, CustomLocalizedStringResourceConvertible {
    case coordinatorNotFound
    case itemNotFound
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .coordinatorNotFound:
            "Something went wrong"
        case .itemNotFound:
            "That item does not exist"
        }
    }
}

struct NewWishIntent: AppIntent {
    static var title: LocalizedStringResource = "Create New WWDC Wish"
    static var openAppWhenRun = true
    
    @Parameter(title: "Title")
    var wishTitle: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("New Wish Named \(\.$wishTitle)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let navigationCoordinator = AppNavigationCoordinator.activeCoordinator else {
            throw IntentError.coordinatorNotFound
        }
        guard let sheetCoordinator = AppSheetCoordinator.activeCoordinator else {
            throw IntentError.coordinatorNotFound
        }
        
        navigationCoordinator.clear()
        sheetCoordinator.activeSheet = .newWishlistItemWith(initialTitle: self.wishTitle)
        
        return .result(dialog: "Creating New Wish")
    }
}
