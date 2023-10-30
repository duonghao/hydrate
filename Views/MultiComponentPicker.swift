//
//  Picker.swift
//  Hydrate
//
//  Created by Hao Duong on 26/10/2023.
//

import SwiftUI

struct MultiPicker: View  {

    typealias Label = String
    typealias Entry = String

    let data: [ (Label, [Entry]) ]
    @Binding var selection: [Entry]
    var showLabel: Bool = false
    
    init(data: [(Label, [Entry])], selection: Binding<[Entry]>, showLabel: Bool) {
        self.data = data
        self._selection = selection
        self.showLabel = showLabel
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.data.count) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(0..<self.data[column].1.count) { row in
                            Text(verbatim: self.data[column].1[row])
                                .tag(self.data[column].1[row])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    if showLabel {
                        Text(self.data[column].0).font(.title3)
                    }
                }
            }
        }
    }
}

#Preview {
        @State var data: [(String, [String])] = [
            ("hours", Array(0...10).map { "\($0)" }),
            ("min", Array(20...40).map { "\($0)" })
        ]
        @State var selection: [String] = [0, 100].map { "\($0)" }

        return VStack(alignment: .center) {
            Text(verbatim: "Selection: \(selection)")
            MultiPicker(data: data, selection: $selection, showLabel: true).frame(height: 300)
        }
        .padding()
}

