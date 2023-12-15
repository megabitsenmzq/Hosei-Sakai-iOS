//
//  HoppiiURLs.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/23.
//

import Foundation

enum HoppiiURLs: String {
    case root = "https://hoppii.hosei.ac.jp/"
    case requestLogin = "https://hoppii.hosei.ac.jp/sakai-login-tool/container" // Will jump to the SSO page.
    case hoseiSSO = "https://idp.hosei.ac.jp/idp/profile/SAML2/Redirect/SSO"
    case home = "https://hoppii.hosei.ac.jp/portal"
    
    case sakaiAPIDoc = "https://hoppii.hosei.ac.jp/direct/describe"
    case currentUser = "https://hoppii.hosei.ac.jp/direct/user/current.json" // Able to be used for login state check.
    case assignments = "https://hoppii.hosei.ac.jp/direct/assignment/my.json"
    case sites = "https://hoppii.hosei.ac.jp/direct/site.json?_limit=200"
    case userInfo = "https://hoppii.hosei.ac.jp/direct/user/%@.json"
    case announcementsFromSite = "https://hoppii.hosei.ac.jp/direct/announcement/site/%@.json"
    case contentsFromSite = "https://hoppii.hosei.ac.jp/direct/content/site/%@.json"
    
    // HTML pages
    case assignmentDetail = "https://hoppii.hosei.ac.jp/direct/assignment/%@"
    case timeTablePage = "https://hoppii.hosei.ac.jp/portal/tool-reset/e0adde9d-020c-47df-97d7-d50fb86fb185/"
    
    var url: URL {
        URL(string: self.rawValue)!
    }
    
    func url(with id: String) -> URL {
        let urlString = String(format: self.rawValue, id)
        return URL(string: urlString)!
    }
}
