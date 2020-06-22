//
//  ShoppingListAddViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/22.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift



class ShoppingListAddViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var purchasDateTextField: UITextField!
    @IBOutlet weak var memoDataTextField: UITextField!
        
    var isShowingAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        // Do any additional setup after loading the view.
    }
    
    func showAlert(emptyType: String){
        let alertController = UIAlertController(title: "오류", message: "\(emptyType)을 입력하세요", preferredStyle: .alert)

                   isShowingAlert = true

                   alertController.addAction(UIAlertAction(title: "OK", style: .default) { action in
                       self.isShowingAlert = false
                       self.dismiss(animated: true, completion: nil)
                       //self.transitioningDelegate.
                       
                   })

                   present(alertController, animated: true)
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        guard let dataName = self.nameTextField.text, !nameTextField.text!.isEmpty else {
            showAlert(emptyType: "식품명")
            return  }
        guard let dataPurchaseDate = self.purchasDateTextField.text, !purchasDateTextField.text!.isEmpty else {
            showAlert(emptyType: "구매일")
            return}
        guard let dataQuantity = self.quantityTextField.text, !quantityTextField.text!.isEmpty else {
                showAlert(emptyType: "수량")
            return}
//        guard let dataType = self.quantityTextField.text, !quantityTextField.text!.isEmpty else {
//                return "기타"}
        guard let dataMemo = self.quantityTextField.text , !quantityTextField.text!.isEmpty else {
            return}
        
        let data = Shopping()
        data.name = dataName
        data.purchaseDate = formatter.date(from: dataPurchaseDate)!
        data.quantity = Double(dataQuantity)!
        data.memo = dataMemo
        data.type = "기타"
        
        let realm = try! Realm()

        try! realm.write() {
            realm.add(data)
        }
                
        navigationController?.popViewController(animated: true)
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
