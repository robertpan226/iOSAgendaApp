//
//  sFile.swift
//  CalenderApp
//
//  Created by Robert Pan on 2016-04-13.
//  Copyright © 2016 Robert Pan. All rights reserved.
//

import Foundation

class Singleton {
   // static let sharedInstance = Singleton()
    var tasks = [String]()
    var details = [String]()
    var allDates = [String]()
    var indexValue: Int = 0
    
    private init() {
        
    }
    
}

let sharedInstance = Singleton()
