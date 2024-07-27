//
//  LoginView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import TTProgressHUD
import FirebaseAuth

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var authModel: AuthenticationModel
    @State var signInHandler: AuthenticationModel?
    @State var hudConfig = TTProgressHUDConfig(type: .loading, title: "Loading")
    @State private var showPasswordReset = false
    @State private var showSignup = false
    @EnvironmentObject var colorSettings: ColorSettings
    @State private var errorMesssage: String?
    @State private var showingAlert = false
    var body: some View {
        ZStack(alignment: .top){
            Color.mainBg.ignoresSafeArea()
            VStack(alignment: .leading){
                
                Text("Welcome to your class!")
                    .font(.custom("OpenSans-Regular", size: 30))
                    .foregroundColor(colorSettings.textColor)
                Image("hand")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 100, height: 100)
                    .foregroundColor(colorSettings.textColor)
                Spacer()
                VStack(alignment: .center) {
                    TextFieldView(string: self.$email,
                        passwordMode: false,
                        placeholder: "Enter email",
                        iconName: "envelope.fill")
                        .padding(.vertical, 8)
                    TextFieldView(string: self.$password,
                        passwordMode: true,
                        placeholder: "Enter password",
                        iconName: "lock.open.fill")
                    HStack {
                        Spacer()
                        
                        Button(action: { self.showPasswordReset = true }) {
                            Text("Forgot password?")
                                .foregroundColor(colorSettings.textColor)
                                .font(.custom("OpenSans-Bold", size: 16, relativeTo: .body))
                        }
                        .sheet(isPresented: $showPasswordReset) {
                            ForgotView(isPresented: $showPasswordReset, email: $email)
                        }
                    }
                    .padding(.bottom, 30)
                    HStack{
                        Spacer()
                        ProgressView()
                            .tint(colorSettings.textColor.opacity(authModel.isAuthenticating ? 1 : 0))
                            .padding()
                        Button(action: {login()}, label: {
                            HStack(content: {
                                Image(systemName: "hand.raised.fill")
                                Text("Login")
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
                    HStack {
                        Spacer()
                        
                        Button(action: { self.showSignup = true }) {
                            Text("Don't have account?")
                                .foregroundColor(colorSettings.textColor)
                                .font(.custom("OpenSans-Bold", size: 16, relativeTo: .body))
                        }
                        .sheet(isPresented: $showSignup) {
                            SignUpView(isPresented: $showSignup, email: $email, password: $password)
                        }
                    }
                    .padding(.bottom, 30)
                    LoginFooterView(signinApple: {
                        authModel.login(.apple)
                    }, signinGoogle: {
                        
                    })
                    .padding(.bottom, 20)
                    Text("When you use this application, you agree to our terms and regulations.")
                        .font(.custom("OpenSans-Regular", size: 14, relativeTo: .body))
                        .foregroundColor(colorSettings.textColor)
                        .multilineTextAlignment(.center)
                }
                
                
            }
            .padding()
        }
        
    }
    
    
    fileprivate func login() {
        if email == "" || password == "" {
            self.errorMesssage = "Please enter user/password!"
            self.showingAlert = true
            return
        }
        authModel.signIn(email: email, password: password) { error in
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
            
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    LoginView()
        .environment(\.colorScheme, .dark)
}
