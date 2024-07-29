//
//  AppCoordinatorView.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 09/04/2024.
//

import SwiftUI

struct AppCoordinatorView: View {
    @State var appSidebarCoordinator: AppSidebarCoordinator = .start()

    var body: some View {
        NavigationSplitView {
            SidebarListView(appSidebarCoordinator: appSidebarCoordinator)
        } detail: {
            switch appSidebarCoordinator.selectedTab {
            case .wishlist:
                WishlistContentView()
            case .dictation:
                DictationContentView()
            case .none:
                Text("yes")
            }
        }
    }
}

#Preview {
    AppCoordinatorView()
}
