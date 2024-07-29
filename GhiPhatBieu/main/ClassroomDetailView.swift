//
//  ClassroomDetailView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI
import PopupView
import AlertToast

struct ClassroomDetailView: View {
    @State private var showPopupRandom = false
    @State private var showEditStudentForm = false
    @State private var showSumary = false
    @State private var showToast = false
    @State private var studentAbsent = Student(id: "", avatar: "", name: "", score: 0, absents: [])
    @State private var editingStudent: Student?
    @State private var selectedStudents: [Student] = []
    @State private var remainingStudents: [Student] = []
    @ObservedObject var viewModel: StudentViewModel
    @State private var numOfSelectStudent = 1
    @State private var navigateToGroup2View = false
    @State private var navigateToGroup2ListView = false
    @State private var groups: [[Student]] = []
    @State private var halfGroups: [[Student]] = [[], []]
    
    @EnvironmentObject var colorSettings: ColorSettings
    var classroom: Classroom
    @AppStorage("studentNameVoice") private var studentNameVoice: Bool = true
    
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    //    var columns: [GridItem] {
    //        Array(repeating: .init(.flexible()), count: sizeClass == .compact ? 2 : 6)
    //    }
    
    //    var columns: [GridItem] {
    //        [GridItem(.adaptive(minimum: 128))]
    //    }
    
    init(classroom: Classroom) {
        self.classroom = classroom
        self.viewModel = StudentViewModel(classroomId: classroom.id)
//        _remainingStudents = State(initialValue: Array(classroom.students.values.filter({ student in
//            !student.absents.contains(Date().string)
//        })))
    }
    
    
    var body: some View {
        ZStack{
            Color.mainBg.ignoresSafeArea()
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let columnsCount = Int(screenWidth / 158)
                let numberOfColumns = min(columnsCount, 6)
                let columns = Array(repeating: GridItem(.flexible(minimum: 158)), count: numberOfColumns)
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 30, content: {
                        ForEach(viewModel.students) { student in
                            StudentView(student: student, viewModel: viewModel, imageSize: geometry.size.width * 0.4 / CGFloat(numberOfColumns))
                                .contextMenu {
                                    Button(action: {
                                        let newStudentReset = Student(id: student.id, avatar: student.avatar, name: student.name, score: 0, absents: [])
                                        viewModel.updateStudent(student: newStudentReset)
                                    }) {
                                        Text("Reset")
                                        Image(systemName: "clock.arrow.circlepath")
                                    }
                                    Button(action: {
                                        viewModel.deleteStudent(student: student)
                                    }) {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                    Button(action: {
                                        editingStudent = student
                                        showEditStudentForm = true
                                    }) {
                                        Text("Edit")
                                        Image(systemName: "pencil")
                                    }
                                    Button(action: {
                                        showToast = true
                                        studentAbsent = Student(id: student.id, avatar: student.avatar, name: student.name, score: student.score, absents: student.absents.contains(Date().string) ? [] : [Date().string])
                                        if studentAbsent.absents.contains(Date().string) {
                                            Helpers.shared.goOut()
                                        } else {
                                            Helpers.shared.goIn()
                                        }
                                        viewModel.updateAabsent(studentId: student.id, isAbsents: !student.absents.contains(Date().string))
                                    }) {
                                       
                                        Text(student.absents.contains(Date().string) ? "Present" : "Absent")
                                        Image(systemName: !student.absents.contains(Date().string) ? "figure.run" : "studentdesk")
                                    }
                                }
                        }
                    })
                    .padding()
                }
            }
            
        }
        .navigationTitle(classroom.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            numOfSelectStudent = 1
            showPopupRandom = true
        }, label: {
            Image(systemName: "1.square.fill")
        }).tint(colorSettings.textColor))
        .navigationBarItems(trailing: Button(action: {
            numOfSelectStudent = 2
            showPopupRandom = true
        }, label: {
            Image(systemName: "2.square.fill")
        }).tint(colorSettings.textColor))
        .navigationBarItems(trailing: Button(action: {
            divideStudentsInHalf()
            navigateToGroup2ListView = sizeClass == .compact
            navigateToGroup2View = sizeClass != .compact
        }, label: {
            Image(systemName: "square.split.2x1.fill")
        }).tint(colorSettings.textColor))
        
        .navigationBarItems(trailing: Button(action: {
            showSumary = true
        }, label: {
            Image(systemName: "sum")
        }).tint(colorSettings.textColor))
        
        .sheet(isPresented: $showSumary, content: {
            SumaryView(isPresented: $showSumary, students: viewModel.students, viewModel: viewModel)
        })
        .sheet(isPresented: $showEditStudentForm) {
            AddStudentForm(students: .constant(viewModel.students), student: $editingStudent, isPresented: $showEditStudentForm) {
                if let editingStudent = self.editingStudent, let index = viewModel.students.firstIndex(where: { $0.id == editingStudent.id }) {
                    //
                    print(editingStudent)
                    viewModel.updateStudent(student: editingStudent)
                }
                
            }
        }
        .popup(isPresented: $showPopupRandom) {
            RandomView(students: selectedStudents, viewModel: viewModel, isPresented: $showPopupRandom) {
                selectRandomStudents(count: numOfSelectStudent)
            }
        } customize: {
            $0
                .appearFrom(.bottomSlide)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.6))
        }
        .background(
            NavigationLink(destination: Group2ListView(groups: halfGroups, viewModel: viewModel), isActive: $navigateToGroup2ListView) {
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: Group2View(groups: halfGroups, viewModel: viewModel), isActive: $navigateToGroup2View) {
                EmptyView()
            }
        )
        .toast(isPresenting: $showToast, duration: 2) {
            AlertToast(displayMode: .banner(.slide), type: .systemImage(studentAbsent.absents.contains(Date().string) ? "figure.run" : "studentdesk", colorSettings.textColor), title: "\(studentAbsent.name)", subTitle: studentAbsent.absents.contains(Date().string) ? "Absent!" : "Present!")
                
        }
        
    }
    
    private func selectRandomStudents(count: Int) {
        if remainingStudents.count < count {
            remainingStudents = Array(viewModel.students.filter({ student in
                !student.absents.contains(Date().string)
            }))
        }
        
        selectedStudents.removeAll()
        for _ in 0..<count {
            if let student = remainingStudents.randomElement() {
                selectedStudents.append(student)
                remainingStudents.removeAll { $0.id == student.id }
            }
        }
        
        if studentNameVoice {
            let stringTTS = selectedStudents.map({$0.name}).joined(separator: " và ")
            viewModel.convertTextToSpeech(stringTTS)
            //viewModel
        }
        
        
    }
    
    private func divideStudentsInHalf() {
        let shuffledStudents = viewModel.students.filter({ student in
            !student.absents.contains(Date().string)
        }).shuffled()
        let midpoint = shuffledStudents.count / 2
        halfGroups[0] = Array(shuffledStudents[0..<midpoint])
        halfGroups[1] = Array(shuffledStudents[midpoint..<shuffledStudents.count])
    }
}
