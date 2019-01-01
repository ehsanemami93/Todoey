//
//  Items.swift
//  Todoew
//
//  Created by Ehsan Emami on 12/22/18.
//  Copyright © 2018 Ehsan Emami. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Data?
    

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
