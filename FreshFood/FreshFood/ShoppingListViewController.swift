//
//  ShoppingListViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
//    func callSegueFromCell(myData dataobject: AnyObject) {
//        self.performSegue(withIdentifier: "ShoppingListFoodDetail", sender: dataobject)
//    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previousDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    @IBOutlet weak var shoppingListTableview: UITableView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
        
    func makeSomeExamples()->[ShoppingListFood]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let shoppingDate:Date = dateFormatter.date(from: "2020.06.10")!
        var temp1 = ShoppingListFood(name: "당근", count: 3, memo: "흙당근 사기", purchaseDate: shoppingDate, buttonPressed: true)
        var temp2 = ShoppingListFood(name: "오이", count: 2, memo: "-", purchaseDate: shoppingDate, buttonPressed: false)
        let shoppingDate2 = dateFormatter.date(from: "2020.06.09")!
        var temp3 = ShoppingListFood(name: "수박", count: 1, memo: "큰 수박으로 사기", purchaseDate: shoppingDate2, buttonPressed: false)
        var temp:[ShoppingListFood] = [temp1,temp2,temp3]
        return temp
          
    }
    struct ShoppingListFood{
         var name: String
         var count: Double
         var memo: String
         var purchaseDate: Date
         var buttonPressed:Bool
     }
    var shoppingLists:[ShoppingListFood]!
    
    var dateTerm:Int = 0
    var setDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableview.delegate = self
        shoppingListTableview.dataSource = self
        dateTerm = 0
        shoppingLists = makeSomeExamples()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: Date())
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func previousButtonPressed(_ sender: Any) {
        dateTerm -= 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let calendar = Calendar.current
        let day = DateComponents(day:dateTerm)
        if let date = calendar.date(byAdding: day, to: Date())
        {
            dateLabel.text = formatter.string(from: date)
            setDate = date
        }
        shoppingListTableview.reloadData()
        
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        dateTerm += 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let calendar = Calendar.current
        let day = DateComponents(day:dateTerm)
        if let date = calendar.date(byAdding: day, to: Date())
        {
            dateLabel.text = formatter.string(from: date)
            setDate = date
        }
        shoppingListTableview.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int)->Int{
        var count:Int = 0
        var i:Int = 0;
        for j in(0..<shoppingLists.count){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            if formatter.string(from: shoppingLists[j].purchaseDate)  ==  formatter.string(from: setDate){
                shoppingLists.swapAt(i, j)
                i += 1
                count += 1
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        var myCell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell",for:indexPath) as!ShoppingListTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        if formatter.string(from: shoppingLists[indexPath.row].purchaseDate)  ==  formatter.string(from: setDate){
            myCell.foodName.text = shoppingLists[indexPath.row].name
            myCell.qauntityofFood.text = String(shoppingLists[indexPath.row].count)
        }
        myCell.name = shoppingLists[indexPath.row].name
        myCell.date = shoppingLists[indexPath.row].purchaseDate
        myCell.quantity = shoppingLists[indexPath.row].count
        myCell.index = indexPath.row
        if shoppingLists[indexPath.row].buttonPressed == false{
            myCell.checkButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        }
        
        myCell.delegate = self
        return myCell
    }
    
//    func callSegueFromCell(myData dataobject: Any){
//    }

    
    
//    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
//        if segue.identifier == "MODAL_SEGUE",
//            let vc = segue.destination as? ModalViewController{
//
//        }
//    }
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//    {
//        performSegue(withIdentifier: "ShoppingListFoodDetial", sender: self)
//        self.performseguewi
//    }
////
//    func tableView(_tableView: UITableView, willSelectRowAt indexPath: NSIndexPath)
//    {
//        return indexPath;
//    }
    var vc:ShoppingListModalViewController? = nil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShoppingListFoodDetail"{
            vc = segue.destination as! ShoppingListModalViewController
        }
        if segue.identifier == "ShoppingListCalendarSegue"{
            let cvc = segue.destination as! ShoppingListCalendarViewController
            cvc.delegate = self
        }
//        vc!.shoppingListFoodName?.text = tempName
//        vc.shoppingListDate.text = shoppingLists[(indexPath?.row)!].purchaseDate
//        vc.shoppingListQuantity.text = shoppingLists[(indexPath?.row)!].count
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShoppingListFoodDetail"{
//            let detailView = segue.destination as! ShoppingListModalViewController
//            let cell = sender as? ShoppingListTableViewCell
//            let senderCell = sender as! FoodListCell
//            let indexPath = shoppingListTableview.indexPath(for: senderCell)!
//            let senderCellName = shoppingLists[indexPath.row].name
//            detailView.shoppingListFoodName?.text = senderCellName
//        }
//    }
    
    
    
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
    func checkBox(check: Bool, checkindex index:Int) {
        shoppingLists[index].buttonPressed = check
    }
    
    func shoppingListTableViewCell(_ shoppingListTableViewCell: ShoppingListTableViewCell, shoppingListButtonPressedFor name: String, date: Date, quantity: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        vc!.shoppingListFoodName.text = name
        vc!.shoppingListDate.text = formatter.string(from: date)
        vc!.shoppingListQuantity.text = String(quantity)
        
    }
    
//    func shoppingListTableViewCell(_ shoppingListTableViewCell: ShoppingListTableViewCell, shoppingListButtonPressedFor name: String) {
////        let vc = (self.storyboard?.instantiateViewController(identifier: "ShoppingListModal"))! as ShoppingListModalViewController
////        self.present(vc, animated: true, completion: nil)
////
////        let temp:String! = name
////        vc.tempString = temp
////        let segue = UIStoryboard.(withIdentifier: "ShoppingListFoddDetail", sender: shoppingListTableViewCell.detailView)
////        let vc = segue.destination as? ShoppingListModalViewController
////        vc.
//        vc!.shoppingListFoodName.text = name
//
//    }
    
}

extension ShoppingListViewController:ShoppingListCalendarDelegator{
    func dateSelected(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: selectDate)
        setDate = selectDate
//        print(formatter.string(from: selectDate))
        
        shoppingListTableview.reloadData()
    }
}

