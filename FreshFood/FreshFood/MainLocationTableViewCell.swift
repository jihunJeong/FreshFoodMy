//
//  MainLocationTableViewCell.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/23.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class MainLocationTableViewCell: UITableViewCell {

//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var mainLocationNameLabel: UILabel!
    @IBOutlet weak var mainLocationQuantityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
