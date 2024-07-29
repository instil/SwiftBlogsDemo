//
//  DictationViewModel.swift
//  WWDC Wishlist
//
//  Created by Oisin Kelly on 27/06/2024.
//

import CoreML
import Foundation
import NaturalLanguage
import Speech

struct SwiftUILink: Identifiable {
    var id = UUID()
    var viewName: String

    var url: URL! {
        URL(string: "https://developer.apple.com/documentation/swiftui/\(viewName)")!
    }
}

@Observable
class DictationViewModel {
    var text: String = ""
    var buttonDisabled: Bool = true
    var viewLink: SwiftUILink?

    private let speechRecogniser = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))!
    private let audioEngine = AVAudioEngine()

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    private var lmConfiguration: SFSpeechLanguageModel.Configuration {
        let outputDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dynamicLanguageModel = outputDir.appendingPathComponent("LM")
        let dynamicVocabulary = outputDir.appendingPathComponent("Vocab")
        return SFSpeechLanguageModel.Configuration(languageModel: dynamicLanguageModel, vocabulary: dynamicVocabulary)
    }

    private var tagScheme: NLTagScheme {
        NLTagScheme("Class")
    }

    private func buildCustomModel() throws -> NLModel {
        let model = try SwiftUITagger(configuration: MLModelConfiguration()).model

        return try NLModel(mlModel: model)
    }

    private func buildTagger() throws -> NLTagger {
        let tagger = NLTagger(tagSchemes: [.nameType, tagScheme])
        tagger.string = text
        try tagger.setModels([buildCustomModel()], forTagScheme: tagScheme)

        return tagger
    }

    private func setUpAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }

    private func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        try setUpAudioSession()

        beginRecognition()

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        text = "Ask me something about SwiftUI..."
    }

    private func beginRecognition() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.requiresOnDeviceRecognition = true
        recognitionRequest.customizedLanguageModel = lmConfiguration

        recognitionTask = speechRecogniser.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else {
                return
            }

            var isFinal = false

            if let result = result {
                self.text = result.bestTranscription.formattedString
                isFinal = result.isFinal

                if isFinal {
                    self.analyseText(result.bestTranscription.formattedString)
                }
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.buttonDisabled = false
            }
        }
    }

    private func analyseText(_ text: String) {
        do {
            let tagger = try buildTagger()

            tagger.enumerateTags(
                in: text.startIndex ..< text.endIndex,
                unit: .word,
                scheme: tagScheme,
                options: .omitWhitespace)
            { tag, tokenRange in
                if let tag = tag {
                    let tagName = tag.rawValue

                    if tagName == "CLASS" {
                        viewLink = .init(viewName: String(text[tokenRange]))
                        return false
                    }
                }

                return true
            }

            print(viewLink?.url.absoluteString)
        } catch {
            print(error)
        }
    }

    func setup() {
        Task.detached {
            await TrainingData.setupModel()

            SFSpeechRecognizer.requestAuthorization { authStatus in
                switch authStatus {
                case .authorized:
                    Task.detached {
                        do {
                            let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileName = "swiftUIMl.bin"
                            let outputFileUrl = docDirectory.appendingPathComponent(fileName)
                            try await SFSpeechLanguageModel
                                .prepareCustomLanguageModel(for: outputFileUrl,
                                                            clientIdentifier: "co.instil.WWDC-Wishlist",
                                                            configuration: self.lmConfiguration)
                        } catch {
                            print("Failed to prepare custom LM: \(error.localizedDescription)")
                        }
                        self.buttonDisabled = false
                    }
                default:
                    self.buttonDisabled = true
                }
            }
        }
    }

    func onButtonClick() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            buttonDisabled = true
        } else {
            do {
                try startRecording()
            } catch {
                print("Recording not available")
            }
        }
    }
}
