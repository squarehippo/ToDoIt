//
//  Item.swift
//  ToDoIt
//
//  Created by Brian Wilson on 2/2/18.
//  Copyright © 2018 Brian Wilson. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
