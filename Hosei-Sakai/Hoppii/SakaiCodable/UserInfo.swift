//
//  UserInfo.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/23.
//

import Foundation

struct UserInfo: Codable {
    let createdDate: Int
    let displayId: String
    let displayName: String
    let eid: String
    let email: String
    let firstName: String
    let id: String
    let lastModified: Date
    let lastName: String
    let modifiedDate: Date
    let reference: String
    let sortName: String
    let type: String
    let entityReference: String
    let entityURL: URL
    let entityId: String
    let entityTitle: String
}
