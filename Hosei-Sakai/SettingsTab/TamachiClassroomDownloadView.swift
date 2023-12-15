//
//  TamachiClassroomDownloadView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/07/18.
//

import Foundation
import SwiftUI

struct TamachiClassroomDownloadView: View {
    @State var loadingClassroom = false
    @State var classroomError: Error? = nil
    @State var previewURL: URL?
        
    var body: some View {
        ZStack {
            HStack {
                Text("田町教室予約状況")
                Spacer()
                Button(action: {
                    loadingClassroom = true
                }, label: {
                    if loadingClassroom {
                        ProgressView()
                    } else {
                        Image(systemName: "eye.fill")
                    }
                })
            }
                #if !targetEnvironment(macCatalyst)
                .quickLookPreview($previewURL)
                #endif
            if loadingClassroom {
                ClassroomWebView(loading: $loadingClassroom, error: $classroomError, downloadedFile: $previewURL)
                        .opacity(0)
            }
        }
    }
}
