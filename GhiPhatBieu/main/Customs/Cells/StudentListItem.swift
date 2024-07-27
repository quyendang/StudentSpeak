//
//  StudentListItem.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 26/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct StudentListItem: View {
    @Binding var student: Student
    @State private var showParticles = false
    @State private var showStarReduction = false
    @EnvironmentObject var colorSettings: ColorSettings
    
    var body: some View {
        HStack {
            WebImage(url:  URL(string: student.avatar)) { image in
                image.resizable()
            } placeholder: {
                Circle().foregroundColor(colorSettings.textColor.opacity(0.25))
            }
            .indicator(content: { isAnimating, progress in
                ProgressView().tint(colorSettings.textColor)
            })
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 35, height: 35)
            .glowEffect(status: showParticles)
            .starReductionEffect(status: showStarReduction, isSound: false)
            
            Text(student.name)
                .foregroundColor(colorSettings.textColor)
            Spacer()
            Text("\(student.score)")
                .font(.footnote)
                .foregroundColor(colorSettings.textColor)
                .contentTransition(.numericText())
            Image(systemName: "star.fill")
                .foregroundColor(colorSettings.textColor)
        }
        .onChange(of: student.score) { oldValue, newValue in
            withAnimation {
                showStarReduction = newValue < oldValue
                showParticles = newValue > oldValue
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showParticles = false
                    showStarReduction = false
                }
            }
        }
    }
}
