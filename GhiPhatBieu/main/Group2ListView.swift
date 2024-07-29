//
//  Group2ListView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 26/07/2024.
//

import SwiftUI
import ConfettiSwiftUI

struct Group2ListView: View {
    var groups: [[Student]]
    var viewModel: StudentViewModel
    @EnvironmentObject var colorSettings: ColorSettings
    @State var showCongrat1: Int = 0
    @State var showCongrat2: Int = 0
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.students.filter({ std in
                    groups[0].map { $0.id }.contains(std.id)
                })) { student in
                    StudentListItem(student: .constant(student))
                        .onTapGesture {
                            viewModel.updateScore(studentId: student.id, newScore: student.score + 1)
                            Helpers.shared.upStar()
                        }
                        .swipeActions {
                            Button("-1") {
                                viewModel.updateScore(studentId: student.id, newScore: student.score - 1)
                                Helpers.shared.downStar()
                            }
                            .tint(.red)
                        }
                }
            } header: {
                HStack(content: {
                    Text("Rabbit")
                        .foregroundStyle(colorSettings.textColor)
                    
                })
            } footer: {
                HStack{
                    Button("-2") {
                        updateGroupScore(0, score: -2)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    Button("-1") {
                        updateGroupScore(0, score: -1)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    Spacer()
                    Button("+1") {
                        updateGroupScore(0, score: 1)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorSettings.textColor)
                    Button("+2") {
                        updateGroupScore(0, score: 2)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorSettings.textColor)
                }
            }
            .overlay {
                EmptyView()
                    .confettiCannon(counter: $showCongrat1, colors: [colorSettings.textColor, .white], confettiSize: 20)
            }
            
            
            Section {
                ForEach(viewModel.students.filter({ std in
                    groups[1].map { $0.id }.contains(std.id)
                })) { student in
                    StudentListItem(student: .constant(student))
                        .onTapGesture {
                            viewModel.updateScore(studentId: student.id, newScore: student.score + 1)
                            Helpers.shared.upStar()
                        }
                        .swipeActions {
                            Button("-1") {
                                viewModel.updateScore(studentId: student.id, newScore: student.score - 1)
                                Helpers.shared.downStar()
                            }
                            .tint(.red)
                        }
                }
            } header: {
                HStack(content: {
                    Text("Turtle")
                        .foregroundStyle(colorSettings.textColor)
                })
            } footer: {
                HStack{
                    Button("-2") {
                        updateGroupScore(1, score: -2)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    Button("-1") {
                        updateGroupScore(1, score: -1)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    Spacer()
                    Button("+1") {
                        updateGroupScore(1, score: 1)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorSettings.textColor)
                    Button("+2") {
                        updateGroupScore(1, score: 2)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorSettings.textColor)
                }
            }
            .overlay {
                EmptyView()
                    .confettiCannon(counter: $showCongrat2, colors: [colorSettings.textColor, .white], confettiSize: 20)
            }

        }
        .navigationTitle("Groups")
    }
    
    private func updateGroupScore(_ groupIndex: Int, score: Int) {
        
        let newStudents = viewModel.students.filter({ std in
            groups[groupIndex].map { $0.id }.contains(std.id)
        }).map { student in
            Student(id: student.id, avatar: student.avatar, name: student.name, score: student.score + score, absents: student.absents)
        }
        viewModel.updateStudents(students: newStudents)
        
        if score > 0 {
            Helpers.shared.success()
            withAnimation {
                showCongrat1 = groupIndex == 0 ? showCongrat1 + 1 : showCongrat1
                showCongrat2 = groupIndex == 1 ? showCongrat2 + 1 : showCongrat2
            }
        } else {
            Helpers.shared.downStar()
        }
    }
}
