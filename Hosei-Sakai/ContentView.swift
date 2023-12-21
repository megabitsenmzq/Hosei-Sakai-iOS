//
//  ContentView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        if loginManager.loginState == true {
            if loginManager.isDemo {
                DemoMainView()
            } else {
                MainView()
            }
        } else if loginManager.loginState == false {
            LoginView()
                .environmentObject(LoginManager.shared)
        } else {
            LoadingAnimationView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
