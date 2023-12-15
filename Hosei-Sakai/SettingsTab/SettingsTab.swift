//
//  DebugTab.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/26.
//

import SwiftUI
import WebKit

struct SettingsTab: View {
    @EnvironmentObject var loginManager: LoginManager
    @ObservedObject var assignmentManager = AssignmentManager.shared

    @State var showMailCopyAlert = false
    var body: some View {
        NavigationView {
            List {
                Section("ユーザー情報") {
                    HStack {
                        Text("学籍番号")
                        Spacer()
                        Text(loginManager.currentUser?.displayId ?? "")
                    }
                    HStack {
                        Text("名前")
                        Spacer()
                        Text(loginManager.currentUser?.displayName ?? "")
                    }
                    HStack {
                        Text("メール")
                        Spacer()
                        Button(loginManager.currentUser?.email ?? "") {
                            showMailCopyAlert = true
                        }
                    }
                    .alert("メールをコピーしました。", isPresented: $showMailCopyAlert, actions: {
                        Button("OK") {
                            UIPasteboard.general.string = loginManager.currentUser?.email
                        }
                    })
                    
                    Button("ログアウト") {
                        LoginManager.shared.logout()
                        LoginManager.shared.refreshLoginState()
                    }
                    .tint(.red)
                }
                
                Section("表示") {
                    Toggle(isOn: $assignmentManager.showOptimizedDate) {
                        Text("安全な締切を表示")
                    }
                }
                
                Section("ツール") {
                    TamachiClassroomDownloadView()
                }
                
                Section("アプリについて") {
                    Button("オーペンソース") {
                        UIApplication.shared.open(URL(string: "https://github.com/megabitsenmzq/Hosei-Sakai-iOS")!)
                    }
                }
                
                #if DEBUG
                Section("Debug") {
                    Button("クーキーをリフレッシュ") {
                        LoginManager.shared.clearCookies()
                        LoginManager.shared.refreshLoginState()
                    }
                }
                #endif
            }
        }
    }
}

struct DebugTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab()
    }
}
