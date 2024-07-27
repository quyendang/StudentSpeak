//
//  GhiPhatBieuApp.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI
import Firebase

@main
struct GhiPhatBieuApp: App {
    var colorSettings = ColorSettings()
    
    init() {
        FirebaseApp.configure()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // configure
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(colorSettings.textColor)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(colorSettings.textColor)]
        appearance.backgroundColor = UIColor.mainBg
        appearance.titleTextAttributes = [.foregroundColor: UIColor(colorSettings.textColor)]
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor(colorSettings.textColor)] // fix text color
        appearance.backButtonAppearance = backItemAppearance
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(UIColor(colorSettings.textColor), renderingMode: .alwaysOriginal) // fix indicator color
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        UINavigationBar.appearance().tintColor = UIColor(colorSettings.textColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .dark)
                .environmentObject(AuthenticationModel())
                .environmentObject(colorSettings)
        }
    }
}
