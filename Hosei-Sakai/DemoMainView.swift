//
//  DemoMainView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/12/21.
//

import SwiftUI

struct DemoMainView: View {
    @State var currentTab = 0 // Keep this to resolve a bug in SwiftUI that causes the tab view back to Tab1 after the view update.
    
    var body: some View {
        TabView(selection: $currentTab) {
            if #available(iOS 16.0, *) {
                AssignmentsTab()
                    .environmentObject(AssignmentManager.shared)
                    .tabItem {
                        Image(systemName: "pencil.line")
                        Text("課題")
                    }
                    .tag(0)
            } else {
                AssignmentsTab()
                    .environmentObject(AssignmentManager.shared)
                    .tabItem {
                        Image(systemName: "pencil")
                        Text("課題")
                    }
                    .tag(0)
            }
            SitesTab()
                .environmentObject(SiteManager.shared)
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                    Text("授業")
                }
                .tag(1)
            TimetableView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("時間割")
                }
                .tag(2)
            SettingsTab()
                .tabItem {
                    Image(systemName: "gear")
                    Text("設定")
                }
                .tag(3)
        }
    }
}

#Preview {
    DemoMainView()
}
