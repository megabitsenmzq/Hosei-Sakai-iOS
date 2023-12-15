//
//  LoginInterfaceView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI

struct LoginInterfaceView: View {
    
    @Binding var username: String
    @Binding var password: String
    @Binding var error: Bool

    let loginAction: () -> Void
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("ようこそ")
                .font(.system(.title, design: .rounded))
                .bold()
                .padding(.bottom, 3)
            Text("Hoppii アカウントでログインしてください。")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
    
    var inputs: some View {
        VStack(alignment: .leading) {
            Text("学籍番号")
                .font(.callout)
            TextField("XXNXXXX", text: $username)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .padding(.bottom, 8)
                .keyboardType(.alphabet)
                .autocapitalization(.none)
            Text("パスワード")
                .font(.callout)
            SecureField("", text: $password)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .padding(.bottom, 3)
            if error {
                Text("ログイン情報が違います。")
                    .font(.footnote)
                    .foregroundColor(.red)
            } else {
                Text("ログイン情報は安全に保存されます。")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            header
                .padding(.bottom, 32)
            inputs
                .padding(.bottom, 32)
            Button("Login", action: loginAction)
                .buttonStyle(RoundedButtonStyle(buttonColor: Color(uiColor: .tintColor), extend: true))
                .disabled(username.trimmingCharacters(in: .whitespaces) == "" || password.trimmingCharacters(in: .whitespaces) == "")
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .padding(30)
        .background() {
            Image("RabbitHead")
                .opacity(0.05)
        }
    }
}

//#Preview {
//    LoginInterfaceView(username: .constant("21NXXXX"), password: .constant("12345678"), error: .constant(false), loginAction: {})
//}
