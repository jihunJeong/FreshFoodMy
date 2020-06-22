//
//  FoodStructure.swift사과
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
    @objc dynamic var purchaseDate : Date = Date()
    @objc dynamic var quantity : Double = 0.0
    @objc dynamic var location : String = ""
    @objc dynamic var memo : String = ""
    @objc dynamic var type : String = ""
   //@objc dynamic var buttonPressed : Bool = false
}

class Shopping : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var purchaseDate : Date = Date()
    @objc dynamic var quantity : Double = Double()
    @objc dynamic var memo : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var buttonPressed : Bool = false
    
    @objc override static func primaryKey() -> String? {
        return "name"
    }
}
