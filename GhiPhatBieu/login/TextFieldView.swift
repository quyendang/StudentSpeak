//
//  TextFieldView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var string: String
    @EnvironmentObject var colorSettings: ColorSettings
    var passwordMode = false
    var placeholder: String
    var iconName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(colorSettings.textColor)
                    .padding(.vertical, 20)
                    .padding(.trailing, 5)
                    .padding(.leading, 20)
                
                if passwordMode {
                    SecureField("", text: $string, prompt: Text(placeholder).foregroundColor(colorSettings.textColor))
                        .foregroundColor(.orange)
                        .accentColor(colorSettings.textColor)
                        .font(.custom("OpenSans-Medium", size: 18, relativeTo: .body))
                }
                else {
                    TextField("", text: $string, prompt: Text(placeholder).foregroundColor(colorSettings.textColor))
                        .foregroundColor(.orange)
                        .font(.custom("OpenSans-Medium", size: 18, relativeTo: .body))
                        
                }
            }
        }
            
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(colorSettings.textColor.opacity(0.3))
            )
    }
}

struct TextFieldView_Previews: PreviewProvider {
    @State static var myCoolBool = ""
    static var previews: some View {
        TextFieldView(string: $myCoolBool, placeholder: "Please enter your email", iconName: "envelope.fill")
    }
}
