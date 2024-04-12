//
//  AppEnumImplementation.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 12/04/2024.
//

import AppIntents

extension WislistItemStatus: AppEnum, @unchecked Sendable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Item Status"
    
    static var caseDisplayRepresentations: [WislistItemStatus : DisplayRepresentation] {
        [
            .announced: "Announced",
            .rumoured: "Rumoured",
            .wish: "Wish"
        ]
    }
}
