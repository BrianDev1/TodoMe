//
//  Category.swift
//  TodoMe
//
//  Created by Brian Rudolph on 2018/03/26.
//  Copyright © 2018 Brian Rudolph. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<TodoData>()    //Relationship, categories can have a list of items
    
}
