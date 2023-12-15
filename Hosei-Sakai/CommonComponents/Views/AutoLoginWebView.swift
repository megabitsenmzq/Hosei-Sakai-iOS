//
//  WebView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/22.
//

import SwiftUI
import WebKit
 
struct AutoLoginWebView: UIViewRepresentable {
    @State var shouldOptimizeForMobile = false
    @Binding var url: URL
    @Binding var username: String?
    @Binding var password: String?
    @Binding var isLoginError: Bool
    
    var committed: ((URL) -> Void)?
    var finished: ((URL) -> Void)?
    var failed: ((Error) -> Void)?
 
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.contentScaleFactor = 10
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        let request = URLRequest(url: url)
        webView.load(request)
        
        let optimizeForMobileJSURL = Bundle.main.url(forResource: "OptimizeForMobile", withExtension: "js")!
        if let optimizeForMobile = try? String(contentsOf: optimizeForMobileJSURL, encoding: .utf8) {
            let optimizeForMobileUserScript = WKUserScript(source: optimizeForMobile, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(optimizeForMobileUserScript)
        }
        
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        if url != webView.url {
            webView.stopLoading()
            webView.load(URLRequest(url: url))
        }
        
        // Apply when login credential changed.
        if let username = username, let password = password {
            let autoLoginFormatted = String(format: HoppiiJSs.autoLogin.rawValue, username, password)
            webView.evaluateJavaScript(autoLoginFormatted)
        }
    }
    
    func makeCoordinator() -> AutoLoginWebViewCoordinator {
        AutoLoginWebViewCoordinator(self)
    }
}

class AutoLoginWebViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    private let parent: AutoLoginWebView
    
    init(_ parent: AutoLoginWebView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        parent.url = url
        parent.committed?(url)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        parent.failed?(error)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let url = webView.url else { return }
        parent.url = url
        parent.failed?(error)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        
        // Check if the login page has error message on it.
        if url.absoluteString.hasPrefix(HoppiiURLs.hoseiSSO.rawValue) {
            webView.evaluateJavaScript(HoppiiJSs.checkLoginState.rawValue) { [weak self] data, error in
                if let count = data as? Int, count != 0 {
                    self?.parent.isLoginError = true
                    self?.parent.username = nil
                    self?.parent.password = nil
                } else {
                    self?.parent.isLoginError = false
                }
            }
        }
        
        parent.url = url
        parent.finished?(url)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        Task { @MainActor in
            for cookie in LoginManager.shared.savedCookies ?? [] {
                await webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
            decisionHandler(.allow)
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        Task {
            await LoginManager.shared.preserveCookies()
        }
        decisionHandler(.allow)
    }
}
