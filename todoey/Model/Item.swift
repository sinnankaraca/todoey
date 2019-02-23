//
//  Item.swift
//  todoey
//
//  Created by Sinan MacBook on 24.02.2019.
//  Copyright © 2019 Sinan MacBook. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
