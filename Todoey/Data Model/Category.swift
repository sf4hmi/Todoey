//
//  Category.swift
//  Todoey
//
//  Created by Fahmi Sulaiman on 23.01.18.
//  Copyright © 2018 Fahmi Sulaiman. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // Forward relationship to item
}
