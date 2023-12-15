//
//  Contents.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/26.
//

import Foundation

struct Contents: Codable {
    let entityPrefix: String
    struct ContentCollection: Codable, Hashable {
//        let author: String
//        let authorId: String
        let container: String
//        let description: String?
//        let fromDate: String?
//        let modifiedDate: String
//        let numChildren: Int
        let size: Int
        let title: String
        let type: String
        let url: URL
//        let usage: String?
//        let hidden: Bool
//        let visible: Bool
//        let entityReference: String
//        let entityURL: URL
//        let entityTitle: String
    }
    let contentCollection: [ContentCollection]
    private enum CodingKeys: String, CodingKey {
        case entityPrefix
        case contentCollection = "content_collection"
    }
}
