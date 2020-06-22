//
//  ShoppingListViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
//    func callSegueFromCell(myData dataobject: AnyObject) {
//        self.performSegue(withIdentifier: "ShoppingListFoodDetail", sender: dataobject)
//    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previousDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    @IBOutlet weak var shoppingListTableview: UITableView!
    
    let realm = try! Realm()
        
//    func makeSomeExamples()->[ShoppingListFood]{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//
//        let shoppingDate:Date = dateFormatter.date(from: "2020.06.10")!
//        var temp1 = ShoppingListFood(name: "당근", count: 3, memo: "흙당근 사기", purchaseDate: shoppingDate, buttonPressed: true)
//        var temp2 = ShoppingListFood(name: "오이", count: 2, memo: "-", purchaseDate: shoppingDate, buttonPressed: false)
//        let shoppingDate2 = dateFormatter.date(from: "2020.06.09")!
//        var temp3 = ShoppingListFood(name: "수박", count: 1, memo: "큰 수박으로 사기", purchaseDate: shoppingDate2, buttonPressed: false)
//        var temp:[ShoppingListFood] = [temp1,temp2,temp3]
//        return temp
//
////    }
//    struct ShoppingListFood{
//         var name: String
//         var count: Double
//         var memo: String
//         var purchaseDate: Date
//         var buttonPressed:Bool
//     }
//    var shoppingLists:[ShoppingListFood]!
    
    var dateTerm:Int = 0
    var setDate:Date = Date()
    let formatter = DateFormatter()
    lazy var savedDates = realm.objects(Shopping.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableview.delegate = self
        shoppingListTableview.dataSource = self
        dateTerm = 0
//        shoppingLists = makeSomeExamples()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: Date())
        // Do any additional setup after loading the view.
        
    }
    
   
    @IBAction func previousButtonPressed(_ sender: Any) {
        dateTerm = -1
        let calendar = Calendar.current
        let day = DateComponents(day:dateTerm)
        if let date = calendar.date(byAdding: day, to: setDate)
        {
            dateLabel.text = formatter.string(from: date)
            setDate = date
        }
        shoppingListTableview.reloadData()
        
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        dateTerm = 1
        let calendar = Calendar.current
        let day = DateComponents(day:dateTerm)
        if let date = calendar.date(byAdding: day, to: setDate)
        {
            dateLabel.text = formatter.string(from: date)
            setDate = date
        }
        shoppingListTableview.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int)->Int{
        var count:Int = 0
        let FoodLists = Array(savedDates)
        
//        for j in(0..<shoppingLists.count){
//            if formatter.string(from: shoppingLists[j].purchaseDate)  ==  formatter.string(from: setDate){
//                count += 1
//            }
//        }
        return FoodLists.filter{formatter.string(from: $0.purchaseDate) == formatter.string(from: setDate)}.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let myCell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell",for:indexPath) as!ShoppingListTableViewCell
        let FoodLists = Array(savedDates)
        let tempList = FoodLists.filter{formatter.string(from: $0.purchaseDate) == formatter.string(from: setDate)}
        
        myCell.foodName.text = tempList[indexPath.row].name
        myCell.quauntityofFood.text = String(tempList[indexPath.row].quantity)
        myCell.isButtonChecked = tempList[indexPath.row].buttonPressed
        myCell.date = tempList[indexPath.row].purchaseDate

        if (myCell.isButtonChecked){
            myCell.checkButton.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        }else{
            myCell.checkButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        }
        myCell.index = indexPath.row
        myCell.delegate = self
        
        return myCell
    }
    
    var vc:ShoppingListModalViewController? = nil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShoppingListFoodDetail"{
            vc = segue.destination as! ShoppingListModalViewController
            vc!.delegate = self
        }
        if segue.identifier == "ShoppingListCalendarSegue"{
            let cvc = segue.destination as! ShoppingListCalendarViewController
            cvc.delegate = self
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
        
}

extension ShoppingListViewController:ShoppingListTableViewCellDelegator{
//    func checkBox(check: Bool, checkindex index:Int) {
////        shoppingLists[index].buttonPressed = check
////        print("***** \(shoppingLists[index].name) buttonPressed : \(check)")
//    }
    
    func shoppingListTableViewCell(_ shoppingListTableViewCell: ShoppingListTableViewCell, shoppingListButtonPressedFor name: String, date: Date, quantity: String) {
        formatter.dateFormat = "yyyy.MM.dd"
        vc!.shoppingListFoodName.text = name
        vc!.shoppingListDate.text = formatter.string(from: date)
        vc!.shoppingListQuantity.text = quantity
    }
    
}

extension ShoppingListViewController:ShoppingListCalendarDelegator{
    func dateSelected(selectDate: Date) {
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: selectDate)
        setDate = selectDate
        
        shoppingListTableview.reloadData()
    }
}

extension ShoppingListViewController:ShoppingListModalViewControllerDelegator{
    func deleteData() {
        shoppingListTableview.reloadData()
    }
    
}

