//
//  MainView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authModel: AuthenticationModel
    @ObservedObject var viewModel = ClassRoomViewModel()
    @State private var showingAddClassroomForm = false
    @State private var showingSetting = false
    @State private var editingClassroom: Classroom?
    @EnvironmentObject var colorSettings: ColorSettings
    var body: some View {
        ZStack {
           // Color.mainBg.edgesIgnoringSafeArea(.all)
            List {
                if viewModel.classrooms.contains(where: { $0.time.contains(Date().dayOfWeek!) }) {
                    Section(header: Text("Today")) {
                        ForEach(viewModel.classrooms.filter { classroom in
                            classroom.time.contains(Date().dayOfWeek!)
                        }) { classroom in
                            NavigationLink(destination: {
                                ClassroomDetailView(classroom: classroom)
                            }, label: {
                                ClassroomRow(classroom: classroom)
                            })
                            //.listRowBackground(Color.mainBg)
                            .contextMenu {
                                Button(action: {
                                    viewModel.deleteClassroom(classroom: classroom)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                                Button(action: {
                                    editingClassroom = classroom
                                    showingAddClassroomForm.toggle()
                                }) {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deleteClassrooms)
                    }
                }
                if viewModel.classrooms.count > 0 {
                    Section(header: Text("All")) {
                        ForEach(viewModel.classrooms) { classroom in
                            NavigationLink(destination: {
                                ClassroomDetailView(classroom: classroom)
                                    
                            }, label: {
                                ClassroomRow(classroom: classroom)
                                    
                            })
                            //.listRowBackground(Color.mainBg)
                            .contextMenu {
                                Button(action: {
                                    viewModel.deleteClassroom(classroom: classroom)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                                Button(action: {
                                    editingClassroom = classroom
                                    showingAddClassroomForm.toggle()
                                }) {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                            }
                        }
                        
                        .onDelete(perform: viewModel.deleteClassrooms)
                    }
                }
                
            }
            .listStyle(.automatic)
            .scrollContentBackground(.hidden)
            .background(Color.mainBg)
            .overlay {
                if viewModel.classrooms.count == 0 {
                    ContentUnavailableView {
                        Label("No Classroom", systemImage: "exclamationmark.triangle")
                    } description: {
                        VStack{
                            Text("Please wait or start by adding a new class")
                        }
                    } actions: {
                        Button("Add Classroom") {
                            editingClassroom = nil
                            showingAddClassroomForm.toggle()
                        }
                        .buttonStyle(.bordered)
                        .tint(colorSettings.textColor)
                        .foregroundColor(colorSettings.textColor)
                    }
                }
            }
        }
        .navigationTitle("Classrooms")
        //.navigationBarColor(backgroundColor: Color.mainBg.uiColor, textColor: colorSettings.textColor.uiColor)
        .navigationBarItems(trailing: Button("Logout", action: authModel.signout).tint(.red))
        .navigationBarItems(trailing: Button(action: {
            editingClassroom = nil
            showingAddClassroomForm.toggle()
        }, label: {
            Image(systemName: "plus.app.fill")
        }).tint(colorSettings.textColor))
        .sheet(isPresented: $showingAddClassroomForm, content: {
            AddClassroomForm(viewModel: viewModel, classroom: $editingClassroom, isPresented: $showingAddClassroomForm)
        })
        .navigationBarItems(trailing: Button(action: {
            showingSetting.toggle()
        }, label: {
            Image(systemName: "gearshape.fill")
        }).tint(colorSettings.textColor))
        .sheet(isPresented: $showingSetting) {
            SettingView(isPresented: $showingSetting)
                .environmentObject(viewModel)
        }
        
    }
    func delete(at offsets: IndexSet) {
        
    }
}

#Preview {
    MainView()
        .environmentObject(AuthenticationModel())
        .environment(\.colorScheme, .dark)
}
