import UIKit
import RealmSwift



protocol BarcodeDelegate
{
    
    
    func getBarcodeData(ingredientName: String, ingredientDate: String, ingredientType: String)
}

/*class Data:Object{
    dynamic var name: String? = nil
    dynamic var limitdate: String? = nil
    dynamic var fridgetype: String? = nil
    
    init(name:String, limitdate:String, fridgetype:String) {
        self.name = name
        self.limitdate = limitdate
        self.fridgetype = fridgetype
    }
    
    override required init() {
        super.init()
    }
    
   /* override static func primaryKey() -> String? {
       return "name"
    }*/
    
}*/



@objcMembers
class AddViewController: UIViewController, BarcodeDelegate{

    
    // Camera view
    
    var ingredientName : String = ""

    var limitDate : String = ""
    
    var foodType : String = ""
    
    var quantity : Double = 0.0
    
    var isShowingAlert = false
    
    var formedLimitDate : Date = Date()
    
    var formatter = DateFormatter()
    
    var pickerView: UIView = UIView()
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    var fridgePicker: UIPickerView!
    
    var foodLocation: [String] = ["냉장고", "냉동고", "김치냉장고", "기타"]
    
    var fridgeString: String = ""
    
    var toolBar = UIToolbar()
    
    @IBOutlet weak var toBarcodeButton: UIButton!
    
    @IBOutlet weak var ingredientNameText: UITextField!
    
    @IBOutlet weak var limitDateText: UITextField!
    
    @IBOutlet weak var fridgeTypeText: UITextField!
    
    @IBOutlet weak var quantityText: UITextField!
    
    @IBOutlet weak var foodTypeText: UITextField!
    
    
    @IBOutlet weak var memoText: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
             
            // let tap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPicker")
             
            view.addGestureRecognizer(tap)
         //view.addGestureRecognizer(tap2)
             
             ingredientNameText.text = ingredientName
        
             limitDateText.text = limitDate
        
            foodTypeText.text = foodType
             
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
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))

            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
        
             
             limitDateText.inputView = .none
            fridgeTypeText.inputView = fridgePicker
        fridgeTypeText.inputAccessoryView = toolBar
             
             
         
             
             //limitDatePicker.showsel
             
            // limitDatePicker.addTarget(self, action: #selector(handler), for: UIControl.Event.valueChanged)
             
             
    
        
    }
    
    @objc func donePicker(){
        fridgeTypeText?.text = fridgeString
        fridgePicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        
    }
    
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
     
     @IBAction func limitDateTextClicked(_ sender: Any) {
         linkDatePicker()
         limitDateText.isEnabled = false
     }
     
 
    
     func linkDatePicker(){
         addButton.isHidden = true
           pickerView = UIView(frame: CGRect(x: 0,y: self.view.frame.size.height-240, width: self.view.frame.width, height: 240))
           datePicker = UIDatePicker(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200))
         //  datePicker.isHidden = false
           //inputView.backgroundColor = .black
           datePicker.datePickerMode = .date
           datePicker.reloadInputViews()
           //datePicker.backgroundColor = .black
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
         limitDateText.text = strDate
         // do what you want to do with the string.
     }
     
     
     
     
     override func viewWillAppear(_ animated: Bool) {
         ingredientNameText.text = ingredientName
         print(ingredientName)
         //limitDateText.text = limitDate
        /* var toAddDate = String(limitDate.trimmingCharacters(in: .whitespacesAndNewlines))
         toAddDate.replacingOccurrences(of: "일", with: "")
         let currentDate = limitDatePicker.date
         var dateComponent = DateComponents()
         dateComponent.day = Int(toAddDate)
         let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? currentDate
         limitDatePicker.setDate(futureDate, animated: true)
         limitDateText.text = "\(limitDatePicker.date)"*/
         
     }
    @IBAction func presentBarcodeScanner(_ sender: Any) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "바코드 인식기"
        present(viewController, animated: true)
      // present(viewController, animated: true, completion: {self.makeRectangle(view: viewController)})
    }
    
/*    func makeRectangle(view:BarcodeViewController){
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        view.cameraView.addSubview(qrCodeFrameView)
        view.cameraView.bringSubviewToFront(qrCodeFrameView)
        view.cameraView.updateOrientation()
        
    }*/
    
    
   /* func makeRectangle(view:BarcodeViewController)->Void{
        let rectangle: UIBezierPath = UIBezierPath(rect: CGRect(x: UIScreen.main.bounds.size.width/4, y: UIScreen.main.bounds.size.height/2 - 30, width: UIScreen.main.bounds.size.width/2, height: 90))
        UIColor.clear.setFill()
        rectangle.fill()
        UIColor.red.setStroke()
        rectangle.lineWidth = 2.5
        rectangle.stroke()

        let boundingLayer: CAShapeLayer = CAShapeLayer.init()
        boundingLayer.path = rectangle.cgPath
        boundingLayer.fillColor = UIColor.clear.cgColor
        boundingLayer.strokeColor = UIColor.red.cgColor
        //capturePreviewLayer.addSublayer(boundingLayer)
        view.cameraView.layer.addSublayer(boundingLayer)
        
        // Set initial camera orientation
        view.cameraView.updateOrientation()
    }*/
    
    private func makeBarcodeScannerViewController() -> BarcodeViewController {
      let viewController = BarcodeViewController()
        viewController.delegate=self

      return viewController
    }
    
    func getBarcodeData(ingredientName: String, ingredientDate: String, ingredientType: String) {
            self.ingredientName = ingredientName
            self.limitDate = ingredientDate
            self.foodType = ingredientType

        
            print("test:\(self.foodType)")
            print(self.ingredientName)
            var parseLimitDateIndex =  self.limitDate.index(of: "일") ?? self.limitDate.index(of: "월")
            if(limitDate.count == 2){
                let start = self.limitDate.index(parseLimitDateIndex! , offsetBy: -1)
                let end = self.limitDate.index(parseLimitDateIndex!, offsetBy: 1)
                let range = start..<end
                let tempLimitDate = self.limitDate[range]
                self.limitDate = String(tempLimitDate)
            }else if(limitDate.count == 3){
                let start = self.limitDate.index(parseLimitDateIndex! , offsetBy: -2)
                let end = self.limitDate.index(parseLimitDateIndex!, offsetBy: 1)
                let range = start..<end
                let tempLimitDate = self.limitDate[range]
                self.limitDate = String(tempLimitDate)
                
            }else{
            let start = self.limitDate.index(parseLimitDateIndex! , offsetBy: -3)
            let end = self.limitDate.index(parseLimitDateIndex!, offsetBy: 1)
            let range = start..<end
            let tempLimitDate = self.limitDate[range]
                self.limitDate = String(tempLimitDate)
            }
            
            
            self.ingredientNameText?.text = self.ingredientName
            print("test2:\(self.foodType)")
            self.foodTypeText?.text = (self.foodType)
        
            var toAddDate = String(limitDate.trimmingCharacters(in: .whitespacesAndNewlines))
            print(toAddDate)
            if(toAddDate.hasSuffix("일")){
            print(toAddDate)
            toAddDate.removeLast()
            let dayOffset:Int = Int(toAddDate)!
            print(dayOffset)
                
            formatter.dateFormat = "yyyy.MM.dd"
            let calendar = Calendar.current
            let day = DateComponents(day:dayOffset)
            print(day)
            if let futureDate = calendar.date(byAdding: day, to: Date()){
            print(futureDate)
            self.limitDate = formatter.string(from: futureDate)
            self.formedLimitDate = futureDate
            limitDateText?.text = "\(limitDate)"
            }
                
            }else if(toAddDate.hasSuffix("개월")){
                toAddDate.removeLast()
                toAddDate.removeLast()
                
                let monthOffset:Int = Int(toAddDate)!
                print(monthOffset)
                    
                formatter.dateFormat = "yyyy.MM.dd"
                let calendar = Calendar.current
                let month = DateComponents(month:monthOffset)
                print(month)
                if let futureDate = calendar.date(byAdding: month, to: Date()){
                print(futureDate)
                self.limitDate = formatter.string(from: futureDate)
                self.formedLimitDate = futureDate
                limitDateText?.text = "\(limitDate)"
                
                }
                
            }
        
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
        

        
     /*   @IBAction func limitDateButtonClicked(_ sender: Any) {
            addButton.isHidden = true
            pickerView = UIView(frame: CGRect(x: 0,y: self.view.frame.size.height-240, width: self.view.frame.width, height: 240))
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200))
            datePicker.isHidden = false
            //inputView.backgroundColor = .black
            datePicker.datePickerMode = .date
            datePicker.reloadInputViews()
            //datePicker.backgroundColor = .black
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
           // textField.inputView = inputView
            
        }*/
        
        @objc func handleDoneButton(sender: UIButton) {
            //pickerView.isHidden = true
            var timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy.MM.dd"
            
            var strDate = timeFormatter.string(from : datePicker.date)
            limitDateText?.text = strDate
            datePicker.removeFromSuperview()
            pickerView.removeFromSuperview()
            addButton.isHidden = false
            limitDateText.isEnabled = true
            
        }
        
        @objc func handleCancelButton(sender: UIButton) {
            //pickerView.isHidden = true
            self.pickerView.removeFromSuperview()

     
            addButton.isHidden = false
            limitDateText?.text = ""
            limitDateText.isEnabled = true
        }
        
        
        @IBAction func addData(_ sender: Any) {
            guard let dataName = self.ingredientNameText.text, !ingredientNameText.text!.isEmpty else {
                showAlert(emptyType: "식품명")
                return  }
            guard let dataLimitDate = self.limitDateText.text, !limitDateText.text!.isEmpty else {
                showAlert(emptyType: "유통기한")
                return}
            guard let dataFridgeType = self.fridgeTypeText.text,
                !fridgeTypeText.text!.isEmpty else {
                    showAlert(emptyType: "냉장고")
                    return}
            guard let dataQuantity = self.quantityText.text,
                !fridgeTypeText.text!.isEmpty else {
                    showAlert(emptyType: "갯수")
                    return}
            let changedQuantity = NumberFormatter().number(from: dataQuantity)?.doubleValue
            
            
            let data = Food(name: dataName, limitdate: formedLimitDate, fridgetype: fridgeString, quantity: changedQuantity!, type: foodType, memo: memoText.text!)
            
            let realm = try! Realm()
            try! realm.write() {
                var addedData = realm.add(data)
                // Reading from or modifying a `RealmOptional` is done via the `value` property
                //person.age.value = 28
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
        
    }

extension AddViewController : UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

}

extension AddViewController : UIPickerViewDataSource{
    
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
