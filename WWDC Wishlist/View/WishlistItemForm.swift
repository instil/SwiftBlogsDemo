//
//  WishlistItemForm.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 10/04/2024.
//

import SwiftUI

struct WishlistStatusButton: View {
    let status: WislistItemStatus
    
    @Binding var selection: WislistItemStatus
    
    var body: some View {
        Button {
            withAnimation {
                selection = status
            }
        } label: {
            HStack {
                Image(systemName: status.imageName)
                Text(status.title)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(status.tint)
            .font(.title2)
            .fontWeight(selection == status ? .semibold : .regular)
                
        }
        .buttonStyle(.bordered)
        .tint(status.tint)
        .opacity(selection == status ? 1 : 0.3)
    }
}

struct WishlistItemForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var title = ""
    @State private var description = ""
    @State private var status = WislistItemStatus.wish

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField(
                        "Wishlist Entry Title",
                        text: $title
                    )
                }
                
                Section("Description") {
                    TextField(
                        "Wishlist Entry Description",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(5, reservesSpace: true)
                }
                
                Section("Status") {
                    let statusButtons = {
                        ForEach(WislistItemStatus.allCases, id: \.title) {
                            WishlistStatusButton(
                                status: $0,
                                selection: $status
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
                }
            }
            .navigationTitle("New Wishlist Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color(UIColor.secondarySystemGroupedBackground),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        createItem()
                        dismiss()
                    }
                    .bold()
                    .disabled(title.isEmpty)
                }
            }
        }.interactiveDismissDisabled()
    }
    
    private func createItem() {
        modelContext.insert(
            WishlistItem(
                timestamp: .now,
                descriptionText: description,
                title: title,
                status: status
            )
        )
    }
}

#Preview {
    NavigationStack {
        WishlistItemForm()
    }
}
