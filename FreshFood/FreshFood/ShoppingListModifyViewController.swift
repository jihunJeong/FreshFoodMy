//
//  ShoppingListModifyViewController.swift
//  FreshFood
//
//  Created by 이수정 on 2020/06/24.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListModifyViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var purchasDateTextField: UITextField!
    @IBOutlet weak var typeDataTextField: UITextField!
    @IBOutlet weak var memoDataTextField: UITextField!

    
    var name:String?
    var quantity:String?
    var purchaseDate:String?
    var type:String?
    var memo:String?
    let realm = try! Realm()
    var datePicker: UIDatePicker = UIDatePicker()
    var pickerView: UIView = UIView()
    var isShowingAlert = false
    let timeFormatter:DateFormatter = DateFormatter()

    weak var delegate : ShoppingListModifyViewControllerDelegator?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        quantityTextField.text = quantity
        purchasDateTextField.text = purchaseDate
        typeDataTextField.text = type
        memoDataTextField.text = memo

        // Do any additional setup after loading the view.
    }
    
    @IBAction func modifyButtonPressed(_ sender: Any) {
        guard let dataName = self.nameTextField.text, !nameTextField.text!.isEmpty else {
            showAlert(emptyType: "식품명")
            return  }
        guard let dataPurchaseDate = self.purchasDateTextField.text, !purchasDateTextField.text!.isEmpty else {
            showAlert(emptyType: "구매일")
                   return}
        guard let dataQuantity = self.quantityTextField.text, !quantityTextField.text!.isEmpty else {
                showAlert(emptyType: "수량")
            return}
        
        var dataType = self.typeDataTextField.text
        var dataMemo = self.memoDataTextField.text
        
        if dataType == nil
        {
            dataType = "기타"
        }
        if dataMemo == nil
        {
            dataMemo = ""
        }
        
        
        let formatter:DateFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy.MM.dd"
        let tempObject = realm.object(ofType: Shopping.self, forPrimaryKey: name)
        do{
            try self.realm.write{
                tempObject?.quantity = Double(dataQuantity)!
                tempObject?.purchaseDate = timeFormatter.date(from: dataPurchaseDate)!
                tempObject?.type = dataType!
                tempObject?.memo = dataMemo!
                
            }
        } catch{ print("\(error)") }
        
        self.delegate?.reloadData(name: dataName, quantity: dataQuantity, purchaseDate: dataPurchaseDate, type: dataType!, memo: dataMemo!)
        self.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    @IBAction func purchaseDateTextFieldPressed(_ sender: Any) {
        linkDatePicker()
        purchasDateTextField.isEnabled = false
    }
    
    
    func linkDatePicker(){
        pickerView = UIView(frame: CGRect(x: 0,y: self.view.frame.size.height, width: self.view.frame.width, height: 240))
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.reloadInputViews()
        pickerView.addSubview(datePicker)
          
        datePicker.addTarget(self, action: #selector(handler), for: UIControl.Event.valueChanged)
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40))
        doneButton.setTitle("입력", for: .normal)
        doneButton.setTitleColor(.green, for: .normal)
        pickerView.addSubview(doneButton)
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.orange, for: .normal)
        cancelButton.backgroundColor = UIColor.white
        doneButton.backgroundColor = UIColor.white
        pickerView.addSubview(cancelButton)
        self.view.addSubview(pickerView)
        doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    }
    
    @objc func handler(sender: UIDatePicker) {
        
        
        timeFormatter.dateFormat = "yyyy.MM.dd"
        
        let strDate = timeFormatter.string(from : sender.date)
        purchasDateTextField.text = strDate
        // do what you want to do with the string.
    }
    
    @objc func handleDoneButton(sender: UIButton) {
        
        timeFormatter.dateFormat = "yyyy.MM.dd"
           
        let strDate = timeFormatter.string(from : datePicker.date)
        purchasDateTextField?.text = strDate
        datePicker.removeFromSuperview()
        pickerView.removeFromSuperview()
        purchasDateTextField.isEnabled = true
           
       }

       @objc func handleCancelButton(sender: UIButton) {
           //pickerView.isHidden = true
        self.pickerView.removeFromSuperview()
        purchasDateTextField.isEnabled = true
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
protocol ShoppingListModifyViewControllerDelegator :AnyObject {
    func reloadData(name:String, quantity:String, purchaseDate:String, type:String, memo:String)
}
