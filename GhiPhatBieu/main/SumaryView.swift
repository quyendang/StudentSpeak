//
//  SumaryView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 27/07/2024.
//

import SwiftUI
import Charts

struct SumaryView: View {
    @Binding var isPresented: Bool
    var students: [Student]
    var viewModel: StudentViewModel
    @EnvironmentObject var colorSettings: ColorSettings
    var body: some View {
        NavigationView(content: {
            List {
                Section("Student Rank | Absents") {
                    ForEach(Array(students.sorted(by: { $0.score > $1.score }).enumerated()), id: \.element.id) { index, student in
                        StudentInfoItem(student: .constant(student), studentIndex: index)
                    }
                }
                Section("Chart") {
                    Text("Ranking Chart")
                    Chart {
                        ForEach(students) { item in
                            BarMark(
                                x: .value("Name", item.name.lastName),
                                y: .value("Star", item.score)
                            )
                            
                        }
                    }
                    Text("Absents Chart")
                    Chart {
                        ForEach(students) { item in
                            LineMark(
                                x: .value("Name", item.name.lastName),
                                y: .value("Star", item.absents.count)
                            )
                            
                        }
                    }                }
                
            }
            .navigationTitle("Sumary")
            .navigationBarItems(trailing: Button(action: {
                let newStudents = viewModel.students.map { student in
                    Student(id: student.id, avatar: student.avatar, name: student.name, score: 0, absents: [])
                }
                viewModel.updateStudents(students: newStudents)
            }, label: {
                Text("Reset Data")
            })
                .tint(.red))
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }.tint(colorSettings.textColor))
        })
        
    }
}
