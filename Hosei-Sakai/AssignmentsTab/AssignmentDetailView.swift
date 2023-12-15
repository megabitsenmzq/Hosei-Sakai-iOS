//
//  AssignmentDetailView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/06/02.
//

import SwiftUI

struct AssignmentDetailView: View {
    @State var attachment = [AssignmentAttachment]()
    @State var item: Assignments.AssignmentCollection
    var body: some View {
        VStack(spacing: 0) {
            HTMLWebView(htmlString: item.instructions)
            #if DEBUG
            Button("id: \(item.id)") {
                UIPasteboard.general.string = item.id
            }.padding()
            #endif
            VStack {
                ForEach(attachment, id: \.self) { item in
                    AttachmentView(fileName: item.title, fileURL: item.url)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                }
            }
            .background(Color(uiColor: .systemBackground))
            .roundedCorner(20, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.1) ,radius: 5, x: 0, y: -5)
        }
        .task {
            attachment = await AssignmentManager.shared.downloadAttachmentListForAssignment(id: item.id)
        }
    }
}
