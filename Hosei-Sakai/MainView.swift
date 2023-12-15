//
//  MainView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            if #available(iOS 16.0, *) {
                AssignmentsTab()
                    .environmentObject(AssignmentManager.shared)
                    .tabItem {
                        Image(systemName: "pencil.line")
                        Text("課題")
                    }
            } else {
                AssignmentsTab()
                    .environmentObject(AssignmentManager.shared)
                    .tabItem {
                        Image(systemName: "pencil")
                        Text("課題")
                    }
            }
            SitesTab()
                .environmentObject(SiteManager.shared)
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                    Text("授業")
                }
//            TimeTableView()
//                .tabItem {
//                    Image(systemName: "calendar")
//                    Text("時間割")
//                }
            SettingsTab()
                .tabItem {
                    Image(systemName: "gear")
                    Text("設定")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
