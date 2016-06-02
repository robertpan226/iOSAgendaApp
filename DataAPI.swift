//
//  DataAPI.swift
//  CalenderApp
//
//  Created by Robert Pan on 2016-04-15.
//  Copyright © 2016 Robert Pan. All rights reserved.
//

import Foundation

/*
class dataSingleton {
    
    static let sharedInstance = dataSingleton()
    
    var tasks = [String]()
    var details = [String]()
    var allDates = [String]()
    
    init() { print("AAA"); }
}
let sharedInstance = dataSingleton()
*/

class TheOneAndOnlyKraken {
    static let sharedInstance = TheOneAndOnlyKraken()
    
    var potato = "Hello"
    
    func pot() {
        potato = "Noob"
    }
}