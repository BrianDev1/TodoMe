//
//  TodoData.swift
//  TodoMe
//
//  Created by Brian Rudolph on 2018/03/26.
//  Copyright © 2018 Brian Rudolph. All rights reserved.
//

import Foundation
import RealmSwift


class TodoData: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  //Parent is Category, linking parent and child
    
}
