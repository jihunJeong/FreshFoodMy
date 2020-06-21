//
//  FoodListTableViewCell.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class FoodListCell: UITableViewCell {
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var limitDate: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
      
    var food : String?
        
      // the delegate, remember to set to weak to prevent cycles
    weak var delegate : FoodListCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            
        // Add action to perform when the button is tapped
        self.subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    @IBAction func subscribeButtonTapped(_ sender: UIButton){
        // ask the delegate (in most case, its the view controller) to
        // call the function 'subscribeButtonTappedFor' on itself.
        if let food = food, let delegate = delegate {
            self.delegate?.FoodListCell(self, subscribeButtonTappedFor: food)
           }
    }
        
}

// Only class object can conform to this protocol (struct/enum can't)
protocol FoodListCellDelegate: AnyObject {
    func FoodListCell(_ FoodListCell: FoodListCell, subscribeButtonTappedFor food: String)
}
