//
//  ShoppingListModalViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListModalViewController: UIViewController {
    @IBOutlet weak var shoppingListFoodName: UILabel!
    @IBOutlet weak var shoppingListDate: UILabel!
    @IBOutlet weak var shoppingListQuantity: UILabel!
    @IBOutlet weak var shoppingListMemo: UILabel!
    @IBOutlet weak var shoppingListType: UILabel!
    
    
    var tempString:String?
    var isShowingAlert = false
    var reload = false
    weak var delegate : ShoppingListModalViewControllerDelegator?

    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListFoodName.text = tempString
        
        // Do any additional setup after loading the view.
    }
    
    func showAlert(emptyType: String){
        let alertController = UIAlertController(title: "삭제", message: "\(emptyType)을(를) 삭제하시겠습니까?", preferredStyle: .alert)

       isShowingAlert = true

        alertController.addAction(UIAlertAction(title: "네", style: .cancel){action in
            do{
                try self.realm.write{
                    let predicate = NSPredicate(format: "name = %@ ", self.shoppingListFoodName.text!)
                    self.realm.delete(self.realm.objects(Shopping.self).filter(predicate))
                }
            } catch{ print("\(error)") }
            self.delegate?.updateData()
            self.isShowingAlert = false
            self.dismiss(animated: true, completion: nil)
        })

       alertController.addAction(UIAlertAction(title: "아니오", style: .default) { action in
               self.isShowingAlert = false
               self.dismiss(animated: true, completion: nil)
        })
        

            present(alertController, animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if reload{
            self.delegate?.updateData()
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        showAlert(emptyType: shoppingListFoodName.text!)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShoppingListModifySegue"{
                guard let vc = segue.destination as? ShoppingListModifyViewController else {return}
                vc.delegate = self
                vc.name = self.shoppingListFoodName.text
                vc.purchaseDate = self.shoppingListDate.text
                vc.quantity = self.shoppingListQuantity.text
                vc.type = self.shoppingListType.text
                vc.memo = self.shoppingListMemo.text

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
protocol ShoppingListModalViewControllerDelegator: AnyObject{
    func updateData()
}

extension ShoppingListModalViewController : ShoppingListModifyViewControllerDelegator{
    func reloadData(name: String, quantity: String, purchaseDate: String, type: String, memo: String) {
        shoppingListFoodName.text = name
        shoppingListQuantity.text = quantity
        shoppingListDate.text = purchaseDate
        shoppingListType.text = type
        shoppingListMemo.text = memo
        self.reload = true
        print("--------------------------------------!!!!!@@@@@@")
    }

    
}

