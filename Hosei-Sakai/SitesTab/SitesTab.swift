//
//  SitesView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/04/21.
//

import SwiftUI

struct SitesTab: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var siteManager: SiteManager
    
    @State var otherSitesExpand = false
    var body: some View {
        NavigationView {
            if let sites = siteManager.sites {
                List {
                    Section("今学期") {
                        ForEach(Array(zip(sites.indices, sites)), id: \.1.id) { index, item in
                            if item.joinable {
                                NavigationLink(destination: {
                                    SiteView(siteID: item.id)
                                }, label: {
                                    Text(item.title)
                                })
                            }
                        }
                    }
//                    Section("その他") {
//                        ForEach(Array(zip(sites.indices, sites)), id: \.1.id) { index, item in
//                            if !item.joinable {
//                                NavigationLink(destination: {
//                                    SiteView(siteID: item.id)
//                                }, label: {
//                                    Text(item.title)
//                                })
//                            }
//                        }
//                    }                
                }
                .navigationTitle("授業")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            siteManager.refreshSites()
                        } label: {
                            switch siteManager.state {
                            case .refreshing:
                                ProgressView()
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
                siteManager.refreshSites()
            } else if newPhase == .inactive {
                
            } else if newPhase == .background {
                
            }
        }
        .onAppear {
            siteManager.refreshSites()
        }
    }
}

struct SitesView_Previews: PreviewProvider {
    static var previews: some View {
        SitesTab()
            .environmentObject(SiteManager.shared)
    }
}
