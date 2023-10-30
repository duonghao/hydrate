//
//  ExpandableButtonStyle.swift
//  Hydrate
//
//  Created by Hao Duong on 29/10/2023.
//

import SwiftUI

protocol ExpandableButtonStyle {
    associatedtype Body: View
    typealias Configuration = ExpandableButtonStyleConfiguration
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

struct ExpandableButtonStyleConfiguration {
    
    struct Label: View {
        init<LabelContent: View>(label: LabelContent) {
            body = AnyView(label)
        }
        
        var body: AnyView
    }
    
    struct Content: View {
        init<Content: View>(content: Content) {
            body = AnyView(content)
        }
        
        var body: AnyView
    }
    
    let orientation: Orientation
    let direction: Direction
    let action: (() -> Void)?
    let label: ExpandableButtonStyleConfiguration.Label
    let content: ExpandableButtonStyleConfiguration.Content
    @Binding public var isExpanded: Bool
}

struct ExpandableButtonStyleKey: EnvironmentKey {
    static var defaultValue = AnyExpandableButtonStyle(style: DefaultExpandableButtonStyle())
}

extension EnvironmentValues {
    var expandableButtonStyle: AnyExpandableButtonStyle {
        get { self[ExpandableButtonStyleKey.self] }
        set { self[ExpandableButtonStyleKey.self] = newValue }
    }
}

extension View {
    func expandableButtonStyle<S: ExpandableButtonStyle>(_ style: S) -> some View {
        environment(\.expandableButtonStyle, AnyExpandableButtonStyle(style: style))
    }
}

struct AnyExpandableButtonStyle: ExpandableButtonStyle {
    private var _makeBody: (Configuration) -> AnyView
    
    init<S: ExpandableButtonStyle>(style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

struct DefaultExpandableButtonStyle: ExpandableButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        LayoutStack(orientation: configuration.orientation) {
            if configuration.direction == .left || configuration.direction == .up
            {
                content(configuration: configuration)
                button(configuration: configuration)
            } else {
                button(configuration: configuration)
                content(configuration: configuration)
            }
        }
    }
    
    @ViewBuilder
    private func content(configuration: Configuration) -> some View {
        if configuration.isExpanded {
            configuration.content
        }
    }
    
    private func button(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isExpanded.toggle()
            }
            configuration.action?()
        } label: {
            configuration.label
        }
    }
}

struct ChevronExpandableButtonStyle: ExpandableButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        LayoutStack(orientation: configuration.orientation) {
            if configuration.direction == .left || configuration.direction == .up
            {
                content(configuration: configuration)
                button(configuration: configuration)
            } else {
                button(configuration: configuration)
                content(configuration: configuration)
            }
        }
    }
    
    @ViewBuilder
    private func content(configuration: Configuration) -> some View {
        if configuration.isExpanded {
            configuration.content
        }
    }
    
    private func button(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isExpanded.toggle()
            }
            configuration.action?()
        } label: {
            Label("\(configuration.isExpanded ? "Expanded" : "Unexpanded") Button", systemImage: configuration.orientation == .vertical ? "chevron.up" : "chevron.left")
                .rotationEffect(configuration.isExpanded ? .degrees(180) : .degrees(0))
        }
    }
}


