//
//  WishlistContentView.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 09/04/2024.
//

import SwiftData
import SwiftUI

enum ModelContextProvider {
    static var context: ModelContext?
}

struct WishlistContentView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var items: [WishlistItem]

    @State private var sheetCoordinator = AppSheetCoordinator.start()
    @State private var appNavigationCoordinator = AppNavigationCoordinator.start()

    var body: some View {
        NavigationStack(path: $appNavigationCoordinator.navigationPath) {
            List {
                Section("") {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            HStack {
                                Image(systemName: item.status.imageName)
                                    .foregroundStyle(item.status.tint)

                                VStack(alignment: .leading) {
                                    Text(item.title)
                                    Text(item.descriptionText.isEmpty ? "--" : item.descriptionText)
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .onAppear {
                ModelContextProvider.context = _items.modelContext
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("There Are No Items In Your Wishlist", systemImage: "star.slash.fill")
                }
            }
            .navigationTitle("WWDC24 Wishlist")
            .navigationBarTitleDisplayMode(items.isEmpty ? .inline : .automatic)
            .toolbarBackground(Color(UIColor.systemGroupedBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: WishlistItem.self) { item in
                WishlistItemViewer(
                    selectedItem: item
                )
                .environment(sheetCoordinator)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        sheetCoordinator.activeSheet = .newWishlistItem
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .environment(sheetCoordinator)
            .environment(appNavigationCoordinator)
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }

        AppShortcuts.updateAppShortcutParameters()
    }
}
