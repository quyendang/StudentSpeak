//
//  CircularProgressView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 22/07/2024.
//

import Foundation
import SwiftUI


struct CircularProgressView: View {
    let progress: Double
    @EnvironmentObject var colorSettings: ColorSettings
    let label: String
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    colorSettings.textColor.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    colorSettings.textColor,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(colorSettings.textColor)

        }
    }
}
