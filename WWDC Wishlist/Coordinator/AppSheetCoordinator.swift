//
//  AppSheetCoordinator.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 09/04/2024.
//

import SwiftUI

enum AppSheet: Identifiable {
    case newWishlistItem
    case itemDescriptionEdit(WishlistItem)
    
    var id: String {
        switch self {
        case .newWishlistItem:
            "newWishlistItem"
        case .itemDescriptionEdit(let item):
            "itemDescriptionEdit-\(item.id)"
        }
    }
}

protocol Coordinator {
    static var activeCoordinator: Self? {get set}
    static func start() -> Self
    
    init()
}

extension Coordinator {
    static func start() -> Self {
        let coordinator = Self.init()
        
        Self.activeCoordinator = coordinator
        
        return coordinator
    }
}

@Observable
final class AppSheetCoordinator: Coordinator {
    var activeSheet: AppSheet?
    
    static var activeCoordinator: AppSheetCoordinator?
    
    required init() {
    }
}
