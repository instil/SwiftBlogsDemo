//
//  WishlistItem.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 09/04/2024.
//

import Foundation
import SwiftData
import SwiftUI

enum WislistItemStatus: String, Codable, CaseIterable {
    case wish
    case rumoured
    case announced
    
    var imageName: String {
        switch self {
        case .wish:
            "sparkles"
        case .rumoured:
            "bubble.left.and.text.bubble.right.fill"
        case .announced:
            "party.popper.fill"
        }
    }
    
    var title: String {
        switch self {
        case .wish:
            "Wish"
        case .rumoured:
            "Rumoured"
        case .announced:
            "Announced"
        }
    }
    
    var tint: Color {
        switch self {
        case .wish:
            .indigo
        case .rumoured:
            .orange
        case .announced:
            .green
        }
    }
}

@Model
final class WishlistItem {
    let id = UUID()
    
    var title: String
    var descriptionText: String
    var timestamp: Date
    var status: WislistItemStatus
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    init(
        timestamp: Date,
        descriptionText: String,
        title: String,
        status: WislistItemStatus,
        imageData: Data?
    ) {
        self.timestamp = timestamp
        self.descriptionText = descriptionText
        self.title = title
        self.status = status
        self.imageData = imageData
    }
}
