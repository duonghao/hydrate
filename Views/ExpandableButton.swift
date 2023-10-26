//
//  ExpandableButton.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI

struct ExpandableButton<Label: View, Content: View>: View {
    
    enum Orientation {
        case horizontal, vertical
    }
    
    @State private var isExpanded: Bool = false
    let action: (() -> Void)?
    let label: Label
    let content: Content
    let orientation: Orientation
    
    init(action: (() -> Void)? = nil, @ViewBuilder label: () -> Label,  @ViewBuilder content: () -> Content, orientation: Orientation = .vertical) {
        self.label = label()
        self.action = action
        self.content = content()
        self.orientation = orientation
    }
    
    var body: some View {
        Group {
            if orientation == .vertical {
                VStack {
                    expandableButton
                }
            } else {
                HStack {
                    expandableButton
                }
            }
        }
    }
    
    @ViewBuilder
    private var expandableButton: some View {
        if isExpanded {
            content
        }
        
        Button {
            // Action taken care of by tap gesture
        } label: {
            label
        }
        .simultaneousGesture(LongPressGesture().onEnded { _ in
            withAnimation {
                isExpanded.toggle()
                
            }
        })
        .simultaneousGesture(TapGesture().onEnded {
            action?()
        })
    }
    
}

#Preview {
    return VStack {
        Spacer()
        ExpandableButton {
            Label("", systemImage: "checkmark")
                .labelStyle(ExpandableButtonLabelStyle())
        } content: {
            Label("", systemImage: "checkmark")
                .labelStyle(ExpandableButtonLabelStyle())
            Label("", systemImage: "checkmark")
                .labelStyle(ExpandableButtonLabelStyle())
            Label("", systemImage: "checkmark")
                .labelStyle(ExpandableButtonLabelStyle())
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 5)
    }
}
