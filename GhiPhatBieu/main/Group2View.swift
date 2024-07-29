//
//  Group2View.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 26/07/2024.
//

import SwiftUI
import ConfettiSwiftUI

struct Group2View: View {
    var groups: [[Student]]
    var viewModel: StudentViewModel
    @State var showCongrat1: Int = 0
    @State var showCongrat2: Int = 0
    @AppStorage("issound") private var isSound: Bool = true
    @EnvironmentObject var colorSettings: ColorSettings
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let columnsCount = Int(screenWidth / 158)
            let numberOfColumns = min(columnsCount, 6)
            let numberOfColumnsByGroup: Int = numberOfColumns / 2
            let columns = Array(repeating: GridItem(.flexible(minimum: 158)), count: numberOfColumnsByGroup)
            HStack(spacing: 0) {
                VStack {
                    Text("Rabbit")
                        .font(.largeTitle)
                        .foregroundStyle(colorSettings.textColor)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                            ForEach(viewModel.students.filter({ std in
                                groups[0].map { $0.id }.contains(std.id)
                            })) { student in
                                StudentView(student: student, viewModel: viewModel, imageSize: geometry.size.width * 0.4 / CGFloat(numberOfColumns), isSound: false) { scoreChanged in
                                    if scoreChanged > 0 {
                                        Helpers.shared.upStar()
                                    } else {
                                        Helpers.shared.downStar()
                                    }
                                    
                                }
                                .foregroundColor(.green)
                            }
                        }
                    }
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
                        Image(systemName: "star.fill")
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
                    .controlSize(.extraLarge)
                    .padding()
                }
                .overlay {
                    EmptyView()
                        .confettiCannon(counter: $showCongrat1, num: 50, colors: [colorSettings.textColor, .white], confettiSize: 20, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 500)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(colorSettings.textColor.opacity(0.4), lineWidth: 5)
                )
                
                Divider()
                //                    .frame(width: 2)
                //                    .background(colorSettings.textColor.opacity(0.5))
                    .padding(10)
                
                VStack {
                    Text("Turtle")
                        .font(.largeTitle)
                        .foregroundStyle(colorSettings.textColor)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                            ForEach(viewModel.students.filter({ std in
                                groups[1].map { $0.id }.contains(std.id)
                            })) { student in
                                StudentView(student: student, viewModel: viewModel, imageSize: geometry.size.width * 0.4 / CGFloat(numberOfColumns), isSound: false) { scoreChanged in
                                    if scoreChanged > 0 {
                                        Helpers.shared.upStar()
                                    } else {
                                        Helpers.shared.downStar()
                                    }
                                }
                                    
                            }
                        }
                    }
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
                        Image(systemName: "star.fill")
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
                    .controlSize(.extraLarge)
                    .padding()
                }
                .overlay {
                    EmptyView()
                        .confettiCannon(counter: $showCongrat2, num: 50, colors: [colorSettings.textColor, .white], confettiSize: 20, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 500)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(colorSettings.textColor.opacity(0.4), lineWidth: 5)
                )
            }
            .padding(.horizontal, 10)
            .navigationTitle("Groups")
            
        }
    }
    
    private func updateGroupScore(_ groupIndex: Int, score: Int) {
        isSound = false
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
        isSound = true
    }
}

