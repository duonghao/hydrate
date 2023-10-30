//
//  ExpandableButton.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI

struct ExpandableButton<Label: View, Content: View>: View {
    
    @State private var isExpanded: Bool = false
    @Environment(\.expandableButtonStyle) private var style
    
    var orientation: Orientation = .vertical
    var direction: Direction = .up
    var action: (() -> Void)? = nil
    @ViewBuilder let label: () -> Label
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        style
            .makeBody(configuration: ExpandableButtonStyleConfiguration(
                orientation: orientation,
                direction: direction,
                action: action,
                label: ExpandableButtonStyleConfiguration.Label(label: label()),
                content: ExpandableButtonStyleConfiguration.Content(content: content()),
                isExpanded: $isExpanded)
            )
    }
}

#Preview("Vertical Expansion") {
        ExpandableButton(orientation: .vertical) {
            Label("", systemImage: "checkmark")
        } content: {
            Button {} label: {Label("", systemImage: "xmark")}
            Button {} label: {Label("", systemImage: "xmark")}
            Button {} label: {Label("", systemImage: "xmark")}
        }
        .buttonStyle(MainButtonStyle(buttonSize: 30))
}

#Preview("Horizontal Expansion") {
        ExpandableButton(orientation: .horizontal) {
            Label("", systemImage: "checkmark")
        } content: {
            Button {} label: {Label("", systemImage: "xmark")}
            Button {} label: {Label("", systemImage: "xmark")}
            Button {} label: {Label("", systemImage: "xmark")}
        }
        .buttonStyle(MainButtonStyle(buttonSize: 30))
}
