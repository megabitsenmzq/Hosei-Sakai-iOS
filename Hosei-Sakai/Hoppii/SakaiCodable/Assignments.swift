//
//  Assignments.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import Foundation

struct Assignments: Codable {
    let entityPrefix: String
    struct AssignmentCollection: Codable, Hashable {
        
        let author: String // Teacher Name
        var authorName: String? // Additional
        
        let closeTimeString: Date
        
        let context: String
        
        let dropDeadTimeString: Date
        let dueTimeString: Date
        
        let id: String // !!!
        let instructions: String // !!!
        
        let openTimeString: Date
        
        let status: String? // !!!
        
        let submissionType: String
        
        let title: String // !!!
        
        var markAsFinished: Bool? // Additional
    }
    let assignmentCollection: [AssignmentCollection]
    private enum CodingKeys: String, CodingKey {
        case entityPrefix
        case assignmentCollection = "assignment_collection"
    }
}
