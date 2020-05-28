//
//  FoodListTableViewCell.swift
//  FreshFood
//
//  Created by 정지훈 on 2020/05/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class FoodListCell: UITableViewCell {
    @IBOutlet weak var listCell: UIView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var limitDate: UILabel!
    @IBOutlet weak var detailView: UIButton!

    @IBAction func detailView(_ sender: Any) {
        if detailView.isSelected == true {
            detailView.isSelected = false
        } else {
            detailView.isSelected = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
