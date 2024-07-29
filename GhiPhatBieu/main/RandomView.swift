//
//  RandomView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 10/07/2024.
//

import SwiftUI

struct RandomView: View {
    
    var students: [Student]
    var viewModel: StudentViewModel
    @Binding var isPresented: Bool
    let onShuffle: () -> Void
    @State var studentChanged = false
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var colorSettings: ColorSettings
    var body: some View {
       
        VStack{
            Text("Random Students")
                .font(.title)
                .foregroundColor(colorSettings.textColor)
            HStack(content: {
                ForEach(Array(viewModel.students.filter({ std in
                    students.map { $0.id }.contains(std.id)
                }).enumerated()), id: \.element.id) { index, student in
                    StudentView(student: student, viewModel: viewModel, imageSize: sizeClass == .compact ? 128 : 200)
                        .frame(maxWidth: 300)
                        .transition(.scale)
                    if students.count > 1 && index < students.count - 1 {
                        Text("VS")
                            .font(.title)
                            .foregroundColor(colorSettings.textColor)
                    }
                }
            })
            HStack{
                Button(action: {
                    withAnimation {
                        onShuffle()
                        Helpers.shared.randomStudent()
                    }
                }, label: {
                    HStack{
                        Image(systemName: "shuffle")
                        Text("Pick again")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(colorSettings.textColor)
                .foregroundColor(.mainBg)
                
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    HStack{
                        Image(systemName: "xmark")
                        Text("Done")
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .foregroundColor(.mainBg)
            }
            .padding()
        }
        .onAppear(perform: {
            withAnimation {
                onShuffle()
                Helpers.shared.randomStudent()
            }
            
            
            
        })
        .padding(EdgeInsets(top: 30, leading: 24, bottom: 30, trailing: 24))
        .background(
                            .regularMaterial,
                            in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                        )
        .shadowedStyle()
        .padding(.horizontal, 40)
    }
}

