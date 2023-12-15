//
//  TimeTableView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI
import SwiftSoup

struct TimeTableView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var url = URL(string: "about:blank")!
    @State var isError = false
    
    var webView: some View {
        AutoLoginWebView(url: $url, username: .constant(LoginManager.shared.username), password: .constant(LoginManager.shared.password), isLoginError: $isError)
    }
    
    var body: some View {
        Group {
            if colorScheme == .dark {
                webView
                    .colorInvert()
            } else {
                webView
            }
        }
        .task {
            if let newURL = await getTimetableURL() {
                url = newURL
            } else {
                isError = true
            }
        }
    }
    
    func getTimetableURL() async -> URL? {
        do {
            let (data, _) = try await LoginManager.shared.createSession().data(from: HoppiiURLs.home.url)
            if let dataString = String(data: data, encoding: .utf8) {
                let homePage = try SwiftSoup.parse(dataString)
                let timetableDiv = try homePage.getElementsByClass("Mrphs-toolBody--sakai-timetable")
                let iframe = try timetableDiv.select("iframe")
                return try URL(string: iframe.attr("src"))
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
