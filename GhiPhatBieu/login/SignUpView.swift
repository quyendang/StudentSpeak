//
//  SignUpView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 27/07/2024.
//

import SwiftUI
import FirebaseAuth
struct SignUpView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var colorSettings: ColorSettings
    @EnvironmentObject var authModel: AuthenticationModel
    @Binding var email: String
    @Binding var password: String
    @State var repassword = ""
    @State private var errorMesssage: String?
    @State private var showingAlert = false
    var body: some View {
        NavigationView(content: {
            ZStack(alignment: .top){
                Color.mainBg.ignoresSafeArea()
                VStack(content: {
                    TextFieldView(string: self.$email,
                        passwordMode: false,
                        placeholder: "Enter email",
                        iconName: "envelope.fill")
                    TextFieldView(string: self.$password,
                        passwordMode: true,
                        placeholder: "Enter password",
                        iconName: "lock.open.fill")
                    TextFieldView(string: self.$repassword,
                        passwordMode: true,
                        placeholder: "Re-enter the password",
                        iconName: "lock.open.fill")
                    HStack{
                        Spacer()
                        ProgressView()
                            .tint(colorSettings.textColor.opacity(authModel.isAuthenticating ? 1 : 0))
                            .padding()
                        Button(action: {
                            signup()
                        }, label: {
                            HStack(content: {
                                Image(systemName: "hand.raised.fill")
                                Text("Signup")
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
                .navigationTitle("Create an account")
                .alert(errorMesssage ?? "", isPresented: $showingAlert) {
                    Button("OK") { }
                }
            }
            
        })
    }
    
    func signup() {
        if email == "" || password == "" || repassword == "" {
            self.errorMesssage = "Please fill user/password/repassword!"
            self.showingAlert = true
            return
        }
        
        if password != repassword {
            self.errorMesssage = "Re-password not match!"
            self.showingAlert = true
            return
        }
        
        authModel.signUp(email: email, password: password) { error in
            if error != nil {
                self.errorMesssage = error?.localizedDescription
                self.showingAlert = true
                return
            }
            
            if !Auth.auth().currentUser!.isEmailVerified {
                self.errorMesssage = "Your account has been created but not verified. Confirm registration by your email."
                self.showingAlert = true
                return
            }
            
            
            self.isPresented = false
            
            UIApplication.shared.endEditing()
        }
    }
}
