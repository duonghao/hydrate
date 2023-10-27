//
//  ViewModifiers.swift
//  Hydrate
//
//  Created by Hao Duong on 27/10/2023.
//

import Foundation
import SwiftUI

struct SheetToolbarViewModifier: ViewModifier {
    
    let title: String
    var dismiss: DismissAction
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(title)
                        .font(.title3.bold())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "xmark")
                            .bold()
                            .padding(8)
                            .foregroundStyle(.gray.opacity(0.8))
                            .background(.gray.opacity(0.2))
                            .clipShape(.capsule)
                    }
                    .buttonStyle(.plain)
                }
            }
    }
}
