//
//  StudentViewModel.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 09/07/2024.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseAuth
import SwiftUI

class StudentViewModel: ObservableObject {
    @Published var students: [Student] = []
    private var classroomId: String
    private var studentScoresRefs: [DatabaseReference] = []
    @AppStorage("showAbsentStudent") private var showAbsentStudent: Bool = true
    
    private lazy var databasePath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let ref = Database.database()
            .reference()
            .child("users/\(uid)/classrooms")
        return ref
    }()
    
    
    
    init(classroomId: String) {
        self.classroomId = classroomId
        self.fetchStudents()
    }
    
    func fetchStudents() {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child(classroomId).child("students").observe(.value) { snapshot in
            var newStudents: [Student] = []
            self.studentScoresRefs.removeAll()  // Clear the previous references
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let studentData = snapshot.value as? [String: Any],
                   let student = self.parseStudentData(id: snapshot.key, data: studentData) {
                    newStudents.append(student)
                    
                    // Listen for score changes specifically
//                    let scoreRef = databasePath.child(self.classroomId).child("students").child(snapshot.key).child("score")
//                    scoreRef.observe(.value) { scoreSnapshot in
//                        if let newScore = scoreSnapshot.value as? Int, let index = newStudents.firstIndex(where: { $0.id == snapshot.key }) {
//                            newStudents[index].score = newScore
//                        }
//                    }
//                    self.studentScoresRefs.append(scoreRef)
//                    // Listen for absents changes specifically
//                    let absentsRef = databasePath.child(self.classroomId).child("students").child(snapshot.key).child("absents")
//                    absentsRef.observe(.value) { absentsSnapshot in
//                        if let newAbsents = absentsSnapshot.value as? [String], let index = newStudents.firstIndex(where: { $0.id == snapshot.key }) {
//                            newStudents[index].absents = newAbsents
//                        }
//                    }
//                    self.studentScoresRefs.append(scoreRef)
                }
            }
            
            if !self.showAbsentStudent {
                newStudents.removeAll { $0.absents.contains(Date().string)}
            }
            
            let presentStudents = newStudents.filter { student in
                !student.absents.contains(Date().string)
            }.sorted { $0.name.lastName < $1.name.lastName }
            let absentStudents = newStudents.filter { student in
                student.absents.contains(Date().string)
            }.sorted { $0.name.lastName < $1.name.lastName }
            
            self.students = presentStudents + absentStudents
        }
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
    
    func addStudent(name: String, avatar: String) {
        guard let databasePath = databasePath else {
            return
        }
        let newStudentRef = databasePath.child(classroomId).child("students").childByAutoId()
        let student = Student(id: newStudentRef.key ?? UUID().uuidString, avatar: avatar, name: name, score: 0, absents: [])
        newStudentRef.setValue(student.toDictionary())
    }
    
    func updateStudent(student: Student) {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child(classroomId).child("students").child(student.id).setValue(student.toDictionary())
    }
    
    func updateStudents(students: [Student]) {
        guard let databasePath = databasePath else {
            return
        }

        var updates: [String: Any] = [:]
        
        for student in students {
            let studentPath = "students/\(student.id)"
            updates[studentPath] = student.toDictionary()
        }

        databasePath.child(classroomId).updateChildValues(updates) { error, _ in
            if let error = error {
                print("Error updating students: \(error.localizedDescription)")
            } else {
                print("Successfully updated students")
            }
        }
    }
    
    
    private func updateClassTime() {
        guard let databasePath = databasePath else {
            return
        }
        let currentDateNumber = Date().dayOfWeek!
        let timeRef = databasePath.child(classroomId).child("time")
        timeRef.observeSingleEvent(of: .value) { snapshot in
            if var timeArray = snapshot.value as? [Int] {
                if !timeArray.contains(currentDateNumber) {
                    timeArray.append(currentDateNumber)
                    timeArray = timeArray.suffix(3)
                    timeRef.setValue(timeArray) { error, _ in
                        if let error = error {
                            print("Error updating time array: \(error.localizedDescription)")
                        } else {
                            print("Successfully updated time array")
                        }
                    }
                }
                
            } else {
                let newArray = [currentDateNumber]
                timeRef.setValue(newArray) { error, _ in
                    if let error = error {
                        print("Error setting time array: \(error.localizedDescription)")
                    } else {
                        print("Successfully set time array")
                    }
                }
            }
        }
    }
    
    func deleteStudent(student: Student) {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child(classroomId).child("students").child(student.id).removeValue()
    }
    
    func updateScore(studentId: String, newScore: Int) {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child(classroomId).child("students").child(studentId).child("score").setValue(newScore) { error, _ in
            if error == nil {
                if let index = self.students.firstIndex(where: { $0.id == studentId }) {
                    
                    
                    self.students[index].score = newScore
                }
            }
        }
        
        updateClassTime()
        // databasePath.child(classroomId).child("students").child(studentId).child("score").setValue(newScore)
    }
    
    func updateAabsent(studentId: String, isAbsents: Bool) {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child(classroomId).child("students").child(studentId).child("absents").setValue(isAbsents ? [Date().string] : []) { error, _ in
            if error == nil {
                if let index = self.students.firstIndex(where: { $0.id == studentId }) {
                    self.students[index].absents = [ Date().string]
                }
            }
        }
    }
}
