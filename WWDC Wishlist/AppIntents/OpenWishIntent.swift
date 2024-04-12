//
//  OpenWishIntent.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 12/04/2024.
//

import Foundation
import AppIntents
import SwiftData

struct OpenWishIntent: AppIntent {
    static var title: LocalizedStringResource = "Open WWDC Wish"
    static var openAppWhenRun = true
    
    @Parameter(title: "Wish")
    var wish: WishEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$wish)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let modelContext = ModelContext.getContextForAppIntents()
        guard let navigationCoordinator = AppNavigationCoordinator.activeCoordinator else {
            throw IntentError.coordinatorNotFound
        }
        
        let fetchDescriptor = FetchDescriptor<WishlistItem>()
        let items = try? modelContext.fetch(fetchDescriptor)
        guard let swiftDataItem = (items?.first { $0.id == wish.id }) else {
            throw IntentError.itemNotFound
        }
        
        navigationCoordinator.clear()
        navigationCoordinator.navigate(to: swiftDataItem)
        
        return .result(dialog: "Opening...")
    }
}
