//
//  Category.swift
//  Todoey
//
//  Created by Thomas Amaranto on 13/03/18.
//  Copyright © 2018 Thomas Amaranto. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    //MARK: - Attributi dell'oggetto
    @objc dynamic var name : String = ""
    
    //MARK: - Relazioni
    let items = List<Item>()   // Stabilisco la relazione diretta fra categoria e elementi
    
}
