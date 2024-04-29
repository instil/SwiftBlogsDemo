//
//  WishlistItemViewer.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 10/04/2024.
//

import SwiftUI

struct WishlistItemViewer: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(AppSheetCoordinator.self) private var sheetCoordinator
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var selectedItem: WishlistItem
    
    var visionOSPicker: some View {
        Picker("Status", selection: $selectedItem.status) {
            ForEach(WislistItemStatus.allCases, id: \.self) { status in
                Text(status.title)
            }
        }
        .pickerStyle(.navigationLink)
    }
    
    var statusSection: some View {
        Section("Status") {
            #if os(visionOS)
                visionOSPicker
            #else
                let statusButtons = {
                    ForEach(WislistItemStatus.allCases, id: \.title) {
                        WishlistStatusButton(
                            status: $0,
                            selection: $selectedItem.status
                        )
                    }
                }
            
                if horizontalSizeClass == .compact {
                    VStack {
                        statusButtons()
                    }
                } else {
                    HStack {
                        statusButtons()
                    }
                }
            #endif
        }
    }
    
    var body: some View {
        List {
            statusSection
            Section("Description") {
                if !selectedItem.descriptionText.isEmpty {
                    HStack {
                        Text(selectedItem.descriptionText)
                        
                        Spacer()
                        
                        Button("Edit") {
                            sheetCoordinator.activeSheet = .itemDescriptionEdit(selectedItem)
                        }
                    }
                } else {
                    HStack {
                        Text("--")
                        
                        Spacer()
                        
                        Button("Add Description \(Image(systemName: "plus"))") {
                            sheetCoordinator.activeSheet = .itemDescriptionEdit(selectedItem)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                    }
                }
            }
        }
        .navigationTitle(selectedItem.title)
        .navigationBarTitleDisplayMode(.large)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    let item = WishlistItem(
        timestamp: .now,
        descriptionText: "",
        title: "",
        status: .announced
    )

    return WishlistItemViewer(
        selectedItem: item
    )
}
