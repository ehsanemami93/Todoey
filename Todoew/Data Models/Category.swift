//
//  Category.swift
//  Todoew
//
//  Created by Ehsan Emami on 12/22/18.
//  Copyright © 2018 Ehsan Emami. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
