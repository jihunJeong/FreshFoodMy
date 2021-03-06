//
//  ShoppingListTableViewCell.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//


import UIKit
import RealmSwift

class ShoppingListTableViewCell: UITableViewCell {
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var quauntityofFood: UILabel!
    @IBOutlet weak var detailView: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    var isButtonChecked:Bool!
    var date : Date?
    var index : Int?
    var type:String?
    var memo:String?
    
//    var ListInformation:Object?
    
    let realm = try! Realm()
    weak var delegate : ShoppingListTableViewCellDelegator?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.detailView.addTarget(self, action: #selector(detailButtonPressed(_:)), for: .touchUpInside)
    }
    

    @IBAction func buttonPressed(_ sender: UIButton) {
        if(isButtonChecked)
        {
            sender.setTitleColor(UIColor.gray, for: UIControl.State.normal)
            isButtonChecked = false
            let tempObject = realm.object(ofType: Shopping.self, forPrimaryKey: foodName.text)
            do{
                try self.realm.write{
                    tempObject?.buttonPressed = false
                }
            } catch{ print("\(error)") }
        }
        else{
            sender.setTitleColor(UIColor.orange, for: UIControl.State.normal)
            isButtonChecked = true
            let tempObject = realm.object(ofType: Shopping.self, forPrimaryKey: foodName.text)
            do{
                try self.realm.write{
                    tempObject?.buttonPressed = true
                }
            } catch{ print("\(error)") }
        }
//        self.delegate?.checkBox(check: isButtonChecked, checkindex: index!)
        
    }
    @IBAction func detailButtonPressed(_ sender: UIButton) {
        self.delegate?.shoppingListTableViewCell(self, shoppingListButtonPressedFor: foodName.text!, date: date!, quantity: quauntityofFood.text!, type:self.type!, memo: self.memo! )
    }
}
protocol ShoppingListTableViewCellDelegator: AnyObject{
    func shoppingListTableViewCell(_ shoppingListTableViewCell: ShoppingListTableViewCell, shoppingListButtonPressedFor name:String, date:Date, quantity:String, type:String, memo:String)
//    func checkBox(check:Bool, checkindex:Int)
}
