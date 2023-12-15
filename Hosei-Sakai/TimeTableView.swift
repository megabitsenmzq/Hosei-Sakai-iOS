//
//  TimeTableView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI
import SwiftSoup

struct TimeTableView: View {
    @State var url = URL(string: "about:blank")!
    @State var isError = false
    
    var body: some View {
        VStack {
            AutoLoginWebView(url: $url, username: .constant(LoginManager.shared.username), password: .constant(LoginManager.shared.password), isLoginError: $isError)
                .task {
                    if let newURL = await downloadTimetable() {
                        url = URL(string: newURL)!
                    } else {
                        isError = true
                    }
                }
        }
    }
    
    func downloadTimetable() async -> String? {
        do {
            let (data, _) = try await LoginManager.shared.createSession().data(from: HoppiiURLs.home.url)
            if let dataString = String(data: data, encoding: .utf8) {
                let homePage = try SwiftSoup.parse(dataString)
                let timetableDiv = try homePage.getElementsByClass("Mrphs-toolBody--sakai-timetable")
                let iframe = try timetableDiv.select("iframe")
                return try iframe.attr("src")
            }
        } catch {
            print(error)
        }
        return nil
    }
}

struct TimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableView()
    }
}
