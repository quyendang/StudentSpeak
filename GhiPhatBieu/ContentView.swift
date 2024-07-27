//
//  ContentView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authModel: AuthenticationModel
    
    var body: some View {
        ZStack {
            if authModel.user == nil {
                LoginView()
                    .environmentObject(authModel)
            } else {
                NavigationView{
                    MainView()
                }
                .navigationViewStyle(.stack)
                
                
            }
        }.onAppear{
            
            authModel.listenToAuthState()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationModel())
        .environment(\.colorScheme, .dark)
}
