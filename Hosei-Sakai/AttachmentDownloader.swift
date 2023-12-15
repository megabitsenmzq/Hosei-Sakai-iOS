//
//  AttachmentDownloader.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/25.
//

import Foundation
import OSLog

class AttachmentDownloader: NSObject, ObservableObject {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AttachmentDownloader")
    
    private let cacheFolder = FileManager.default.temporaryDirectory
    private var task: URLSessionTask?
    private var observation: NSKeyValueObservation?
    private var targetFileName: String?
    
    @Published var progress: CGFloat = 0
    @Published var fileURL: URL?
    
    func downloadFileToCache(url: URL) {
        Task {
            targetFileName = url.lastPathComponent
            task = await LoginManager.shared.createSession().downloadTask(with: url)
            task?.delegate = self
            observation = task?.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
                self?.progress = progress.fractionCompleted
            }
            
            task?.resume()
        }
    }
}

extension AttachmentDownloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            logger.error("File download error: \(error.localizedDescription)")
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let targetFileName = targetFileName else { return }
        do {
            let newURL = cacheFolder.appendingPathComponent(targetFileName)
            try? FileManager.default.removeItem(at: newURL)
            try FileManager.default.moveItem(at: location, to: newURL)
            DispatchQueue.main.async {
                self.fileURL = newURL
            }
        } catch {
            logger.error("File download error: \(error.localizedDescription)")
        }
    }
}
