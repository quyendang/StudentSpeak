//
//  ClassroomRow.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI

struct ClassroomRow: View {
    var classroom: Classroom
    @EnvironmentObject var colorSettings: ColorSettings
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(classroom.name)
                    .font(.title)
                    .foregroundColor(colorSettings.textColor)
                Spacer()
                Text("\(classroom.students.count)")
                    .font(.custom("OpenSans-Bold", size: 14))
                    .foregroundColor(colorSettings.textColor.opacity(0.7))
                Image(systemName: "person.fill")
                    .foregroundColor(colorSettings.textColor.opacity(0.7))
            }
            HStack(content: {
                if classroom.time.count > 0 {
                    ForEach(classroom.time, id: \.self) { day in
                        Toggle(isOn: .constant(true)) {
                            Text(day.dateName)
                        }
                        .toggleStyle(.button)
                        .tint(colorSettings.textColor)
                    }
                } else {
                    Toggle(isOn: .constant(true)) {
                        Text("NO SCHEDULE")
                    }
                    .toggleStyle(.button)
                    .tint(.gray)
                }
                
            })
        }
    }
}
