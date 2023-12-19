//
//  TimeTableView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI
import SwiftSoup

struct TimetableView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var url = URL(string: "about:blank")!
    @State var isError = false
    @State var noSunday = false
    @State var noSaturday = false
    @State var table: [[String]]?
    
    var body: some View {
        Group {
            if let table = table {
                TimetableContentView(noSunday: noSunday, noSaturday: noSaturday, table: table)
            } else {
                LoadingAnimationView()
            }
        }
        .task {
            if let newURL = await getTimetableURL() {
                url = newURL
                var newTable = await getTimetableList()
                let sunItems = newTable[0].reduce("", {$0 + $1})
                if sunItems == "" {
                    newTable.removeFirst()
                    noSunday = true
                }
                let satItems = newTable.last!.reduce("", {$0 + $1})
                if satItems == "" {
                    newTable.removeLast()
                    noSaturday = true
                }
                table = newTable
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
    
    func getTimetableList() async -> [[String]]{
        do {
            let (data, _) = try await LoginManager.shared.createSession().data(from: url)
            if let dataString = String(data: data, encoding: .utf8) {
                let homePage = try SwiftSoup.parse(dataString)
                var rowTexts = try homePage.select("tr").map { tr in
                    var columns = try tr.select("td").map { try $0.text() }
                    if !columns.isEmpty {
                        columns.removeFirst()
                    }
                    return columns
                }
                rowTexts.removeFirst()
                
                return rowTexts.transpose()
            }
        } catch {
            print(error)
        }
        return [[]]
    }
}

struct TimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView()
    }
}
