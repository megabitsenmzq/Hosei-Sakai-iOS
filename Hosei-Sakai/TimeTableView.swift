//
//  TimeTableView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI

struct TimeTableView: View {
    @State var url = HoppiiURLs.timeTablePage.url
    @State var userScripts: String?
    
    @State var username = ""
    @State var password = ""
    @State var isError = false
    
    var body: some View {
        AutoLoginWebView(url: $url, username: .constant(LoginManager.shared.username), password: .constant(LoginManager.shared.password), isLoginError: $isError)
    }
}

struct TimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableView()
    }
}
