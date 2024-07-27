//
//  StudentView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 09/07/2024.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct StudentView: View {
    @State private var score: Int
    @State private var isAbsent: Bool
    @State private var showParticles = false
    @State private var showStarReduction = false
    @State private var isHovering = false
    @EnvironmentObject var colorSettings: ColorSettings
    var isSound: Bool
    var student: Student
    var viewModel: StudentViewModel
    var imageSize: CGFloat
    var onStarChanged: ((Int) -> Void)?
    init(student: Student, viewModel: StudentViewModel, imageSize: CGFloat = 158, isSound: Bool = true, onStarChanged: @escaping ((Int)->Void) = { _ in }) {
        self.student = student
        self.viewModel = viewModel
        self.imageSize = imageSize
        self.isSound = isSound
        self.onStarChanged = onStarChanged
        _score = State(initialValue: student.score)
        _isAbsent = State(initialValue: student.absents.contains(Date().string))
    }
    
    var body: some View {
        VStack {
            VStack{
                WebImage(url:  URL(string: student.avatar == "" ? "https://api.dicebear.com/9.x/adventurer/jpg?seed=\(student.id)_boy&backgroundColor=FFE66D&size=300" : student.avatar)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle().foregroundColor(colorSettings.textColor.opacity(0.25))
                }
                .indicator(content: { isAnimating, progress in
                    ProgressView().tint(colorSettings.textColor)
                })
                
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .glowEffect(status: showParticles)
                .starReductionEffect(status: showStarReduction, isSound: isSound)
                .padding(.bottom, 10)
                
                Text(student.name)
                    .font(.title3)
                    .lineLimit(1, reservesSpace: false)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(colorSettings.textColor)
                    .particleEffect(systemImage: "star.fill", status: showParticles, activeTint: colorSettings.textColor, inActiveTint: .mainBg, isSound: isSound)
            }
            .grayscale(student.absents.contains(Date().string) ? 1 : 0)
                
            HStack {
                Spacer()
                Button(action: {
                    if !isAbsent{
                        viewModel.updateScore(studentId: student.id, newScore: score - 1)
                        onStarChanged?(-1)
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                })
                .foregroundColor(.red)
                Divider()
                    .frame(height: 30)
                HStack{
                    Text("\(score)")
                        .font(.title3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.mainBg)
                        .contentTransition(.numericText())
                    Image(systemName: "star.fill")
                        .renderingMode(.template)
                        .foregroundColor(.mainBg)
                }
                
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorSettings.textColor.opacity(0.7))
                )
                
                if (isAbsent) {
                    Button(action: {
                        if isAbsent{
                            viewModel.updateAabsent(studentId: student.id, isAbsents: false)
                        }
                    }, label: {
                        Image(systemName: "studentdesk")
                    })
                    .foregroundColor(.green)
                }
                Spacer()
            }
            .grayscale(student.absents.contains(Date().string) ? 1 : 0)
//            HStack{
//                Spacer()
//                Toggle(isOn: $isAbsent) {
//                    Image(systemName: "figure.run")
//                        .scaleEffect(x: isAbsent ? -1 : 1, y: 1, anchor: .center)
//                }
//                .toggleStyle(.button)
//                .tint(isAbsent ? Color.green : Color.red)
//                //.opacity(isHovering ?  1 : 0)
//                .onChange(of: isAbsent, { oldValue, newValue in
//                    viewModel.updateAabsent(studentId: student.id, isAbsents: newValue)
//                })
//            }
//            .padding(.top, 5)
        }
        
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .glowEffect(status: isHovering, radius: 10)
        .onHover(perform: { hovering in
            withAnimation {
                isHovering = hovering
            }
        })
        .onTapGesture {
            if !isAbsent {
                viewModel.updateScore(studentId: student.id, newScore: score + 1)
                onStarChanged?(1)
            }
        }
        .onChange(of: student.score, {
            withAnimation {
                score = student.score
            }
        })
        .onChange(of: student.score) { oldValue, newValue in
            withAnimation {
                score = student.score
                showStarReduction = newValue < oldValue
                showParticles = newValue > oldValue
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showParticles = false
                    showStarReduction = false
                }
            }
        }
        .onChange(of: student.absents, {
            isAbsent = student.absents.contains(Date().string)
        })
        .onAppear(perform: {
            
        })
        .background(
                            .regularMaterial,
                            in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                        )
    }
}
