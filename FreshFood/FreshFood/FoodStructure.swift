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
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var limitDate : Date = Date()
    @objc dynamic var purchaseDate : Date = Date()
    @objc dynamic var quantity : Double = 0.0
    @objc dynamic var location : String = ""
    @objc dynamic var memo : String = ""
    @objc dynamic var type : String = ""
    
    
    init(name:String, limitdate:Date, fridgetype:String, quantity: Double, type:String, memo:String) {
        self.name = name
        self.limitDate = limitdate
        self.location = fridgetype
        self.quantity = quantity
        self.type = type
        self.memo = memo
    }
    
    override required init() {
        super.init()
    }
    
    @objc override static func primaryKey() -> String? {
        return "id"
    }
 
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
