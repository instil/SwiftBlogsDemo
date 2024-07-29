//
//  SidebarListView.swift
//  WWDC Wishlist
//
//  Created by Oisin Kelly on 27/06/2024.
//

import SwiftUI

struct SidebarListView: View {
    @Bindable var appSidebarCoordinator: AppSidebarCoordinator

    var body: some View {
        List(selection: $appSidebarCoordinator.selectedTab) {
            NavigationLink(value: SidebarTab.wishlist) {
                Label("WWDC Wishlist", systemImage: "sparkles")
            }

            NavigationLink(value: SidebarTab.dictation) {
                Label("Teach me SwiftUI", systemImage: "questionmark.bubble")
            }
        }
        .navigationTitle("Swift Blogs Demo")
    }
}

#Preview {
    SidebarListView(appSidebarCoordinator: .start())
}
