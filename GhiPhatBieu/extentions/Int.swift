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
        case 1: return "Sun"
        case 2: return "Mon"
        case 3: return "Tue"
        case 4: return "Wed"
        case 5: return "Thu"
        case 6: return "Fri"
        case 7: return "Sat"
        default: return ""
        }
    }
}
