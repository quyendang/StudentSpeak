//
//  View.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 21/07/2024.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func particleEffect(systemImage: String, status: Bool, activeTint: Color, inActiveTint: Color, isSound: Bool = true) -> some View {
        self
            .modifier(ParticleModifier(systemImage: systemImage, status: status, activeTint: activeTint, inActiveTint: inActiveTint, isSound: isSound))
    }
    
    @ViewBuilder
    func glowEffect(status: Bool, radius: CGFloat = 25) -> some View {
        self.modifier(GlowEffect(status: status, radius: radius))
    }
    
    @ViewBuilder
    func starReductionEffect(status: Bool, isSound: Bool = true) -> some View {
        self.modifier(StarReductionEffect(status: status, isSound: isSound))
    }
    
    @ViewBuilder
    func loadingEffect(status: Bool) -> some View {
        self.modifier(LoadingEffect(status: status))
    }
    
    
    func shadowedStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
    }
}
