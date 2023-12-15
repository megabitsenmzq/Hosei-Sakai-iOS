//
//  ClassroomWebView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/07/18.
//

import SwiftUI
import WebKit
import OSLog
 
struct ClassroomWebView: UIViewRepresentable {
    @Binding var loading: Bool
    @Binding var error: Error?
    @Binding var downloadedFile: URL?
    
    var stage = 0
 
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        let request = URLRequest(url: URL(string: "https://hoseikoganei-trircampus.com/ss/")!)
        webView.load(request)
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        if loading {
            let request = URLRequest(url: URL(string: "https://hoseikoganei-trircampus.com/ss/")!)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> ClassroomWebViewCoordinator {
        ClassroomWebViewCoordinator(self)
    }
}

class ClassroomWebViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKDownloadDelegate {
    private let parent: ClassroomWebView
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ClassroomWebView")
    
    var stage = 0
    
    init(_ parent: ClassroomWebView) {
        self.parent = parent
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        print(url)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as NSError).code == 102 {
            return
        }
        parent.error = error
        logger.error("Did fail provisional navigation: \(error.localizedDescription)")
        parent.loading = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        parent.error = error
        logger.error("Did fail: \(error.localizedDescription)")
        parent.loading = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch stage {
        case 0 :
            let login = """
                document.getElementById("usrId").value = "student";
                document.querySelectorAll('input[type=password]')[0].value = "hoseidekou";
                document.getElementsByClassName("login_btn2")[0].click();
            """
            webView.evaluateJavaScript(login)
        case 1:
            webView.evaluateJavaScript("chgPreviewMode('1');")
        case 2:
            webView.evaluateJavaScript("daySearch();")
        case 3:
            webView.evaluateJavaScript("document.getElementsByClassName('submit_btn')[0].click();")
        default:
            break
        }
        stage += 1
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.shouldPerformDownload {
            decisionHandler(.download)
        } else {
            decisionHandler(.allow)
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.canShowMIMEType {
            decisionHandler(.allow)
        } else {
            decisionHandler(.download)
        }
    }
    
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
        
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }
    
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("classroom.pdf")
        try? FileManager.default.removeItem(at: url)
        completionHandler(url)
    }
    
    func downloadDidFinish(_ download: WKDownload) {
        parent.downloadedFile = FileManager.default.temporaryDirectory.appendingPathComponent("classroom.pdf")
        parent.loading = false
    }
    
    func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        parent.loading = false
        parent.error = error
        logger.error("File download error: \(error.localizedDescription)")
    }
    
}
