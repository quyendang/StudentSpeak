//
//  LoadingEffect.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 20/07/2024.
//

import Foundation
import SwiftUI

struct LoadingEffect: ViewModifier {
    var status: Bool
    @EnvironmentObject var colorSettings: ColorSettings
    func body(content: Content) -> some View {
        ZStack{
            content
                .blur(radius: status ? 2 : 0)
            ProgressView()
                .tint(status ? colorSettings.textColor : .clear)
                .animation(.easeOut(duration: 0.5), value: status)
            
        }
    }
}
