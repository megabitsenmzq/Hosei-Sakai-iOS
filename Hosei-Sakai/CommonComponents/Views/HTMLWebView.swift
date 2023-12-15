//
//  HTMLWebView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/11/08.
//

import SwiftUI
import WebKit
 
struct HTMLWebView: UIViewRepresentable {
    @State var htmlString: String
    var committed: ((URL) -> Void)?
    var finished: ((URL) -> Void)?
    var failed: ((URL) -> Void)?
 
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.contentScaleFactor = 10
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        let optimizeForMobileJSURL = Bundle.main.url(forResource: "OptimizeForMobile", withExtension: "js")!
        if let optimizeForMobile = try? String(contentsOf: optimizeForMobileJSURL, encoding: .utf8) {
            let optimizeForMobileUserScript = WKUserScript(source: optimizeForMobile, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(optimizeForMobileUserScript)
        }
        
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func makeCoordinator() -> HTMLWebViewCoordinator {
        HTMLWebViewCoordinator(self)
    }
}

class HTMLWebViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    private let parent: HTMLWebView
    
    init(_ parent: HTMLWebView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let url = webView.url else { return }
        parent.failed?(url)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        parent.finished?(url)
    }
}

