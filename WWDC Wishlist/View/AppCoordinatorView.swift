//
//  AppCoordinatorView.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 09/04/2024.
//

import SwiftUI

struct AppCoordinatorView: View {
    @State var sheetCoordinator = AppSheetCoordinator.start()
    @State var appNavigationCoordinator = AppNavigationCoordinator.start()

    var body: some View {
        NavigationStack(path: $appNavigationCoordinator.navigationPath) {
            ContentView()
                .environment(sheetCoordinator)
                .environment(appNavigationCoordinator)
        }
        .sheet(item: $sheetCoordinator.activeSheet) {
            switch $0 {
            case .newWishlistItem:
                WishlistItemForm()
            case .newWishlistItemWith(let initialTitle):
                WishlistItemForm(title: initialTitle)
            case .itemDescriptionEdit(let item):
                DescriptionEditSheet(item: item)
            }
        }
    }
}

#Preview {
    AppCoordinatorView()
}
