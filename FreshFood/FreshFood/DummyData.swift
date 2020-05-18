//
//  DummyData.swift
//  ManageIngredient
//
//  Created by 정지훈 on 2020/05/14.
//  Copyright © 2020 정지훈. All rights reserved.
//

import Foundation

struct Ingredient {
    var name: String
    var quantity: Double
}

let ingredientList: [Ingredient] = [
    Ingredient(name: "Food Name", quantity: 3),
    Ingredient(name: "Food Quantity", quantity: 3),
    Ingredient(name: "Food Limit Date", quantity: 3),
    Ingredient(name: "Buy Location", quantity: 3),
    Ingredient(name: "Which Company", quantity: 3),
    Ingredient(name: "Buy Date", quantity: 3),
    Ingredient(name: "Memo", quantity: 3),
    Ingredient(name: "Notification", quantity: 3)
]
