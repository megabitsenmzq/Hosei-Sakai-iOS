//
//  TimeTableView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/24.
//

import SwiftUI
import SwiftSoup

struct TimetableView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var isError = false
    @State var noSunday = false
    @State var noSaturday = false
    @State var table: [[String]]?
    
    var body: some View {
        Group {
            if let table = table {
                TimetableContentView(noSunday: noSunday, noSaturday: noSaturday, table: table)
            } else {
                LoadingAnimationView()
            }
        }
        .task {
            if let newTable = await TimetableManager.shared.getTimetable() {
                var modifiedTable = newTable
                guard !newTable.isEmpty else { return }
                
                // Check if Sunday is empty.
                guard let sunItems = newTable.first?.reduce("", {$0 + $1}) else { return }
                if sunItems == "" {
                    modifiedTable.removeFirst()
                    noSunday = true
                }
                
                // Check if Saturday is empty.
                guard let satItems = newTable.last?.reduce("", {$0 + $1}) else { return }
                if satItems == "" {
                    modifiedTable.removeLast()
                    noSaturday = true
                }
                table = modifiedTable
            }
        }
    }
}

struct TimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView()
    }
}
