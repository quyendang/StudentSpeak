//
//  Student.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import Foundation

//struct Student: Identifiable {
//    var id: String
//    var avatar: String
//    var name: String
//    var score: Int
//}
struct Student: Identifiable, Codable {
    var id: String
    var avatar: String
    var name: String
    var score: Int
    var absents: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatar
        case name
        case score
        case absents
    }
    
    init(id: String, avatar: String, name: String, score: Int, absents: [String]) {
        self.id = id
        self.avatar = avatar
        self.name = name
        self.score = score
        self.absents = absents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        avatar = try container.decode(String.self, forKey: .avatar)
        name = try container.decode(String.self, forKey: .name)
        score = try container.decode(Int.self, forKey: .score)
        absents = try container.decode([String].self, forKey: .absents)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(name, forKey: .name)
        try container.encode(score, forKey: .score)
        try container.encode(absents, forKey: .absents)
    }
}
extension Student {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "avatar": avatar,
            "name": name,
            "score": score,
            "absents": absents
        ]
    }
}
