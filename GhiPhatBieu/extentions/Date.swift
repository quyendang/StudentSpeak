//
//  Date.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 20/07/2024.
//

import Foundation


import Foundation

extension Date {
    var dayOfWeek: Int? {
        let calendar = Calendar.current
        // Get the weekday component from the date
        return calendar.component(.weekday, from: self)
    }
    
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}

