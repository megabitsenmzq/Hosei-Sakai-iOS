//
//  AssignmentManager.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/10/18.
//

import Foundation
import SwiftSoup
import OSLog

struct AssignmentAttachment: Hashable {
    var title: String
    var url: URL
}

class AssignmentManager: NSObject, ObservableObject {
    static let shared = AssignmentManager()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AssignmentManager")
    
    @Published var state = SakaiRefreshState.ready
    @Published var assignments: [Assignments.AssignmentCollection]? {
        didSet  {
            saveAssignmentsToCache()
        }
    }
    
    @Published var lastRefreshTime = appGroupDefaults.date(forKey: UserDefaultKeys.assignmentLastRefreshTime) {
        didSet {
            appGroupDefaults.set(date: lastRefreshTime, forKey: UserDefaultKeys.assignmentLastRefreshTime)
        }
    }
    
    @Published var showOptimizedDate = !appGroupDefaults.bool(forKey: UserDefaultKeys.assignmentShowOptimizedDate) {
        didSet {
            appGroupDefaults.set(!showOptimizedDate, forKey: UserDefaultKeys.assignmentShowOptimizedDate)
        }
    }
    
    let assignmentCacheFileURL = appGroupDocuments.appendingPathComponent("assignments.json", isDirectory: false)
    let usernameCacheFileURL = appGroupDocuments.appendingPathComponent("username.json", isDirectory: false)
    
    var refreshTask: Task<Void, Never>?
    
    override init() {
        super.init()
        readCachedAssignments()
    }
    
    func refreshAssignments() {
        if LoginManager.shared.isDemo {
            assignments = DemoData.demoAssignments
            state = .ready
            return
        }
        
        state = .refreshing
        refreshTask?.cancel()
        refreshTask = Task {
            do {
                let assignments = try await getAssignments()
                
                let openAssignments = assignments.assignmentCollection.filter({ $0.status == "OPEN" })
                var sortedAssignments = openAssignments.sorted(by: {$0.dueTimeString < $1.dueTimeString})
                
                let userIDs = sortedAssignments.map( {$0.author} )
                let usernames = await loadUsernames(ids: userIDs)
    
                for index in sortedAssignments.indices {
                    sortedAssignments[index].authorName = usernames[sortedAssignments[index].author]
                }
                
                saveUsernamesToCache(usernames)
    
                for index in sortedAssignments.indices {
                    if let first = self.assignments?.first(where: { $0.id == sortedAssignments[index].id }) {
                        sortedAssignments[index].markAsFinished = first.markAsFinished
                    }
                }
    
                let newAssignments = sortedAssignments
                if Task.isCancelled { return }
                await MainActor.run {
                    self.assignments = newAssignments
                    lastRefreshTime = Date()
                    state = .ready
                }
            } catch {
                if Task.isCancelled { return }
                LoginManager.shared.refreshLoginState()
                logger.error("Assignments json error: \(error.localizedDescription)")
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
    
    func loadUsernames(ids: [String]) async -> [String:String] {
        return await withTaskGroup(of: UserInfo?.self) { group in
            var usernames = self.readUsernamesFromCache() ?? [String:String]()
            for id in ids {
                if usernames[id] != nil { continue }

                group.addTask {
                    return await LoginManager.shared.getUser(with: id)
                }
            }
            for await user in group {
                if let id = user?.id, let displayName = user?.displayName {
                    usernames[id] = displayName
                }
            }
            return usernames
        }
    }
    
    func getAssignments() async throws -> Assignments {
        let (data, _) = try await LoginManager.shared.createSession().data(from: HoppiiURLs.assignments.url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.assignmentTime)
        let assignmentList = try decoder.decode(Assignments.self, from: data)
        if assignmentList.assignmentCollection.isEmpty {
            throw NSError(domain: "", code: 999, userInfo: [ NSLocalizedDescriptionKey: "Assignments are empty"])
        }
        return assignmentList
    }
    
    func saveUsernamesToCache(_ usernames: [String:String]) {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(usernames)
            try jsonData.write(to: usernameCacheFileURL)
        } catch {
            logger.error("Username cache error: \(error.localizedDescription)")
        }
    }
    
    func readUsernamesFromCache() -> [String:String]? {
        guard let data = try? Data(contentsOf: usernameCacheFileURL) else { return nil }
        return try? JSONDecoder().decode([String:String].self, from: data)
    }
    
    func saveAssignmentsToCache() {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(assignments)
            try jsonData.write(to: assignmentCacheFileURL)
        } catch {
            logger.error("Assignments cache saving error: \(error.localizedDescription)")
        }
    }
    
    func readCachedAssignments() {
        guard FileManager.default.fileExists(atPath: assignmentCacheFileURL.path) else { return }
        do {
            let data = try Data(contentsOf: assignmentCacheFileURL)
            let decoder = JSONDecoder()
            assignments = try decoder.decode([Assignments.AssignmentCollection].self, from: data)
        } catch {
            logger.error("Assignments cache reading error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Tools
    func downloadAttachmentListForAssignment(id: String) async -> [AssignmentAttachment] {
        var result = [AssignmentAttachment]()
        do {
            let (data, _) = try await LoginManager.shared.createSession().data(from: HoppiiURLs.assignmentDetail.url(with: id))
            if let dataString = String(data: data, encoding: .utf8) {
                let assignmentPage = try SwiftSoup.parse(dataString)
                let attachmentListDiv = try assignmentPage.getElementsByClass("attachList")
                let attachmentList = try attachmentListDiv.select("li")
                for item in attachmentList {
                    if let link = try item.select("a").first() {
                        let title = try link.text()
                        let urlString = try link.attr("href")
                        let url = URL(string: urlString)!
                        result.append(AssignmentAttachment(title: title, url: url))
                    }
                }
            }
            return result
        } catch {
            logger.error("Page parsing error: \(error.localizedDescription)")
        }
        return result
    }
}
