////
////  Color.swift
////  GhiPhatBieu
////
////  Created by Quyen DanG on 21/07/2024.
////
//
//import Foundation
//import SwiftUI
//
//extension Color {
//    static var textCl: Color {
//        return .red
//    }
//}
//
//extension UIColor {
//    static var textCl: UIColor {
//        return UIColor.red
//    }
//}

import SwiftUI

extension Color {
    var uiColor: UIColor {
        return UIColor(self)
    }
    
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
