//
//  GlowEffect.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 18/07/2024.
//

import Foundation
import SwiftUI


struct GlowEffect: ViewModifier {
    var status: Bool
    var radius: CGFloat
    func body(content: Content) -> some View {
        ZStack{
            content
                .blur(radius: status ? radius: 1)
                .animation(.easeOut(duration: 0.5), value: status)
            content
        }
    }
}


