//
//  SettingView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 21/07/2024.
//

import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var colorSettings: ColorSettings
    @AppStorage("showAbsentStudent") private var showAbsentStudent: Bool = true
    @State private var showConfirm = false
    @State private var price = 500000
    @EnvironmentObject var authModel : AuthenticationModel
    @EnvironmentObject var viewModel : ClassRoomViewModel
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    ColorPicker("Set Accent Color", selection: $colorSettings.textColor)
                    
                    Button("Apply Change") {
                        showConfirm = true
                    }
                    .tint(.red)
                    Button("Restore Default Color") {
                        colorSettings.textColor = Color.init(hex: 0xC0D06D)
                        showConfirm = true
                    }
                }
                
                Section(header: Text("Features")) {
                    Toggle("Absent Student", isOn: $showAbsentStudent)
                }
                
                Section(header: Text("Money 💰")) {
                    HStack(content: {
                        Text("Students")
                            .foregroundColor(colorSettings.textColor.opacity(0.6))
                        Spacer()
                        Text("\(viewModel.classrooms.map({$0.students.count}).reduce(0, +))")
                            .foregroundColor(colorSettings.textColor)
                        
                        
                    })
                    Stepper(value: $price, step: 100000) {
                        HStack(content: {
                            Text("\(price) đ")
                                .foregroundColor(colorSettings.textColor)
                            Text("/Student")
                                .foregroundColor(colorSettings.textColor.opacity(0.6))
                        })
                    }
                    HStack(content: {
                        Text("Profit")
                            .foregroundColor(colorSettings.textColor.opacity(0.6))
                        Spacer()
                        Text("\(price * viewModel.classrooms.map({$0.students.count}).reduce(0, +)) đ")
                            .foregroundColor(colorSettings.textColor)
                        
                    })
                }
                
                
                Section(header: Text("Privacy")) {
                    Link(destination: URL(string: "https://edit.codes")!, label: {
                        Text("Developer Website")
                    })
                    
                    Link(destination: URL(string: "https://www.facebook.com/QUYENNisME/")!, label: {
                        Text("App Support")
                    })
                    Link(destination: URL(string: "https://www.freeprivacypolicy.com/live/ec732318-a150-4e21-853f-bd465ba6974f")!, label: {
                        Text("Privacy Policy")
                    })
                }
                
                Section(header: Text("\(Auth.auth().currentUser?.email ?? "")")) {
                    Button(action: {
                        authModel.signout()
                    }) {
                        Text("Logout")
                    }
                    .tint(.red)
                    
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }.tint(colorSettings.textColor))
            .alert(isPresented: $showConfirm, content: { confirmChange })
            .onAppear(perform: {
            })
        }
    }
    
    var confirmChange: Alert {
        Alert(title: Text("Change Configuration?"), message: Text("This application needs to restart to update the configuration.\n\nDo you want to restart the application?"),
              primaryButton: .default (Text("Yes")) {
            restartApplication()
        },
              secondaryButton: .cancel(Text("No"))
        )
    }
    
    func restartApplication(){
        var localUserInfo: [AnyHashable : Any] = [:]
        localUserInfo["pushType"] = "restart"
        
        let content = UNMutableNotificationContent()
        content.title = "Configuration Update Complete"
        content.body = "Tap to reopen the application"
        content.sound = UNNotificationSound.default
        content.userInfo = localUserInfo
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        let identifier = "com.domain.restart"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request)
        exit(0)
    }
    
}

#Preview {
    SettingView(isPresented: .constant(true))
}

