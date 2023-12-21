//
//  AssignmentView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI

struct AssignmentsTab: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var assignmentManager: AssignmentManager
    @AppStorage("swipeRightTip") var swipeRightTipDismissed = false
//    @State var swipeRightTipDismissed = false

    // TODO: No Assignment View.
    var body: some View {
        NavigationView {
            if let assignments = assignmentManager.assignments {
                List {
                    if !swipeRightTipDismissed {
                        Section {
                            Label("右にスワイプして完成する", systemImage: "arrow.right")
                                .swipeActions(edge: .leading) {
                                    Button("完成") {
                                        withAnimation {
                                            swipeRightTipDismissed = true
                                        }
                                    }.tint(.accentColor)
                                }
                        }
                    }
                    Section {
                        ForEach(Array(zip(assignments.indices, assignments)), id: \.1.id) { index, item in
                            if !(item.markAsFinished ?? false) {
                                NavigationLink {
                                    VStack(spacing: 0) {
                                        AssignmentDetailView(item: item)
                                    }
                                } label: {
                                    AssignmentListRowView(
                                        title: item.title,
                                        teacher: item.authorName ?? "",
                                        dueTime: item.dueTimeString
                                    )
                                }
                                .swipeActions(edge: .leading) {
                                    Button("完成") {
                                        withAnimation {
                                            assignmentManager.assignments?[index].markAsFinished = true
                                            swipeRightTipDismissed = true
                                        }
                                    }.tint(.accentColor)
                                }
                            }
                        }
                    } header: {
                        Text("進行中")
                    }
                    
                    Section {
                        ForEach(assignments.indices, id: \.self) { index in
                            let item = assignments[index]
                            if item.markAsFinished ?? false {
                                NavigationLink {
                                    HTMLWebView(htmlString: item.instructions)
                                } label: {
                                    AssignmentListRowView(
                                        title: item.title,
                                        teacher: item.authorName ?? "",
                                        dueTime: item.dueTimeString
                                    )
                                    .opacity(0.5)
                                }
                                .swipeActions(edge: .leading) {
                                    Button("非完成") {
                                        withAnimation {
                                            assignmentManager.assignments?[index].markAsFinished = false
                                        }
                                    }.tint(.accentColor)
                                }
                            }
                        }
                    } header: {
                        Text("完成")
                    }
                }
                .navigationTitle("課題")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            assignmentManager.refreshAssignments()
                        } label: {
                            switch assignmentManager.state {
                            case .refreshing:
                                ProgressView()
                            case .error(_):
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.orange)
                            default:
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                    }
                }
            } else {
                LoadingAnimationView()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                assignmentManager.refreshAssignments()
            }
        }
        .onAppear {
            assignmentManager.refreshAssignments()
        }
    }
}

struct AssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsTab()
    }
}
