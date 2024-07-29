//
//  TrainingData.swift
//  WWDC Wishlist
//
//  Created by Oisin Kelly on 27/06/2024.
//

import Foundation
import Speech

enum TrainingData {
    static let classes = [
        "Shape",
        "ShapeView",
        "UIViewControllerRepresentable",
        "UIViewRepresentable",
        "AngularGradient",
        "AnyShape",
        "AnyView",
        "AsyncImage",
        "Button",
        "ButtonBorderShape",
        "Canvas",
        "Capsule",
        "Circle",
        "Color",
        "ColorPicker",
        "ContainerRelativeShape",
        "ContentUnavailableView",
        "ControlGroup",
        "DatePicker",
        "DisclosureGroup",
        "Divider",
        "DocumentLaunchView",
        "EditButton",
        "Ellipse",
        "EllipticalGradient",
        "EmptyView",
        "ForEach",
        "Form",
        "Gauge",
        "GeometryReader",
        "GeometryReader3D",
        "Grid",
        "GridRow",
        "Group",
        "GroupBox",
        "HSplitView",
        "HStack",
        "HelpLink",
        "Image",
        "KeyframeAnimator",
        "Label",
        "LabeledContent",
        "LazyHGrid",
        "LazyHStack",
        "LazyVGrid",
        "LazyVStack",
        "LinearGradient",
        "Link",
        "List",
        "Menu",
        "MeshGradient",
        "ModifiedContent",
        "MultiDatePicker",
        "NavigationLink",
        "NavigationSplitView",
        "NavigationStack",
        "NavigationView",
        "NewDocumentButton",
        "OffsetShape",
        "OutlineGroup",
        "OutlineSubgroupChildren",
        "PasteButton",
        "Path",
        "PhaseAnimator",
        "Picker",
        "PlaceholderContentView",
        "ProgressView",
        "RadialGradient",
        "Rectangle",
        "RenameButton",
        "RotatedShape",
        "RoundedRectangle",
        "ScaledShape",
        "ScrollView",
        "ScrollViewReader",
        "Section",
        "SecureField",
        "SettingsLink",
        "ShareLink",
        "Slider",
        "Spacer",
        "Stepper",
        "Subview",
        "TabView",
        "Table",
        "Text",
        "TextEditor",
        "TextField",
        "TextFieldLink",
        "TimelineView",
        "Toggle",
        "UnevenRoundedRectangle",
        "VSplitView",
        "VStack",
        "ViewThatFits",
        "WindowVisibilityToggle",
        "ZStack",
        "ZStackContent3D"
    ]

    static let verbs = ["teach", "tell", "inform"]

    static func setupModel() async {
        let data = SFCustomLanguageModelData(
            locale: Locale(identifier: "en_US"),
            identifier: "co.instil.WWDC-Wishlist",
            version: "1.0"
        ) {
            SFCustomLanguageModelData.CustomPronunciation(grapheme: "ZStack", phonemes: ["z i: s t A: k"])
            SFCustomLanguageModelData.CustomPronunciation(grapheme: "ZStack", phonemes: ["z E d s t A: k"])

            SFCustomLanguageModelData.CustomPronunciation(grapheme: "SwiftUI", phonemes: ["S w I f t j U aI"])

            SFCustomLanguageModelData.PhraseCount(phrase: "Teach me something random in SwiftUI", count: 20)
            SFCustomLanguageModelData.PhraseCount(phrase: "Teach me about SwiftUI", count: 20)

            SFCustomLanguageModelData.PhraseCountsFromTemplates(classes: [
                "verb": verbs,
                "class": classes
            ]) {
                SFCustomLanguageModelData.TemplatePhraseCountGenerator.Template(
                    "<verb> me about <class> in SwiftUI",
                    count: 5_000
                )
                SFCustomLanguageModelData.TemplatePhraseCountGenerator.Template(
                    "<verb> me about the <class> in SwiftUI",
                    count: 5_000
                )
            }
        }

        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "swiftUIMl.bin"
        let outputFileUrl = docDirectory.appendingPathComponent(fileName)

        do {
            try await data.export(to: outputFileUrl)
        } catch {
            print(error)
        }
    }
}
