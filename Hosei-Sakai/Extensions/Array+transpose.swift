//
//  Array+transpose.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2023/12/19.
//

import Foundation

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    func transpose() -> [[Element.Element]] {
        return self.isEmpty ? [] : (0...(self.first!.endIndex - 1)).map { i -> [Element.Element] in self.map { $0[i] } }
    }
}
