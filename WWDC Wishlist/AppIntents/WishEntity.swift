//
//  WishEntity.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 12/04/2024.
//

import Foundation
import AppIntents
import SwiftData

struct WishEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Wishlist Item"
    
    static var defaultQuery = WishEntityQuery()

    let id: UUID
    
    @Property(title: "Wishlist Item Title")
    var title: String
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)"
        )
    }
    
    init(swiftDataModel: WishlistItem) {
        self.id = swiftDataModel.id
        self.title = swiftDataModel.title
    }
}

struct WishEntityQuery: EntityQuery {
    func entities(for identifiers: [WishEntity.ID]) async throws -> [WishEntity] {
        let modelContext = ModelContext.getContextForAppIntents()
        let fetchDescriptor = FetchDescriptor<WishlistItem>(
            predicate: #Predicate { identifiers.contains($0.id) }
        )
        
        return try modelContext
            .fetch(fetchDescriptor)
            .map(WishEntity.init)
    }
    
    
    func suggestedEntities() async throws -> [WishEntity] {
        let modelContext = ModelContext.getContextForAppIntents()
        let fetchDescriptor = FetchDescriptor<WishlistItem>()
        
        return try modelContext
            .fetch(fetchDescriptor)
            .map(WishEntity.init)
    }
}
