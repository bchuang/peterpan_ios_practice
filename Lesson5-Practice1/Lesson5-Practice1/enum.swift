//
//  enum.swift
//  Lesson5-Practice1
//
//  Created by Chuang Boris on 09/11/2017.
//  Copyright © 2017 Chuang Boris. All rights reserved.
//

import Foundation

enum direction:Int {
    case up = 1
    //    case down = 2
    //    case left = 3
    //    case right = 4
    case down
    case left
    case right
    
    var int: Int {
        return Int(self.rawValue)
    }
}
