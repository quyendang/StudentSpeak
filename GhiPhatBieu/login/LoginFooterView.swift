//
//  LoginFooterView.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 08/07/2024.
//

import SwiftUI

struct LoginFooterView: View {
    @EnvironmentObject var colorSettings: ColorSettings
    var signinApple: (()->()) = {}
    var signinGoogle: (()->()) = {}
    
    fileprivate func createButton(title: String, imageName: String, action:  @escaping (()->())) -> some View {
        return Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(colorSettings.textColor)
//                    .stroke(colorSettings.textColor, lineWidth: 2)
                HStack {
                    Image(imageName)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.mainBg)
                        .scaledToFit()
                        .frame(width: 22, height: 22, alignment: .center)

                    Text(title)
                        .font(.custom("OpenSans-Medium", size: 18, relativeTo: .body))
                        .foregroundColor(.mainBg)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(colorSettings.textColor)
                    .frame(height: 2)
                Text("More")
                    .font(.custom("OpenSans-Medium", size: 16, relativeTo: .body))
                    .foregroundColor(colorSettings.textColor)
                Rectangle()
                    .fill(colorSettings.textColor)
                    .frame(height: 2)
            }
                .padding(.vertical, 5)
            HStack {
//                createButton(title: "Google", imageName: "google", action: signinGoogle)
//                    .frame(height: 45, alignment: .center)
//                    .buttonStyle(PlainButtonStyle())
                createButton(title: "Apple", imageName: "apple", action: signinApple)
                    
                    .frame(height: 45, alignment: .center)
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct LoginFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFooterView()
            .environment(\.colorScheme, .dark)
    }
}
