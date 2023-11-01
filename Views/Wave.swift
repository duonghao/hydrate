//
//  WaveView.swift
//  Hydrate
//
//  Created by Hao Duong on 24/10/2023.
//

import SwiftUI

struct Wave: Shape {
    
    var heightFraction: Double
    var strength: Double
    var frequency: Double
    var phase: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(Double(phase), Double(heightFraction))
        }

        set {
            phase = newValue.first
            heightFraction = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        let correctedHeightFraction = max(0, 1 - heightFraction)
        
        let width = Double(rect.width)
        let midWidth = width / 2
        let oneOverMidWidth = 1 / midWidth
        
        let height = Double(rect.height)
        let midHeight = height / 2
        let startHeight = height * correctedHeightFraction
        
        let wavelength = width / frequency
        
        path.move(to: CGPoint(x: 0, y: startHeight))
        for x in stride(from: 0, through: width, by: 3) {
            let relativeX = x / wavelength
            
            let distanceFromMidWidth = x - midWidth
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            let parabola = normalDistance
            
            let y = startHeight + sin(phase + relativeX) * strength * normalDistance
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: startHeight))
        path.close()
        
        return Path(path.cgPath)
    }
    
    
}

struct WaveView: View {
    
    private enum PhaseState: Double {
        case start = 0
        case end = 6.28 // 2 * .pi
        
        mutating func toggle() {
            switch self {
            case .start:
                self = .end
            case .end:
                self = .start
            }
        }
    }
    
    @State private var phase: PhaseState = .start
    var heightFraction: Double
    var strength: Double = 10
    var frequency: Double = 25
    
    var body: some View {
        Wave(heightFraction: heightFraction, strength: strength, frequency: frequency, phase: phase.rawValue)
            .animation(.linear(duration: 1), value: heightFraction)
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                        self.phase = .end
                    }
                }
            }
            .onChange(of: heightFraction, { oldValue, newValue in
                withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                    self.phase = .start
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.phase = .end
                    }
                }
            })
    }
}

#Preview {
    WaveView(heightFraction: 0.3)
        .foregroundStyle(.blue.gradient)
}
