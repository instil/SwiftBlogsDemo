//
//  DescriptionEditSheet.swift
//  WWDC Wishlist
//
//  Created by Caleb Wilson on 11/04/2024.
//

import SwiftUI

struct DescriptionEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var item: WishlistItem
    @State private var description: String
    
    init(item: WishlistItem) {
        self.item = item
        self._description = State(initialValue: item.descriptionText)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Description") {
                    TextField(
                        "Wishlist Entry Description",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(5, reservesSpace: true)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Description For \(item.title)")
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
                        item.descriptionText = description
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}
