//
//  AnnouncementManager.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/21.
//

import Foundation
import OSLog

class AnnouncementManager: NSObject, ObservableObject {
    static let shared = AnnouncementManager()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AnnouncementManager")
    
    func getAnnouncements(siteID: String) async -> Announcements? {
        do {
            let (data, _) = try await LoginManager.shared.createSession().data(from: HoppiiURLs.announcementsFromSite.url(with: siteID))
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .formatted(DateFormatter.siteTime)
            let announcementList = try decoder.decode(Announcements.self, from: data)
            return announcementList
        } catch {
            logger.error("Announcement json error: \(error.localizedDescription)")
        }
        return nil
    }
    
}
