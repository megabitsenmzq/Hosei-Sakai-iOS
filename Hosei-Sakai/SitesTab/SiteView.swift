//
//  AnnouncementsView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/21.
//

import SwiftUI

struct SiteView: View {
    @State var siteID: String
    @State var announcements: Announcements?
    @State var contents: Contents?
    
    func containerTitle(_ container: String) -> String {
        var containerPath = container.components(separatedBy: "/")
        containerPath.removeLast()
        return containerPath.last ?? ""
    }
    
    var body: some View {
        List {
            #if DEBUG
            Section("Debug") {
                HStack {
                    Text("SiteID")
                    Spacer()
                    Button(siteID) {
                        UIPasteboard.general.string = siteID
                    }
                }
            }
            #endif
            Section("お知らせ") {
                if let announcements = announcements?.announcementCollection {
                    if announcements.isEmpty {
                        Text("なし")
                    }
                    ForEach(Array(zip(announcements.indices, announcements)), id: \.1.id) { index, item in
                        NavigationLink(destination: {
                            AnnouncementsDetailView(item: item)
                        }, label: {
                            Text(item.title)
                        })
                    }
                } else {
                    HStack {
                        ProgressView().padding(.trailing, 4)
                        Text("読み込み中")
                    }
                }
            }
            
            Section("教材") {
                if let contentsOfSite = contents?.contentCollection.dropFirst() {
                    
                    if contentsOfSite.isEmpty {
                        Text("なし")
                    }
                    
                    let firstRootItem = contentsOfSite.first(where: { containerTitle($0.container) == siteID && $0.type != "collection" })
                    ForEach(contentsOfSite, id: \.self) { item in
                        if item.type == "collection" {
                            HStack {
                                Text(Image(systemName: "folder.fill"))
                                Text(item.title)
                            }
                            .font(.footnote)
                            .foregroundStyle(Color.accentColor)
                        } else {
                            if item.url == firstRootItem?.url && item.url != contentsOfSite.first?.url  {
                                HStack {
                                    Text(Image(systemName: "folder.fill"))
                                    Text("その他")
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.accentColor)
                            }
                            AttachmentView(fileName: item.title, fileURL: item.url)
                                .padding(.vertical, -8)
                        }
                    }
                        
                } else {
                    HStack {
                        ProgressView().padding(.trailing, 4)
                        Text("読み込み中")
                    }
                }
            }
        }
        .task {
            announcements = await AnnouncementManager.shared.getAnnouncements(siteID: siteID)
            contents = await ContentsManager.shared.getContents(siteID: siteID)
        }
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static var previews: some View {
        SiteView(siteID: "71964")
    }
}
