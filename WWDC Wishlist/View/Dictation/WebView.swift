//
//  WebView.swift
//  WWDC Wishlist
//
//  Created by Oisin Kelly on 27/07/2024.
//

import SwiftUI
import WebKit

private struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let wkwebView = WKWebView()
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct WebViewSheet: View {
    @Environment(\.dismiss) var dismiss
    let link: SwiftUILink

    var body: some View {
        NavigationStack {
            WebView(url: link.url)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .navigationTitle(link.viewName)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
