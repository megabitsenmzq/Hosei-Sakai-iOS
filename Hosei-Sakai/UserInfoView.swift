//
//  UserInfoView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI

struct UserInfoView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("21NXXXX")
                    .font(.callout)
                    .foregroundColor(.gray)
                Text("啦啦啦")
                    .font(.largeTitle)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("HoppiiOrange"))
                    .padding(.vertical, 8)
                Spacer()
                Button("Logout") {
                    LoginManager.shared.logout()
                    LoginManager.shared.refreshLoginState()
                }
                .buttonStyle(RoundedButtonStyle(buttonColor: Color("HoppiiOrange"), extend: true))
            }
            .padding()
            Spacer()
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
