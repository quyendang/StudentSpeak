//
//  Int.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 20/07/2024.
//

import Foundation

extension Int{
    var dateName: String {
        switch self {
        case 1: return "S"
        case 2: return "M"
        case 3: return "T"
        case 4: return "W"
        case 5: return "T"
        case 6: return "F"
        case 7: return "S"
        default: return ""
        }
    }
}
