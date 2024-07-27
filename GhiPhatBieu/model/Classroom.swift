//
//  Classroom.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import Foundation


//
//struct Classroom: Identifiable {
//    var id: String
//    var name: String
//    var students: [Student]
//}


struct Classroom: Identifiable, Codable {
    var id: String
    var name: String
    var students: [String: Student]
    var time: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case students
        case time
    }
    
    init(id: String, name: String, students: [String: Student], time: [Int]) {
        self.id = id
        self.name = name
        self.students = students
        self.time = time
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        students = try container.decode([String: Student].self, forKey: .students)
        time = try container.decode([Int].self, forKey: .time)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(students, forKey: .students)
        try container.encode(time, forKey: .time)
    }
}

extension Classroom {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "students": students.mapValues { $0.toDictionary() },
            "time": time
        ]
    }
}


