//
//  Item.swift
//  Todoey
//
//  Created by Thomas Amaranto on 13/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    //@objc dynamic var dateCreated : Date
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Stabilisco la relazione inversa fra elementi e categorie
    
    
}
