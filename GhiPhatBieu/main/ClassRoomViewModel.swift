//
//  ClassRoomViewModel.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import Foundation
import Network
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class ClassRoomViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var classrooms: [Classroom] = []
    private lazy var databasePath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let ref = Database.database()
            .reference()
            .child("users/\(uid)/classrooms")
        return ref
    }()
    
    
    private lazy var storageRef: StorageReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let ref = Storage.storage()
            .reference()
            .child("users/\(uid)")
        return ref
    }()
    
    init(){
        fetchClassrooms()
    }
    
    func fetchClassrooms() {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.observe(.value) { snapshot in
            var newClassrooms: [Classroom] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let classroomData = snapshot.value as? [String: Any],
                   let classroom = self.parseClassroomData(id: snapshot.key, data: classroomData) {
                    newClassrooms.append(classroom)
                }
            }
            
            self.classrooms = newClassrooms.sorted { $0.name < $1.name }
        }
    }
    
//    func addClassroom(name: String) {
//        guard let databasePath = databasePath else {
//            return
//        }
//        let newClassroomRef = databasePath.childByAutoId()
//        let classroom = Classroom(id: newClassroomRef.key ?? UUID().uuidString, name: name, students: [:], time: [])
//        newClassroomRef.setValue(try! JSONEncoder().encode(classroom))
//    }
    
    func addClassroom(classroom: Classroom) {
        guard let databasePath = databasePath else {
            return
        }
        let newClassroomRef = databasePath.childByAutoId()
        newClassroomRef.setValue(classroom.toDictionary())
    }
    
    func updateClassroom(classroom: Classroom) {
        guard let databasePath = databasePath else {
            return
        }
        //databasePath.child(classroom.id).setValue(try! JSONEncoder().encode(classroom))
        databasePath.child(classroom.id).updateChildValues(classroom.toDictionary())
    }
    
    func deleteClassroom(classroom: Classroom) {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child(classroom.id).removeValue()
    }
    
    func deleteClassrooms(at offsets: IndexSet) {
        offsets.forEach { index in
            let classroom = classrooms[index]
            deleteClassroom(classroom: classroom)
        }
    }
    
    
    func parseClassroomData(id: String, data: [String: Any]) -> Classroom? {
        guard let name = data["name"] as? String,
              let studentsData = data["students"] as? [String: [String: Any]] else {
            return nil
        }
        
        let students = studentsData.compactMap { (key, value) -> Student? in
            return self.parseStudentData(id: key, data: value)
        }
        
        var time: [Int] = []
        if let timeData = data["time"] as? [Int] {
            time = timeData
        }
        
        
        let studentDict = Dictionary(uniqueKeysWithValues: students.map { ($0.id, $0) })
        
        return Classroom(id: id, name: name, students: studentDict, time: time)
    }
    
    func parseStudentData(id: String, data: [String: Any]) -> Student? {
        guard let name = data["name"] as? String,
              let score = data["score"] as? Int else {
            return nil
        }
        
        var absents: [String] = []
        if let absentsData = data["absents"] as? [String] {
            absents = absentsData
        }
        
        var avatar: String = "https://api.dicebear.com/9.x/adventurer/jpg?seed=\(id)_boy&backgroundColor=FFE66D&size=300"
        
        if let avatarData = data["avatar"] as? String {
            avatar = avatarData
        }
        
        return Student(id: id, avatar: avatar, name: name, score: score, absents: absents)
    }
    
    
    
}
