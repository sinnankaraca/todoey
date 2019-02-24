//
//  Category.swift
//  todoey
//
//  Created by Sinan MacBook on 24.02.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    // let array = Array<Int>()
    let items = List<Item>()
    
    
    
}
