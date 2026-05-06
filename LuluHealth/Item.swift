//
//  Item.swift
//  LuluHealth
//
//  Created by Zhangyc on 2026/5/6.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
