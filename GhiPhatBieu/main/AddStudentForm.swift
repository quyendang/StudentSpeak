//
//  AddStudentForm.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 21/07/2024.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth
import SDWebImageSwiftUI

struct AddStudentForm: View {
    @Binding var students: [Student]
    @Binding var student: Student?
    @State private var studentName: String = ""
    @State private var studentScore: Int = 0
    @State private var studentAvatar: String = "https://api.dicebear.com/9.x/adventurer/png?size=300&backgroundColor=FFE66D&seed=\(UUID().uuidString)"
    @Binding var isPresented: Bool
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isUploading = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @EnvironmentObject var colorSettings: ColorSettings
    @FocusState private var isStudentNameFocused: Bool
    var isEditMode: Bool {
        return student != nil
    }
    
    let onEditCompleted: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Details")) {
                    VStack{
                        HStack{
                            Spacer()
                            HStack{
                                Text("\(studentScore)")
                                Image(systemName: "star.fill")
                            }
                                .foregroundColor(.mainBg)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background{
                                   RoundedRectangle(cornerRadius: 10)
                                        .fill(colorSettings.textColor)
                                }
                        }
                        HStack{
                            Spacer()
                            VStack {
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                        .padding(.top, 20)
                                        .loadingEffect(status: isUploading)
                                } else {
                                    WebImage(url:  URL(string: studentAvatar)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Circle().foregroundColor(colorSettings.textColor.opacity(0.25))
                                    }
                                    .indicator(content: { isAnimating, progress in
                                        ProgressView().tint(colorSettings.textColor)
                                    })
                                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 200, height: 200)
                                    .padding(.top, 20)
                                }
                                HStack{
                                    Button(action: {
                                        sourceType = .camera
                                        showImagePicker = true
                                    }) {
                                        HStack{
                                            Image(systemName: "camera.fill")
                                            Text("Camera")
                                                
                                        }
                                        .foregroundColor(.mainBg)
                                    }
                                    .tint(colorSettings.textColor)
                                    .buttonStyle(.borderedProminent)
                                    .padding(.bottom, 20)
                                    Button(action: {
                                        sourceType = .photoLibrary
                                        showImagePicker = true
                                    }) {
                                        HStack{
                                            Image(systemName: "photo.on.rectangle")
                                            Text("Photo Library")
                                                
                                        }
                                        .foregroundColor(.mainBg)
                                    }
                                    .tint(colorSettings.textColor)
                                    .buttonStyle(.borderedProminent)
                                    .padding(.bottom, 20)
                                }
                            }
                            Spacer()
                        }
                    }
                    
                    TextField("Student Name", text: $studentName)
                        .focused($isStudentNameFocused)
                        .onSubmit {
                            addOrUpdate()
                        }
//                    Stepper(value: $studentScore) {
//                        HStack {
//                            Text("Student Score")
//                                .foregroundColor(colorSettings.textColor)
//                        }
//                    }
                    Button(action: {
                        addOrUpdate()
                    }, label: {
                        HStack {
                            Text(isEditMode ? "Update" : "Add")
                        }
                    })
                    .tint(colorSettings.textColor)
                    .disabled(isUploading)
                    .keyboardShortcut(.defaultAction)
                }
                
            }
            .navigationTitle(isEditMode ? "Edit Student" : "New Student")
            .navigationBarItems(leading: Button("Cancel") {
                if let editingStudent = student, let index = students.firstIndex(where: { $0.id == editingStudent.id }) {
                    if let imageUrl = URL(string: students[index].avatar) {
                        let storageRef = Storage.storage().reference(forURL: imageUrl.absoluteString)
                        storageRef.delete { error in
                            if let error = error {
                                print("Error deleting image: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    students.remove(at: index)
                }
                isPresented = false
            }.tint(colorSettings.textColor), trailing: Button(isEditMode ? "Update" : "Add") {
                addOrUpdate()
            }
                .disabled(isUploading)
                .keyboardShortcut(.defaultAction)
                .tint(colorSettings.textColor)
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(onImagePicked: { image in
                    if let image = image {
                        selectedImage = image
                        uploadImage(image) { url in
                            studentAvatar = url
                        }
                    }
                }, sourceType: sourceType)
            }
            .onAppear {
                
                if let editingStudent = student {
                    studentName = editingStudent.name
                    studentAvatar = editingStudent.avatar
                    studentScore = editingStudent.score
                }
                
                isStudentNameFocused = true
            }
        }
        
    }
    
    func addOrUpdate() {
        if studentName.isEmpty {
            return
        }
        
        if let editingStudent = student {
            if let index = students.firstIndex(where: { $0.id == editingStudent.id }) {
                students[index].name = studentName
                students[index].avatar = studentAvatar
                students[index].score = studentScore
                student = Student(id: editingStudent.id, avatar: studentAvatar, name: studentName, score: studentScore, absents: editingStudent.absents)
                onEditCompleted()
            }
        } else {
            students.append(Student(id: UUID().uuidString, avatar: studentAvatar, name: studentName, score: studentScore, absents: []))
        }
        isPresented = false
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("users/\(uid)/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        isUploading = true
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            isUploading = false
            guard error == nil else {
                print("Failed to upload image: \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Failed to get download URL: \(error!.localizedDescription)")
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    }
}
