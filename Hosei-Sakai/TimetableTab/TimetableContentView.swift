//
//  TimetableContentView.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/12/19.
//

import SwiftUI

struct TimetableContentView: View {
    var noSunday = false
    var noSaturday = false
    
    var table: [[String]]
    
    @ViewBuilder
    func tableCell(_ text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.accentColor)
                .opacity(text == "" ? 0 : 1)
                .padding(1)
                .border(Color(uiColor: .systemGray5), width: 0.5)
            Text(text)
                .colorInvert()
                .font(.system(size: 10, weight: .bold))
                .padding(3)
        }
    }
    
    func vHeaderText() -> [String] {
        var header = ["日", "月", "火", "水", "木", "金", "土"]
        if noSunday {
            header.removeFirst()
        }
        if noSaturday {
            header.removeLast()
        }
        return header
    }
    
    var vHeader: some View {
        HStack(spacing: 0) {
            ForEach(vHeaderText(), id: \.self) { item in
                ZStack {
                    HStack {
                        Spacer()
                        Text(item)
                            .font(.system(size: 10, weight: .bold))
                        Spacer()
                    }
                    .frame(height: 20)
                    .border(Color(uiColor: .systemGray5), width: 0.5)
                }
            }
        }
    }
    
    var hHeader: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(width: 20, height: 20)
                .border(Color(uiColor: .systemGray5), width: 0.5)
            ForEach(1...table.first!.count, id: \.self) { index in
                ZStack {
                    VStack {
                        Spacer()
                        Text("\(index)")
                            .font(.system(size: 10, weight: .bold))
                        Spacer()
                    }
                    .frame(width: 20)
                    .border(Color(uiColor: .systemGray5), width: 0.5)
                }
            }
        }
    }
    
    var tableBody: some View {
        HStack(spacing: 0) {
            ForEach(table, id:\.self) { row in
                VStack(spacing: 0) {
                    ForEach(row, id: \.uuid) { column in
                        tableCell(column)
                    }
                }
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            hHeader
            VStack(spacing: 0) {
                vHeader
                tableBody
            }
        }
        .border(Color(uiColor: .systemGray5), width: 1)
        .padding()
    }
}

#Preview {
    TimetableContentView(table: [["", "", "", "", "", "", ""], ["", "", "", "", "情報システムデザイン", "", ""], ["", "プロジェクト実習・制作２", "", "プロジェクト実習・制作２", "ＡＩプログラミング", "", ""], ["", "プロジェクト実習・制作２", "デザイン・バックキャスティン...", "プロジェクト実習・制作２", "ＡＩプログラミング", "", ""], ["", "", "デザイン・バックキャスティン...", "デザインケーススタディ", "", "", ""], ["", "", "", "", "", "", ""], ["", "", "", "", "", "", ""]])
}
