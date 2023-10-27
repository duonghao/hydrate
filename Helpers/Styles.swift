//
//  ButtonStyles.swift
//  Hydrate
//
//  Created by Hao Duong on 25/10/2023.
//

import Foundation
import SwiftUI

struct MainButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 54)
            .font(.title2)
            .background(.thickMaterial)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ExpandableButtonLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
          Label(configuration)
                .labelStyle(.iconOnly)
                .padding()
      }
}



