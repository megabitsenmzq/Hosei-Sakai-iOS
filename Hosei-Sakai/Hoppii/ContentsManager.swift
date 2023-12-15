//
//  ContentsManager.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/26.
//

import Foundation
import OSLog

class ContentsManager: NSObject, ObservableObject {
    static let shared = ContentsManager()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ContentsManager")
    
    func getContents(siteID: String) async -> Contents? {
        do {
            let (data, _) = try await LoginManager.shared.createSession().data(from: HoppiiURLs.contentsFromSite.url(with: siteID))
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .formatted(DateFormatter.siteTime)
            let contentsList = try decoder.decode(Contents.self, from: data)
            return contentsList
        } catch {
            logger.error("Contents json error: \(error.localizedDescription)")
        }
        return nil
    }
    
}
