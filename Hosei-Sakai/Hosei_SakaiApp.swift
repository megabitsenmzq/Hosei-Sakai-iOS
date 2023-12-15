//
//  Hosei_SakaiApp.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/22.
//

import SwiftUI

@main
struct Hosei_SakaiApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LoginManager.shared)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                LoginManager.shared.refreshLoginState()
            }
        }
    }
}
