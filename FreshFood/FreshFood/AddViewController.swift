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
class ViewController: UIViewController, BarcodeDelegate{
    // Camera view
    
    var ingredientName : String = ""

    var limitDate : String = ""
    
    var isShowingAlert = false
    
    @IBOutlet weak var toBarcodeButton: UIButton!
    
    @IBOutlet weak var ingredientNameText: UITextField!
    
    @IBOutlet weak var limitDateText: UITextField!
    
    @IBOutlet weak var fridgeTypeText: UITextField!
    
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        ingredientNameText.text = ingredientName
   
        limitDateText.text = limitDate
    
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientNameText.text = ingredientName
        print(ingredientName)
        limitDateText.text = limitDate
    }
    @IBAction func presentBarcodeScanner(_ sender: Any) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "바코드 인식기"
        present(viewController, animated: true, completion: {self.makeRectangle(view: viewController)})
    }
    
    func makeRectangle(view:BarcodeViewController)->Void{
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
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeViewController {
      let viewController = BarcodeViewController()
        viewController.delegate=self
      return viewController
    }
    
    func getBarcodeData(ingredientName: String, ingredientDate: String) {
        self.ingredientName = ingredientName
        self.limitDate = ingredientDate
        self.ingredientNameText.text = ingredientName
        self.limitDateText.text = limitDate
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
