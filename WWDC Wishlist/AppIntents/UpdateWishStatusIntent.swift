//
//  UpdateWishStatusIntent.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 12/04/2024.
//

import AppIntents
import Foundation
import SwiftData
import SwiftUI

struct UpdateWishStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Update WWDC Wish Status"
    static var openAppWhenRun = false
    
    @Parameter(title: "Wish")
    var wish: WishEntity
    
    @Parameter(title: "Status")
    var wishStatus: WislistItemStatus
    
    static var parameterSummary: some ParameterSummary {
        Summary("Mark \(\.$wish) as \(\.$wishStatus)")
    }
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let modelContext = ModelContext.getContextForAppIntents()
        
        let fetchDescriptor = FetchDescriptor<WishlistItem>()
        let items = try? modelContext.fetch(fetchDescriptor)
        guard let swiftDataItem = (items?.first { $0.id == wish.id }) else {
            throw IntentError.itemNotFound
        }
        
        try modelContext.transaction {
            swiftDataItem.status = self.wishStatus
        }
        
        return .result(view: WishlistStatusButton(
            status: wishStatus,
            selection: .constant(wishStatus)
        ).padding())
    }
}
