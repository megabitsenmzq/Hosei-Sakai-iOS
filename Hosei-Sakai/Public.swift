//
//  Public.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/10/11.
//

import Foundation

let appGroupName = "group.JinyuMeng.Hosei-Sakai"
let appGroupDefaults = UserDefaults(suiteName: appGroupName)!
let appGroupDocuments = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!
