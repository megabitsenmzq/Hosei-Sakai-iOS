//
//  Sites.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/21.
//

import Foundation

struct Sites: Codable {
    let entityPrefix: String
    struct SiteCollection: Codable {
//        let createdDate: Date
//        struct CreatedTime: Codable {
//            let display: Date
//            let time: Date
//        }
//        let createdTime: CreatedTime
//        let description: String
//        let htmlDescription: String
//        let htmlShortDescription: String
        let id: String
//        let joinerRole: String?
//        let lastModified: Date
//        let maintainRole: String
//        let modifiedDate: Date
//        struct ModifiedTime: Codable {
//            let display: Date
//            let time: Date
//        }
//        let modifiedTime: ModifiedTime
//        let owner: String
//        struct Props: Codable {
//            let sectionsExternallyMaintained: String
//            let originalSiteId: String
//            let year: String
//            let sectionsStudentSwitchingAllowed: String
//            let sectionsStudentRegistrationAllowed: String
//            private enum CodingKeys: String, CodingKey {
//                case sectionsExternallyMaintained = "sections_externally_maintained"
//                case originalSiteId = "original-site-id"
//                case year
//                case sectionsStudentSwitchingAllowed = "sections_student_switching_allowed"
//                case sectionsStudentRegistrationAllowed = "sections_student_registration_allowed"
//            }
//        }
//        let props: Props
//        let reference: String
//        struct SiteOwner: Codable {
//            let userDisplayName: String
//            let userEntityURL: String
//            let userId: String
//        }
//        let siteOwner: SiteOwner
//        struct SitePages: Codable {
//            let id: String
//            let layout: Int
//            let layoutTitle: String
//            let position: Int
//            struct Props: Codable {
//                let isHomePage: String?
//                let sitePageCustomTitle: String
//                let sitePageHomeToolsCustomTitle: String?
//                private enum CodingKeys: String, CodingKey {
//                    case isHomePage = "is_home_page"
//                    case sitePageCustomTitle = "sitePage.customTitle"
//                    case sitePageHomeToolsCustomTitle = "sitePage.homeToolsCustomTitle"
//                }
//            }
//            let props: Props?
//            let reference: String
//            let siteId: String
//            let skin: String
//            let title: String
//            let titleCustom: Bool
//            let url: URL
//            let activeEdit: Bool
//            let homePage: Bool
//            let popUp: Bool
//        }
//        let sitePages: [SitePages]
        let title: String
//        let type: String
//        let userRoles: [String]
//        let activeEdit: Bool
//        let customPageOrdered: Bool
//        let empty: Bool
        let joinable: Bool
//        let pubView: Bool
//        let published: Bool
//        let softlyDeleted: Bool
//        let entityReference: String
//        let entityURL: URL
        let entityId: String
        let entityTitle: String
    }
    let siteCollection: [SiteCollection]
    private enum CodingKeys: String, CodingKey {
        case entityPrefix
        case siteCollection = "site_collection"
    }
}
