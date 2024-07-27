import SwiftUI
import FirebaseAuth
import FirebaseStorage
import SDWebImageSwiftUI
struct AddClassroomForm: View {
    @ObservedObject var viewModel: ClassRoomViewModel
    @Binding var classroom: Classroom?
    @Binding var isPresented: Bool
    @State private var classroomName: String = ""
    @State private var students: [Student] = []
    @State private var showingAddStudentForm = false
    @State private var editingStudent: Student?
    @State private var selectedDays: Set<Int> = []
    @EnvironmentObject var colorSettings: ColorSettings
    var isEditMode: Bool {
        return classroom != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Classroom Details")) {
                    TextField("Classroom Name", text: $classroomName)
                }
                
                Section(header: Text("Students")) {
                    ForEach(students) { student in
                        StudentRow(student: Binding(get: {return student
                        }, set: { newStudent in
                            if let index = students.firstIndex(where: { $0.id == newStudent.id }) {
                                students[index] = newStudent
                            }
                        }))
                        .onTapGesture {
                            editingStudent = student
                            showingAddStudentForm.toggle()
                        }
                        .contextMenu {
                            Button(action: {
                                students.removeAll(where: {$0.id == student.id})
                            }) {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                            Button(action: {
                                editingStudent = student
                                showingAddStudentForm.toggle()
                            }) {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }
                        }
                    }
                    .onDelete { indexSet in
                        students.remove(atOffsets: indexSet)
                    }
                    
                    Button(action: {
                        //students.append(Student(id: UUID().uuidString, avatar: "", name: "", score: 0))
                        editingStudent = nil
                        showingAddStudentForm = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Student")
                        }
                    }
                    .tint(colorSettings.textColor)
                }
                Section(header: Text("Schedule")) {
                    HStack {
                        ForEach(1..<8, id: \.self) { day in
                            Toggle(isOn: Binding<Bool>(
                                get: { selectedDays.contains(day) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedDays.insert(day)
                                    } else {
                                        selectedDays.remove(day)
                                    }
                                }
                            )) {
                                Text(day.dateName)
                            }
                            .toggleStyle(.button)
                            .tint(colorSettings.textColor)
                        }
                    }
                }
            }
            .navigationTitle(isEditMode ? "Edit Classroom" : "New Classroom")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }.tint(colorSettings.textColor), trailing:  Button(isEditMode ? "Update" : "Add") {
                if !classroomName.isEmpty {
                    let studentDict = Dictionary(uniqueKeysWithValues: students.map { ($0.id, $0) })
                    let newClassroom = Classroom(id: classroom?.id ?? UUID().uuidString, name: classroomName, students: studentDict, time: Array(selectedDays))
                    if isEditMode {
                        viewModel.updateClassroom(classroom: newClassroom)
                    } else {
                        viewModel.addClassroom(classroom: newClassroom)
                    }
                    isPresented = false
                }
            }
                .keyboardShortcut(.defaultAction)
                .tint(colorSettings.textColor)
            )
            .onAppear {
                if let classroom = classroom {
                    classroomName = classroom.name
                    students = Array(classroom.students.values)
                    selectedDays = Set(classroom.time)
                }
            }
        }
        .sheet(isPresented: $showingAddStudentForm) {
            AddStudentForm(students: $students, student: $editingStudent, isPresented: $showingAddStudentForm) {
                
            }
        }
    }
}



//struct AddClassroomForm_Previews: PreviewProvider {
//    static var previews: some View {
//        AddClassroomForm(viewModel: ClassRoomViewModel(), isPresented: .constant(true))
//    }
//}
