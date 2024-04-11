//
//  AppNavigationCoordinator.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 09/04/2024.
//

import SwiftUI

@Observable
final class AppNavigationCoordinator: Coordinator {
    var navigationPath = NavigationPath()
    
    func navigate(to route: WishlistItem) {
        navigationPath.append(route)
    }
    
    func clear() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    static var activeCoordinator: AppNavigationCoordinator?
    
    required init() {
    }
}
