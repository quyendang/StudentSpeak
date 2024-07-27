//
//  ForgotView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 27/07/2024.
//

import SwiftUI

struct ForgotView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var colorSettings: ColorSettings
    @EnvironmentObject var authModel: AuthenticationModel
    @Binding var email: String
    @State private var errorMesssage: String?
    @State private var showingAlert = false
    var body: some View {
        NavigationView(content: {
            ZStack(alignment: .top){
                Color.mainBg.ignoresSafeArea()
                VStack(content: {
                    TextFieldView(string: self.$email,
                        passwordMode: false,
                        placeholder: "Enter your email",
                        iconName: "envelope.fill")
                    HStack{
                        Spacer()
                        ProgressView()
                            .tint(colorSettings.textColor)
                            .padding()
                        Button(action: {
                            forgot()
                        }, label: {
                            HStack(content: {
                                Image(systemName: "hand.raised.fill")
                                Text("Reset")
                                    .font(.custom("OpenSans-Medium", size: 25))
                            })
                            .padding(.horizontal, 30)
                        })
                        .tint(colorSettings.textColor)
                        .foregroundColor(.mainBg)
                        .buttonStyle(.borderedProminent)
                        .alert(errorMesssage ?? "", isPresented: $showingAlert) {
                            Button("OK") { }
                        }
                    }
                })
                .padding()
                .navigationTitle("Forgot password")
                .alert(errorMesssage ?? "", isPresented: $showingAlert) {
                    Button("OK") { }
                }
            }
            
        })
    }
    
    func forgot() {
        if email == "" {
            self.errorMesssage = "Please enter your email!"
            self.showingAlert = true
            return
        }
        
        authModel.forgot(email: email) { error in
            
        }
    }
}
