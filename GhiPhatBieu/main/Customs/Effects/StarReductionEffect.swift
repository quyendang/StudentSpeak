//
//  StarReductionEffect.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 21/07/2024.
//

import Foundation
import SwiftUI

struct StarReductionEffect: ViewModifier {
    var status: Bool
    var isSound: Bool = true
    func body(content: Content) -> some View {
        ZStack{
            content
                .blur(radius: status ? 2 : 0)
            Image(systemName: "star.slash.fill")
                .foregroundColor(status ? .red : .clear)
                .animation(.easeOut(duration: 0.5), value: status)
            
        }
        .onChange(of: status) { newValue in
            if newValue && isSound {
                Helpers.shared.downStar()
            }
        }
    }
}
