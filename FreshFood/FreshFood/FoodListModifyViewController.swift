//
//  FoodListModifyViewController.swift
//  FreshFood
//
//  Created by GI BEOM HONG on 2020/06/23.
//  Copyright © 2020 정지훈. All rights reserved.
//

import UIKit
import RealmSwift


class FoodListModifyViewController: UIViewController {
    
    let realm = try! Realm()
    
    var pickerView: UIView = UIView()
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    var fridgePicker: UIPickerView!
    
    var isShowingAlert = false
    
    var foodLocation: [String] = ["냉장고", "냉동고", "김치냉장고", "기타"]
    
    var fridgeString: String = "냉장고" //picker는 didselectrow, 즉 최소 한번이상 움직여야 값 변화가 감지 되므로, 아무것도 하지 않고 바로 DONE을 누를 경우 기본값을 부여
    
    var toolBar = UIToolbar()
    

    
    

    @IBOutlet weak var backToDetailButton: UIButton!
    
    @IBOutlet weak var foodNameModificationText: UITextField!
    
    
    @IBOutlet weak var limitDateModificationText: UITextField!
    
    @IBOutlet weak var fridgeTypeModificationText: UITextField!
    
    @IBOutlet weak var quantityModificationText: UITextField!
    
    
    @IBOutlet weak var foodTypeModificationText: UITextField!
    
    
    @IBOutlet weak var memoModificationText: UITextField!
    
    

    @IBOutlet weak var modifyButton: UIButton!
    
    
    var modifyData:Food?
    
    var formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
          
         view.addGestureRecognizer(tap)
        
        
        
        foodNameModificationText.text = modifyData?.name
        print("text: \(formatter.string(from : modifyData!.limitDate))")
        limitDateModificationText.text = formatter.string(from : modifyData!.limitDate)
        fridgeTypeModificationText.text = modifyData?.location
        quantityModificationText.text = "\(modifyData?.quantity)"
        foodTypeModificationText.text = modifyData?.type
        memoModificationText.text = modifyData?.memo
        
        
        fridgePicker = UIPickerView()
                   fridgePicker.delegate = self
                   fridgePicker.dataSource = self
               
               
                   toolBar = UIToolbar()
                   toolBar.barStyle = UIBarStyle.default
                   toolBar.isTranslucent = true
                   toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
                   toolBar.sizeToFit()

                   let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
               let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                   let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))

                   toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
                   toolBar.isUserInteractionEnabled = true
               
                    
                    limitDateModificationText.inputView = .none
                   fridgeTypeModificationText.inputView = fridgePicker
               fridgeTypeModificationText.inputAccessoryView = toolBar
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func donePicker(){
        fridgeTypeModificationText?.text = fridgeString
        fridgePicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        
    }
    
    @objc func cancelPicker(){
        fridgeTypeModificationText?.text = ""
        fridgeString = "냉장고"
        fridgePicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func linkDatePicker(){
             modifyButton.isHidden = true
             pickerView = UIView(frame: CGRect(x: 0,y: self.view.frame.size.height-240, width: self.view.frame.width, height: 240))
             datePicker = UIDatePicker(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200))
             datePicker.isHidden = false
             //inputView.backgroundColor = .black
             datePicker.datePickerMode = .date
             datePicker.reloadInputViews()
            pickerView.backgroundColor = .systemBackground
             datePicker.backgroundColor = .systemGray
             pickerView.addSubview(datePicker)
             
             datePicker.addTarget(self, action: #selector(handler), for: UIControl.Event.valueChanged)
             let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width) - (100), y: 0, width: 100, height: 40))
             doneButton.setTitle("입력", for: .normal)
             doneButton.setTitleColor(.systemBlue, for: .normal)
             pickerView.addSubview(doneButton)
             let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
             cancelButton.setTitle("취소", for: .normal)
             cancelButton.setTitleColor(.systemBlue, for: .normal)
             pickerView.addSubview(cancelButton)
             self.view.addSubview(pickerView)
             doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
             cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
       }
       
       @objc func handler(sender: UIDatePicker) {
           var timeFormatter = DateFormatter()
           timeFormatter.dateFormat = "yyyy.MM.dd"
           
           var strDate = timeFormatter.string(from : sender.date)
           limitDateModificationText.text = strDate
           // do what you want to do with the string.
       }
       
    
       @objc func handleDoneButton(sender: UIButton) {
           //pickerView.isHidden = true
           var timeFormatter = DateFormatter()
           timeFormatter.dateFormat = "yyyy.MM.dd"
           
           var strDate = timeFormatter.string(from : datePicker.date)
           limitDateModificationText?.text = strDate
           datePicker.removeFromSuperview()
           pickerView.removeFromSuperview()
           modifyButton.isHidden = false
           limitDateModificationText.isEnabled = true
           
       }
       
       @objc func handleCancelButton(sender: UIButton) {
           //pickerView.isHidden = true
           self.pickerView.removeFromSuperview()

    
           modifyButton.isHidden = false
           limitDateModificationText?.text = ""
           limitDateModificationText.isEnabled = true
       }
       
    
    
    @IBAction func limitDateModificationTextTouched(_ sender: Any) {
        linkDatePicker()
        limitDateModificationText.isEnabled = false
    }
    
    
    
    @IBAction func modifyButtonClicked(_ sender: Any) {
        
        modify()

 
    }
    
    func modify(){
           if foodNameModificationText.text!.isEmpty{
                showAlert(emptyType: "식품명")
            }else{
                modifyData?.name = foodNameModificationText.text!
            }
            
            if limitDateModificationText.text!.isEmpty{
                showAlert(emptyType: "유통기한")
            }else{
                let isoDate = limitDateModificationText.text!

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                let date = dateFormatter.date(from:isoDate)!
                
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                
                let finalDate = calendar.date(from:components)
                
                modifyData?.limitDate = finalDate!
            }
            
            if fridgeTypeModificationText.text!.isEmpty{
                showAlert(emptyType: "냉장고 타입")
            }else{
                modifyData?.name = fridgeTypeModificationText.text!
            }
            
            if quantityModificationText.text!.isEmpty{
                showAlert(emptyType: "수량")
            }else{
                modifyData?.name = quantityModificationText.text!
            }

            modifyData?.type = foodTypeModificationText.text!
            modifyData?.memo = memoModificationText.text!
            
            let broughtData = realm.objects(Food.self).filter("id = %@", modifyData?.id)

            let realm = try! Realm()
            if let data = broughtData.first {
                try! realm.write {
                    data.name = modifyData?.name as! String
                    data.limitDate = modifyData?.limitDate as! Date
                    data.location = modifyData?.location as! String
                    data.quantity = modifyData?.quantity as! Double
                    data.type = modifyData?.type as! String
                    data.memo = modifyData?.memo as! String
                    
                }
            
        }
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
    // MARK: - Navigation

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "ToDetail"{
                 if let detailListController = segue.destination as? ListModalViewController{
                    detailListController.food = modifyData
                     self.present(detailListController, animated: true, completion: nil)
            }
    

        }
    }
}



extension FoodListModifyViewController : UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

}

extension FoodListModifyViewController : UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return foodLocation.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return foodLocation[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         fridgeString = foodLocation[row] as String
        }
    

}
