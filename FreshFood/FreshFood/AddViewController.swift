import UIKit
import RealmSwift



protocol BarcodeDelegate
{
    
    
    func getBarcodeData(ingredientName: String, ingredientDate: String)
}

class Data:Object{
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
    
}



@objcMembers
class AddViewController: UIViewController, BarcodeDelegate{
    // Camera view
    
    var ingredientName : String = ""

    var limitDate : String = ""
    
    var isShowingAlert = false
    
    var formedLimitDate : Date = Date()
    
    var formatter = DateFormatter()
    
    var pickerView: UIView = UIView()
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var toBarcodeButton: UIButton!
    
    @IBOutlet weak var ingredientNameText: UITextField!
    
    @IBOutlet weak var limitDateText: UITextField!
    
    @IBOutlet weak var fridgeTypeText: UITextField!
    
    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
             
            // let tap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPicker")
             
            view.addGestureRecognizer(tap)
         //view.addGestureRecognizer(tap2)
             
             ingredientNameText.text = ingredientName
        
             limitDateText.text = limitDate
             
             
             limitDateText.inputView = .none
             
             
         
             
             //limitDatePicker.showsel
             
            // limitDatePicker.addTarget(self, action: #selector(handler), for: UIControl.Event.valueChanged)
             
             
    
        
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
     
     
     @objc func dismissKeyboard() {
         //Causes the view (or one of its embedded text fields) to resign the first responder status.
         view.endEditing(true)
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
    
    func getBarcodeData(ingredientName: String, ingredientDate: String) {
            self.ingredientName = ingredientName
            self.limitDate = ingredientDate
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
            let data = Data(name: dataName , limitdate: dataLimitDate, fridgetype: dataFridgeType)
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
