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
            self.delegate?.deleteData()
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
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        showAlert(emptyType: shoppingListFoodName.text!)
        
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
    func deleteData()
}

