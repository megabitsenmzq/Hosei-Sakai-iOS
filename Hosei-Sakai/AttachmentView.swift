//
//  AttachmentView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/25.
//

import SwiftUI
import QuickLook

struct AttachmentView: View {
    @ObservedObject var download = AttachmentDownloader()
    @State var fileName: String
    @State var fileURL: URL
    
    @State var downloading = false
    @State var previewURL: URL?
    var body: some View {
        ZStack {
            HStack {
                Text(fileName)
                Spacer()
                ZStack {
                    if downloading {
                        ProgressView()
                    }
                    Button(action: {
                        if let fileURL = download.fileURL {
                            previewURL = fileURL
                        } else {
                            downloading = true
                            download.downloadFileToCache(url: fileURL)
                        }
                    }, label: {
                        Image(systemName: "eye.fill")
                    })
                    .opacity(downloading ? 0 : 1)
                }
            }
            .padding(.vertical, 8)
            VStack {
                Color.clear
                    .layoutPriority(-1)
                if downloading {
                    ProgressView(value: download.progress)
                }
            }
            .layoutPriority(-1)
        }
        .onChange(of: download.fileURL) { newURL in
            guard let newURL = newURL else { return }
            downloading = false
            previewURL = newURL
        }
        #if !targetEnvironment(macCatalyst)
        .quickLookPreview($previewURL)
        #endif
    }
}

struct AttachmentView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentView(fileName: "FileName.pdf", fileURL: URL(string: "https://google.com")!)
    }
}
