//
//  SakaiRefreshState.swift
//  Hosei-Sakai
//
//  Created by Jinyu Meng on 2022/10/18.
//

import Foundation

enum SakaiRefreshState {
    case ready
    case refreshing
    case error(Error)
    case timeout
}
