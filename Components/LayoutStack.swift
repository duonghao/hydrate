//
//  LayoutStack.swift
//  Hydrate
//
//  Created by Hao Duong on 29/10/2023.
//

import SwiftUI

enum Orientation {
    case vertical, horizontal
}

enum Direction {
    case up, down, left, right
}

struct LayoutStack<Content>: View where Content: View {

    let orientation: Orientation
    @ViewBuilder let content: () -> Content
    
    @ViewBuilder
    var body: some View {
        switch(orientation) {
        case .horizontal:
            HStack { content() }
        case .vertical:
            VStack { content() }
        }
    }
}

#Preview("Vertical Layout") {
    LayoutStack(orientation: .vertical) {
        Text("Hello")
        Text("World")
    }
}

#Preview("Horizontal Layout") {
    LayoutStack(orientation: .horizontal) {
        Text("Hello")
        Text("World")
    }
}
