//
//  SiteManager.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/21.
//

import Foundation
import OSLog

class SiteManager: NSObject, ObservableObject {
    static let shared = SiteManager()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SiteManager")
        
    @Published var state = SakaiRefreshState.ready
    @Published var sites: [Sites.SiteCollection]? {
        didSet  {
            saveSitesToCache()
        }
    }
    @Published var lastRefreshTime = appGroupDefaults.date(forKey: UserDefaultKeys.sitesLastRefreshTime) {
        didSet {
            appGroupDefaults.set(date: lastRefreshTime, forKey: UserDefaultKeys.sitesLastRefreshTime)
        }
    }
    
    let sitesCacheFileURL = appGroupDocuments.appendingPathComponent("sites.json", isDirectory: false)
    
    var refreshTask: Task<Void, Never>?
    
    override init() {
        super.init()
        readCachedSites()
    }
    
    func refreshSites() {
        if LoginManager.shared.isDemo {
            sites = DemoData.demoSites
            state = .ready
            return
        }
        
        state = .refreshing
        refreshTask?.cancel()
        refreshTask = Task {
            do {
                let sites = try await getSites()
                if Task.isCancelled { return }
                await MainActor.run {
                    self.sites = sites.siteCollection
                    lastRefreshTime = Date()
                    state = .ready
                }
            } catch {
                if Task.isCancelled { return }
                LoginManager.shared.refreshLoginState()
                logger.error("Sites json error: \(error.localizedDescription)")
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
    
    func getSites() async throws -> Sites {
        let (data, _) = try await LoginManager.shared.createSession().data(from: HoppiiURLs.sites.url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.siteTime)
        let siteList = try decoder.decode(Sites.self, from: data)
        if siteList.siteCollection.isEmpty {
            throw NSError(domain: "", code: 999, userInfo: [ NSLocalizedDescriptionKey: "Sites are empty"])
        }
        return siteList
    }
    
    func saveSitesToCache() {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(sites)
            try jsonData.write(to: sitesCacheFileURL)
        } catch {
            logger.error("Sites cache saving error: \(error.localizedDescription)")
        }
    }
    
    func readCachedSites() {
        guard FileManager.default.fileExists(atPath: sitesCacheFileURL.path) else { return }
        do {
            let data = try Data(contentsOf: sitesCacheFileURL)
            let decoder = JSONDecoder()
            sites = try decoder.decode([Sites.SiteCollection].self, from: data)
        } catch {
            logger.error("Sites cache reading error: \(error.localizedDescription)")
        }
        
    }
}
