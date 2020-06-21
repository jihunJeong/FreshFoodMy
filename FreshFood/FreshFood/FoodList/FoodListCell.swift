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
      
    var food : Food?
        
      // the delegate, remember to set to weak to prevent cycles
    var delegate : FoodListCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    @IBAction func subscribeButtonTapped(_ sender: UIButton){
        // ask the delegate (in most case, its the view controller) to
        // call the function 'subscribeButtonTappedFor' on itself.
        delegate?.didSelectButton(food: self.food)
    }
        
}
