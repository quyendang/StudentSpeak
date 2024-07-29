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
    @State private var showAlert = false
    var students: [Student]
    var viewModel: StudentViewModel
    @EnvironmentObject var colorSettings: ColorSettings
    
    var confirmReset: Alert {
        Alert(title: Text("Reset?"), message: Text("After reset, Num of Star and Absent will return 0 .\n\nDo you want to reset all data of this class?"),
              primaryButton: .destructive (Text("Yes")) {
            resetData()
        },
              secondaryButton: .cancel(Text("No"))
        )
    }
    
    private func resetData() {
        let newStudents = viewModel.students.map { student in
            Student(id: student.id, avatar: student.avatar, name: student.name, score: 0, absents: [])
        }
        viewModel.updateStudents(students: newStudents)
    }
    
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
                showAlert = true
            }, label: {
                Text("Reset")
            })
                .tint(.red))
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }.tint(colorSettings.textColor))
            .alert(isPresented: $showAlert, content: {
                confirmReset
            })
        })
        
    }
}
