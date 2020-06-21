//
//  FoodStructure.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import Foundation
import RealmSwift

class Food : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var limitDate : Date = Date()
    @objc dynamic var quantity : Double = Double()
    @objc dynamic var location : String = ""
    @objc dynamic var memo : String = ""
    @objc dynamic var type : String = ""
}
