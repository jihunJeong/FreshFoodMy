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
    @IBOutlet weak var typeDataTextField: UITextField!
    
    var isShowingAlert = false
    var datePicker: UIDatePicker = UIDatePicker()
    var pickerView: UIView = UIView()
    let formatter = DateFormatter()


    weak var delegate :ShoppingListAddViewControllerDelegator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy.MM.dd"
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        purchasDateTextField.text = formatter.string(from: Date())
        typeDataTextField.text = "기타"


        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        if typeDataTextField.text == nil
        {
            typeDataTextField.text = "기타"
        }

        view.endEditing(true)
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.nameTextField.resignFirstResponder()
//        self.quantityTextField.resignFirstResponder()
//        self.memoDataTextField.resignFirstResponder()
//    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        guard let dataName = self.nameTextField.text, !nameTextField.text!.isEmpty else {
            showAlert(emptyType: "식품명")
            return  }
        guard let dataPurchaseDate = self.purchasDateTextField.text, !quantityTextField.text!.isEmpty else {
                   return}
        guard let dataQuantity = self.quantityTextField.text, !quantityTextField.text!.isEmpty else {
                showAlert(emptyType: "수량")
            return}
        guard let dataType = self.quantityTextField.text , !quantityTextField.text!.isEmpty else {
                   return}
        guard let dataMemo = self.quantityTextField.text , !quantityTextField.text!.isEmpty else {
            return}
        
        let data = Shopping()
        data.name = dataName
        data.purchaseDate = formatter.date(from: dataPurchaseDate)!
        data.quantity = Double(dataQuantity)!
        data.memo = dataMemo
        data.type = dataType
        
        let realm = try! Realm()

        try! realm.write() {
            realm.add(data,update: .all)
        }
        
        self.delegate?.create()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func purchaseDateTextFieldPressed(_ sender: Any) {
        linkDatePicker()
        purchasDateTextField.isEnabled = false
    }
    
    
    
    func linkDatePicker(){
        pickerView = UIView(frame: CGRect(x: 0,y: self.view.frame.size.height-240, width: self.view.frame.width, height: 240))
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
        
        
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy.MM.dd"
        
        var strDate = timeFormatter.string(from : sender.date)
        purchasDateTextField.text = strDate
        // do what you want to do with the string.
    }
    
    @objc func handleDoneButton(sender: UIButton) {
        
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy.MM.dd"
           
        var strDate = timeFormatter.string(from : datePicker.date)
        purchasDateTextField?.text = strDate
        datePicker.removeFromSuperview()
        pickerView.removeFromSuperview()
        purchasDateTextField.isEnabled = true
           
       }

       @objc func handleCancelButton(sender: UIButton) {
           //pickerView.isHidden = true
        self.pickerView.removeFromSuperview()

        purchasDateTextField?.text = formatter.string(from: Date())
        purchasDateTextField.isEnabled = true
    }
    
    
    @IBAction func dataTypeTextFieldPressed(_ sender: UITextField) {
        sender.text = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)->Bool
    {
        print("-----------****")
        guard let textFieldString = textField.text, let range = Range(range, in: textFieldString)else{
            return false
        }
        let newString = textFieldString.replacingCharacters(in: range, with: string)
        if newString.isEmpty{
            textField.text == "기타"
            return false
        }else if textField.text == "0"{
            textField.text = string
            return false
        }
        return true
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

protocol ShoppingListAddViewControllerDelegator: AnyObject{
    func create()
}
