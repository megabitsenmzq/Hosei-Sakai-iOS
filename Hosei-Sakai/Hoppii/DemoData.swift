//
//  DemoData.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/12/21.
//

import Foundation

struct DemoData {
    static let demoUser = UserInfo(createdDate: 0, displayId: "11N4514", displayName: "学生太郎", eid: "", email: "student@hosei.ac.jp", firstName: "", id: "", lastModified: Date(), lastName: "", modifiedDate: Date(), reference: "", sortName: "", type: "", entityReference: "", entityURL: URL(string: "about:blank")!, entityId: "", entityTitle: "")
    
    static let demoAssignments = [
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "仕様書の提出"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "日報"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "作品タイトルの確認"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "相互評価シート"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "レポート1")
    ]
    
    static let demoSites = [
        Sites.SiteCollection(id: UUID().uuidString, title: "プロダクト理論", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "ゼミナール 3", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "映像制作", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "マイコン基礎", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "フランス語", joinable: true, entityId: "demo", entityTitle: "")
    ]
    
    static let demoContents = [
        Contents.ContentCollection(container: "", size: 0, title: "Empty", type: "Header", url: URL(string: "about:blank")!),
        Contents.ContentCollection(container: "", size: 0, title: "グループ分け.pdf", type: "PDF", url: URL(string: "about:blank")!),
        Contents.ContentCollection(container: "", size: 0, title: "提出スケジュール.pdf", type: "PDF", url: URL(string: "about:blank")!),
    ]
    
    static let demoAnnouncements = [
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "最終発表会と提出物に関して"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "物品購入について"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "最終成果物"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "1月15日の教室变更案内"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "パネルガイダンス")
    ]
    
    static let demoTimetable = [["", "", "", "", "", "", ""], ["", "", "プロダクト理論", "プロダクト理論", "", "", ""], ["", "", "", "ゼミナール 3", "ゼミナール 3", "", ""], ["", "", "プロダクト理論", "プロダクト理論", "映像制作", "", ""], ["", "フランス語", "マイコン基礎", "マイコン基礎", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""]]
}
