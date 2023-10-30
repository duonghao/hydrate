//
//  ButtonStyles.swift
//  Hydrate
//
//  Created by Hao Duong on 25/10/2023.
//

import Foundation
import SwiftUI

struct MainButtonStyle: ButtonStyle {
    
    var buttonSize: CGFloat? = nil

    func makeBody(configuration: Configuration) -> some View {
        Group {
            if let buttonSize = buttonSize {
                configuration.label
                    .frame(width: buttonSize, height: buttonSize)
                    
            } else {
                configuration.label
            }
        }
        .padding()
        .labelStyle(.iconOnly)
        .font(.title2)
        .foregroundStyle(.black)
        .background(.thickMaterial)
        .clipShape(.capsule)
        .shadow(radius: 5)
    }
}
