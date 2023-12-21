//
//  TimetableManager.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/12/19.
//

import Foundation
import SwiftSoup
import OSLog

class TimetableManager {
    static let shared = TimetableManager()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "TimetableManager")
    
    func getTimetable() async -> [[String]]? {
        let session = await LoginManager.shared.createSession()
        guard let timetableURL = await getTimetableURL(session) else { return nil }
        return await getTimetableList(session, url: timetableURL)
    }
    
    private func getTimetableURL(_ session: URLSession) async -> URL? {
        do {
            let (data, _) = try await session.data(from: HoppiiURLs.home.url)
            if let dataString = String(data: data, encoding: .utf8) {
                let homePage = try SwiftSoup.parse(dataString)
                let timetableDiv = try homePage.getElementsByClass("Mrphs-toolBody--sakai-timetable")
                let iframe = try timetableDiv.select("iframe")
                return try URL(string: iframe.attr("src"))
            }
        } catch {
            logger.error("Can't parse homepage: \(error.localizedDescription))")
        }
        return nil
    }
    
    private func getTimetableList(_ session: URLSession, url: URL) async -> [[String]]? {
        do {
            let (data, _) = try await session.data(from: url)
            if let dataString = String(data: data, encoding: .utf8) {
                let homePage = try SwiftSoup.parse(dataString)
                var rowTexts = try homePage.select("tr").map { tr in
                    var columns = try tr.select("td").map { try $0.select("a").attr("title") }
                    if !columns.isEmpty {
                        columns.removeFirst()
                    }
                    return columns
                }
                rowTexts.removeFirst()
                
                return rowTexts.transpose()
            }
        } catch {
            logger.error("Can't parse timetable page: \(error.localizedDescription))")
        }
        return nil
    }
}
