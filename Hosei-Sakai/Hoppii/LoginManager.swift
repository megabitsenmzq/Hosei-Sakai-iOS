//
//  LoginManager.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import Foundation
import WebKit
import KeychainSwift
import OSLog

class LoginManager: NSObject, ObservableObject {
    static let shared = LoginManager()
    static let keychain = KeychainSwift()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LoginManager")
    
    @Published var loginState: Bool?
    @Published var isDemo = false
    @Published var currentUser: UserInfo?
    
    @Published var username = LoginManager.keychain.get("login.username") {
        didSet {
            if let username = username {
                LoginManager.keychain.set(username, forKey: "login.username")
            } else {
                LoginManager.keychain.delete("login.username")
            }
        }
    }
    @Published var password = LoginManager.keychain.get("login.password") {
        didSet {
            if let password = password {
                LoginManager.keychain.set(password, forKey: "login.password")
            } else {
                LoginManager.keychain.delete("login.password")
            }
        }
    }
    
    var refreshTask: Task<Void, Never>?
    var savedCookies: [HTTPCookie]? {
        return HTTPCookieStorage.shared.cookies(for: HoppiiURLs.root.url)
    }
    
    override init() {
        super.init()
        refreshLoginState()
    }
    
    func createSession() async -> URLSession {
        if savedCookies == nil {
            await preserveCookies()
        }
        
        if let cookies = savedCookies {
            logger.info("Have saved cookies.")
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            let sessionConfig = URLSessionConfiguration.ephemeral
            sessionConfig.httpAdditionalHeaders = cookieHeader
            return URLSession(configuration: sessionConfig)
        }
        
        return URLSession(configuration: .ephemeral)
    }
    
    func refreshLoginState() {
        if isDemo {
            print("isDemo")
            currentUser = DemoData.demoUser
            DispatchQueue.main.async {
                self.loginState = nil
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.loginState = true
            }
            return
        }
        logger.info("Start refresh login state.")
        refreshTask?.cancel()
        refreshTask = Task {
            if loginState == false {
                await MainActor.run {
                    loginState = nil
                }
            }
            
            if Task.isCancelled { return }
            
            if let currentUser = await getCurrentUser() {
                if Task.isCancelled { return }
                await MainActor.run {
                    logger.info("Login succeed.")
                    self.currentUser = currentUser
                    loginState = true
                }
            } else {
                if Task.isCancelled { return }
                await MainActor.run {
                    logger.info("Login failed.")
                    clearCookies()
                    self.currentUser = nil
                    loginState = false
                }
            }
        }
    }
    
    func logout() {
        username = nil
        password = nil
        isDemo = false
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {})
        }
    }
    
    func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {})
        }
    }
    
    @MainActor func preserveCookies() async {
        let newCookies = await WKWebsiteDataStore.default().httpCookieStore.allCookies()
        // Remove session only flag from cookies.
        let modifiedCookies = newCookies.compactMap({ cookie in
            let properties = cookie.properties ?? [:]
            return HTTPCookie(properties: [
                .domain: properties[.domain] as Any,
                .path: properties[.path] as Any,
                .name: properties[.name] as Any,
                .value: properties[.value] as Any,
                .secure: properties[.secure] as Any,
                .expires: Date.distantFuture
            ])
        })
        HTTPCookieStorage.shared.setCookies(modifiedCookies, for: HoppiiURLs.root.url, mainDocumentURL: nil)
    }
    
    func getCurrentUser() async -> UserInfo? {
        do {
            let (data, _) = try await createSession().data(from: HoppiiURLs.currentUser.url)
            return try JSONDecoder().decode(UserInfo.self, from: data)
        } catch {
            logger.error("Current user json error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getUser(with id: String) async -> UserInfo? {
        do {
            let (data, _) = try await createSession().data(from: HoppiiURLs.userInfo.url(with: id))
            return try JSONDecoder().decode(UserInfo.self, from: data)
        } catch {
            logger.error("User json error: \(error.localizedDescription)")
        }
        return nil
    }
}
