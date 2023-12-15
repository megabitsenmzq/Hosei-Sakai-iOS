//
//  UserDefaults+Date.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/10/18.
//

import Foundation

extension UserDefaults {
    func set(date: Date?, forKey key: String){
        self.set(date, forKey: key)
    }
    
    func date(forKey key: String) -> Date? {
        return self.value(forKey: key) as? Date
    }
}
