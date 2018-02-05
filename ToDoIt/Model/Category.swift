//
//  Category.swift
//  ToDoIt
//
//  Created by Brian Wilson on 2/2/18.
//  Copyright © 2018 Brian Wilson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    
    let items = List<Item>()
}
