//
//  PhotoPickerAndViewer.swift
//  WWDC Wishlist
//
//  Created by Jack Delaney on 25/04/2024.
//

import PhotosUI
import SwiftUI

struct PhotoPickerAndViwer: View {
    @State private var selectedItem: PhotosPickerItem?
    @Bindable private var item: WishlistItem

    init(selectedItem: PhotosPickerItem? = nil, item: WishlistItem) {
        self.selectedItem = selectedItem
        self.item = item
    }

    var image: Image? {
        guard let imageData = item.imageData else { return nil }
        guard let image = UIImage(data: imageData) else { return nil }

        return Image(uiImage: image)
    }

    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            PhotosPicker("Select Photo", selection: $selectedItem, matching: .images)
            image?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
        .onChange(of: selectedItem) {
            Task {
                if let loaded = try? await selectedItem?.loadTransferable(type: Image.self) {
                    let renderer = ImageRenderer(content: loaded)

                    if let uimage = renderer.uiImage {
                        item.imageData = uimage.pngData()
                    }

                } else {
                    print("Failed")
                }
            }
        }
    }
}
