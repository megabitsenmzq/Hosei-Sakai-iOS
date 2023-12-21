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
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "課題1"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "課題2"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "課題3"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "課題4"),
        Assignments.AssignmentCollection(author: "", authorName: "教員太郎", closeTimeString: Date(), context: "", dropDeadTimeString: Date(), dueTimeString: Date().addingTimeInterval(60*60*24), id: UUID().uuidString, instructions: "授業中の指示に従って、PDFを作って提出する。", openTimeString: Date(), status: nil, submissionType: "", title: "課題5")
    ]
    
    static let demoSites = [
        Sites.SiteCollection(id: UUID().uuidString, title: "授業1", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "授業2", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "授業3", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "授業4", joinable: true, entityId: "demo", entityTitle: ""),
        Sites.SiteCollection(id: UUID().uuidString, title: "授業5", joinable: true, entityId: "demo", entityTitle: "")
    ]
    
    static let demoAnnouncements = [
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "お知らせ1"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "お知らせ2"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "お知らせ3"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "お知らせ4"),
        Announcements.AnnouncementCollection(attachments: [], body: "皆さん！よいお年を！", id: UUID().uuidString, title: "お知らせ5")
    ]
    
    static let demoTimetable = [["", "", "", "", "", "", ""], ["", "", "授業1", "授業1", "", "", ""], ["", "", "", "授業2", "授業2", "", ""], ["", "", "授業1", "授業1", "授業3", "", ""], ["", "授業4", "授業5", "授業5", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""]]
}
