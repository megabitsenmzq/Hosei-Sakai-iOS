//
//  TimeoutView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI

struct NetworkErrorView: View {
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.icloud.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(.gray)
            Text("Hoppii に接続できません")
                .padding()
            Spacer()
            Button("再試行", action: retryAction)
                .buttonStyle(RoundedButtonStyle(buttonColor: Color("HoppiiOrange"), extend: true))
        }
        .padding(30)
    }
}

struct TimeoutView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkErrorView(retryAction: {})
    }
}
