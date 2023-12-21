//
//  LoginView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/23.
//

import SwiftUI
import WebKit
import OSLog

struct LoginView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var loginManager: LoginManager
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LoginView")
    
    @State var username = ""
    @State var password = ""
    
    @State var loadingFirstPage = true
    @State var showLoading = true
    @State var loginError = false
    @State var loadError = false
    @State var timeoutTimer: Timer?
    
    // WebView
    @State var loginUrl = HoppiiURLs.requestLogin.url
    // Username and Password for WebView to use.
    @State var webUsername: String?
    @State var webPassword: String?
    
    func setTimeoutTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            loadError = true
        })
        showLoading = true
    }
    
    func cancelTimeoutTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
    func loginSuccess() {
        loginManager.username = self.username
        loginManager.password = self.password
        webUsername = nil
        webPassword = nil
        loginUrl = URL(string: "about:blank")!
        loginManager.refreshLoginState()
    }
    
    var loginWebView: some View {
        Group {
            AutoLoginWebView(url: $loginUrl, username: $webUsername, password: $webPassword, isLoginError: $loginError, committed: { url in
                logger.debug("Page committed: \(url.absoluteString)")
                if url.absoluteString.hasPrefix(HoppiiURLs.home.rawValue) {
                    loginSuccess()
                }
            }, finished: { url in
                logger.debug("Page finished: \(url.absoluteString)")
                if url.absoluteString.hasPrefix(HoppiiURLs.hoseiSSO.rawValue) {
                    cancelTimeoutTimer()
                }
                if loadingFirstPage {
                    if username == "" || password == "" {
                        loadingFirstPage = false
                        showLoading = false
                    } else {
                        // Try to use the exist credential.
                        if username == "11N4514", password == "password" {
                            loginManager.isDemo = true
                            loginSuccess()
                            return
                        }
                        webUsername = username
                        webPassword = password
                        setTimeoutTimer()
                    }
                }
            }, failed: { error in
                if (error as NSError).code == -999 { return } // The operation couldn’t be completed.
                loadError = true
                showLoading = false
                cancelTimeoutTimer()
                logger.error("Page error: \(error.localizedDescription)")
            })
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    cancelTimeoutTimer()
                    loadingFirstPage = true
                    showLoading = true
                    loginError = false
                    loginUrl = HoppiiURLs.requestLogin.url
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            loginWebView
            Rectangle()
                .foregroundColor(Color(uiColor: .systemBackground))
            #if DEBUG
                .opacity(0.8)
            #endif
            if loadError {
                NetworkErrorView(retryAction: {
                    loadError = false
                    loginUrl = HoppiiURLs.requestLogin.url
                    setTimeoutTimer()
                    loadingFirstPage = true
                })
            } else if showLoading || loginManager.loginState == nil {
                LoadingAnimationView()
            } else {
                LoginInterfaceView(username: $username, password: $password, error: $loginError, loginAction: {
                    // Login pressed.
                    if username == "11N4514", password == "password" {
                        loginManager.isDemo = true
                        loginSuccess()
                        return
                    }
                    webUsername = username
                    webPassword = password
                    setTimeoutTimer()
                })
            }
        }
        .onAppear() {
            loginUrl = HoppiiURLs.requestLogin.url
            
            // Load saved credential.
            if let username = loginManager.username, let password = loginManager.password {
                self.username = username
                self.password = password
            }
            
            setTimeoutTimer()
        }
        .onChange(of: loginError, perform: { newError in
            if newError {
                showLoading = false
                loginManager.username = nil
                loginManager.password = nil
                webUsername = nil
                webPassword = nil
                cancelTimeoutTimer()
            }
        })
    }
}
