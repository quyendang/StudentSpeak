//
//  ForgotView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 27/07/2024.
//

import SwiftUI

struct ForgotView: View {
    @Binding var isPresented: Bool
    @State var showMessage = false
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
                            .tint(colorSettings.textColor.opacity(authModel.isAuthenticating ? 1 : 0))
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
                .frame(maxWidth: 600)
                .padding()
                .navigationTitle("Forgot password")
                .navigationBarItems(leading: Button("Cancle", action: {
                    isPresented = false
                }).tint(colorSettings.textColor))
                .alert(errorMesssage ?? "", isPresented: $showingAlert) {
                    Button("OK") { }
                }
                .alert(isPresented: $showMessage, content: {
                    forgotMessage
                })
            }
            
        })
    }
    
    var forgotMessage: Alert {
        Alert(title: Text("Message?"), message: Text("If this email address exists, an email to reset your password will be sent to this address."),
              primaryButton: .destructive (Text("Yes")) {
           
        },
              secondaryButton: .cancel(Text("No"))
        )
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
