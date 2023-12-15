//
//  AssignmentListRowView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/09/26.
//

import SwiftUI

struct AssignmentListRowView: View {
    @EnvironmentObject var assignmentManager: AssignmentManager
    
    @State var title: String
    @State var teacher: String
    @State var dueTime: Date
    
    func isDateSafe() -> Bool {
        let cal = Calendar.current
        let hour = cal.component(.hour, from: dueTime)
        return hour >= 23
    }
    
    func safeDate() -> Date {
        let cal = Calendar.current
        if !isDateSafe() {
            var components = cal.dateComponents([.year, .month, .day], from: dueTime)
            guard let day = components.day else {
                return dueTime
            }
            components.day = day - 1
            components.hour = 23
            components.minute = 55
            return cal.date(from: components) ?? dueTime
        }
        return dueTime
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer(minLength: 0)
            }
            HStack(alignment: .bottom) {
                Text(teacher)
                    .font(.callout)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                if assignmentManager.showOptimizedDate {
                    Text(safeDate().formatted())
                        .foregroundColor(isDateSafe() ? nil : .accentColor)
                        .layoutPriority(1)
                } else {
                    Text(dueTime.formatted())
                        .layoutPriority(1)
                }
            }
        }
    }
}

struct AssignmentListRowView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentListRowView(title: "XXXX概論", teacher: "法政太郎", dueTime: Date())
            .previewLayout(.sizeThatFits)
    }
}
