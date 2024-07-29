//
//  AppSidebarCoordinator.swift
//  WWDC Wishlist
//
//  Created by Oisin Kelly on 27/06/2024.
//

import SwiftUI

enum SidebarTab {
    case wishlist
    case dictation
}

@Observable
final class AppSidebarCoordinator: Coordinator {
    static var activeCoordinator: AppSidebarCoordinator?

    var selectedTab: SidebarTab? = .wishlist

    required init() {}
}
