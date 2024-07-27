//
//  StudentInfoItem.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 27/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct StudentInfoItem: View {
    @Binding var student: Student
    var studentIndex = 0
    @EnvironmentObject var colorSettings: ColorSettings
    
    var body: some View {
        HStack {
            Text("\(studentIndex+1)")
                .foregroundColor(colorSettings.textColor)
            Divider()
                .frame(height: 30)
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
            
            Text(student.name)
                .foregroundColor(colorSettings.textColor)
            Spacer()
            Text("\(student.score)")
                .font(.footnote)
                .foregroundColor(colorSettings.textColor)
                .contentTransition(.numericText())
            Image(systemName: "star.fill")
                .foregroundColor(colorSettings.textColor)
            Divider()
                .frame(height: 30)
            Text("\(student.absents.count)")
                .font(.footnote)
                .foregroundColor(.red)
            Image(systemName: "figure.run")
                .foregroundColor(.red)
        }
    }
}
