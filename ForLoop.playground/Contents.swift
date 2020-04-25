import UIKit
import GameplayKit

// ----------------- For Loop #1---------

let limitDates = [1, 10, 7, 4, 2, 0.5, 9, 8, 18]
var checkDate = [Double]()

for limitDate in limitDates {
    if limitDate < 3 {
        checkDate.append(limitDate)
    }
}

checkDate


// ----------------- For Loop #2---------

var foodDatas : [String:Int] = ["Carrot":3, "Milk":100, "Strawberry": 50, "Orange": 5, "Graphes": 70, "Watermelon": 1]
var stringElementList = [String]()

for foodData in foodDatas {
    stringElementList.append(foodData.key)
}

stringElementList

// ----------------- For Loop #3---------

var priceFoods = [100, 2, 9, 40, 59, 13, 290]
var sum: Int = 0

for priceFood in priceFoods {
    sum += priceFood
}

sum


// ----------------- For Loop #4--------

enum materialData {
    case name, quantity, date, location
}

var strings = [String]()

let informations: [materialData] = [.name, .quantity, .date, .location]
for information in informations {
    strings.append("\(information)")
}

strings

// ----------------- For Loop #5--------

let evenNumbers = [2,4,6,8]
var toStrings = [String]()
for even in evenNumbers {
    toStrings.append("\(even)")
}

// ----------------- For Loop #6--------

let values = [1,2,3,4,5,6,7,8,9]
var doubledValues = [Int]()
for value in values {
    doubledValues.append(value * 2)
}

// ----------------- For Loop #7--------

let numbers = 1...100
var result:Int = 0
for x in numbers{
    result += x
}

//----------------- For Loop # 8-----------
var tradingVolume:Int
var sharePrice:Int
var tradingValue:Int
var tradingValueData = [Int]()

for i in 1..<11{
    tradingVolume = GKRandomDistribution(lowestValue: 1, highestValue: 3000).nextInt()
    sharePrice = GKRandomDistribution(lowestValue: 300, highestValue: 360).nextInt() * 500
    tradingValue = tradingVolume*sharePrice
    tradingValueData.append(tradingValue)
    
}

//---------------For Loop # 9---------------
var count = 0
for i in tradingValueData{
    if i>=400000000{
        count+=1
    }
}
count

//--------------For Loop # 10----------------
let bidVolume = [3503,2322,2771,5609, 7733]
let askVolume = [3227,1255,8777,10323,1036]
var bidAskRatio:Double
var signalCount = 0
if count>=2{
    for i in 0..<5{
        bidAskRatio = Double(bidVolume[i]/askVolume[i])
        if bidAskRatio<=1.2 && bidAskRatio>=(1/1.2){
            print("매수 시그널 발생")
            signalCount += 1
        }
    }
    if signalCount >= 2{
        print("매수 주문 완료")
    }
    
}

