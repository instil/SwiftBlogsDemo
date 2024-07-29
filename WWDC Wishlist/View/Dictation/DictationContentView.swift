//
//  DictationContentView.swift
//  WWDC Wishlist
//
//  Created by Oisin Kelly on 27/06/2024.
//

import SwiftUI

struct DictationContentView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = DictationViewModel()
    @State private var isRecording = false

    var body: some View {
        VStack {
            textEditorView
            recordButtonView
        }
        .onAppear(perform: viewModel.setup)
        .navigationTitle("Dictation")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.vertical)
        .sheet(item: $viewModel.viewLink) { WebViewSheet(link: $0) }
    }

    private var textEditorView: some View {
        TextEditor(text: $viewModel.text)
            .scrollContentBackground(.hidden)
            .background {
                Image(systemName: "mic.and.signal.meter.fill")
                    .resizable()
                    .foregroundStyle(.quinary)
                    .scaledToFit()
                    .padding(100)
                    .symbolEffect(.variableColor.dimInactiveLayers.iterative, options: .repeating, isActive: isRecording)
            }
            .contentMargins(20, for: .scrollContent)
    }

    private var recordButtonView: some View {
        Button {
            isRecording.toggle()
            viewModel.onButtonClick()
        } label: {
            Image(systemName: "waveform.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .scaleEffect(isRecording ? 1.1 : 1)
                .animation(.default, value: isRecording)
                .symbolEffect(.variableColor.dimInactiveLayers.iterative, options: .repeating, isActive: isRecording)
        }
        .disabled(viewModel.buttonDisabled)
    }
}

#Preview {
    DictationContentView()
}
