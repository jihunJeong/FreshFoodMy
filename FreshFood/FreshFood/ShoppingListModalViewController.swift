//
//  ShoppingListModalViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit

class ShoppingListModalViewController: UIViewController {
    @IBOutlet weak var shoppingListFoodName: UILabel!
    @IBOutlet weak var shoppingListDate: UILabel!
    @IBOutlet weak var shoppingListQuantity: UILabel!
    
    var tempString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListFoodName.text = tempString

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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

