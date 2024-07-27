

import SwiftUI
import Combine

class ColorSettings: ObservableObject {
    @Published var textColor: Color {
        didSet {
            saveColor()
        }
    }
    
    init() {
        self.textColor = Color.init(hex: 0xC0D06D)
        self.textColor = loadColor()
    }
    
    func saveColor() {
        let colorData = UIColor(textColor).cgColor.components
        UserDefaults.standard.set(colorData, forKey: "textColor")
    }
    
    private func loadColor() -> Color {
        guard let colorData = UserDefaults.standard.array(forKey: "textColor") as? [CGFloat],
              colorData.count >= 3 else {
            return Color.init(hex: 0xC0D06D) // Default color
        }
        return Color(red: colorData[0], green: colorData[1], blue: colorData[2])
    }
}
