//
//  ShoppingListTableViewCell.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//


import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var qauntityofFood: UILabel!
    @IBOutlet weak var detailView: UIButton!
    
    var isButtonChecked:Bool = false
    
    weak var delegate : ShoppingListTableViewCellDelegator?
    
    var name : String?
    var date : Date?
    var quantity : Double?
    
    var index :Int?
    
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
            //checkButton.titleLabel?.textColor = UIColor.gray
            sender.setTitleColor(UIColor.gray, for: UIControl.State.normal)
            isButtonChecked = false
        }else{
            //checkButton.titleLabel?.textColor = UIColor.blue
            sender.setTitleColor(UIColor.orange, for: UIControl.State.normal)
            isButtonChecked = true
        }
        self.delegate?.checkBox(check: isButtonChecked, checkindex: index! )
        
    }
    @IBAction func detailButtonPressed(_ sender: UIButton) {
//        sender.addTarget(self, action: Selector("segue"), for: .touchUpInside)
        if let name = name,let delegate = delegate{
            self.delegate?.shoppingListTableViewCell(self, shoppingListButtonPressedFor: name, date: date!, quantity: quantity!)
        }
    }
}
protocol ShoppingListTableViewCellDelegator: AnyObject{
    func shoppingListTableViewCell(_ shoppingListTableViewCell: ShoppingListTableViewCell, shoppingListButtonPressedFor name:String, date:Date, quantity:Double)
    func checkBox(check:Bool, checkindex:Int)
}
