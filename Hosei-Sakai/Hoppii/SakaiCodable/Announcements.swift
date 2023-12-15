//
//  Announcements.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/21.
//

import Foundation

struct Announcements: Codable {
    let entityPrefix: String
    struct AnnouncementCollection: Codable {
//        let announcementId: String
        struct Attachments: Codable {
            let id: String
            let name: String
            let ref: String
            let type: String
            let url: URL
        }
        let attachments: [Attachments]
        let body: String
//        let channel: String
//        let createdByDisplayName: String
//        let createdOn: Date
        let id: String
//        let siteId: String
//        let siteTitle: String
        let title: String
//        let entityReference: String
//        let entityURL: URL
//        let entityId: String
//        let entityTitle: String
    }
    let announcementCollection: [AnnouncementCollection]
    private enum CodingKeys: String, CodingKey {
        case entityPrefix
        case announcementCollection = "announcement_collection"
    }
}
