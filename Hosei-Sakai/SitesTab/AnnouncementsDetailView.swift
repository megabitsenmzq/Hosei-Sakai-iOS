//
//  AnnouncementsDetailView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/24.
//

import SwiftUI

struct AnnouncementsDetailView: View {
    @State var item: Announcements.AnnouncementCollection
    @State var loading = true
    
    var body: some View {
        VStack(spacing: 0) {
            HTMLWebView(htmlString: item.body.replacingOccurrences(of: "color: black;", with: ""), finished: { _ in
                loading = false
            })
            .overlay {
                if loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            VStack {
                ForEach(item.attachments, id: \.id) { attachment in
                    AttachmentView(fileName: attachment.name, fileURL: attachment.url)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                }
            }
            .background(Color(uiColor: .systemBackground))
            .roundedCorner(20, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.1) ,radius: 5, x: 0, y: -5)
        }
    }
}

//struct AnnouncementsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
