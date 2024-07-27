//
//  StudentRow.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 23/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI
struct StudentRow: View {
    @Binding var student: Student
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
            
            Text(student.name)
            Spacer()
            Toggle(isOn: Binding(get: {
                return student.absents.contains(Date().string)
            }, set: { value in
                if value {
                    student.absents.append(Date().string)
                } else{
                    student.absents.removeAll { $0 == Date().string }
                }
            })) {
                Image(systemName: "figure.run")
            }
            .toggleStyle(.button)
            .tint(.red)
            .foregroundColor(colorSettings.textColor)
        }
    }
}

//#Preview {
//    StudentRow(student: Binding(get: return Student(id: UUID().uuidString, avatar: "", name: "Quyen", score: 10, absents: ["24/07/2024"]), set: { value in
//        
//    }))
//}
