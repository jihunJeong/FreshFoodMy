import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseInstallations

var databaseAccessKeys : [String] = ["-M8KuWSvftXzRy9Ivipc", "-M8KuUE3PpbanLl-Q6yj",
                                     "-M8KuS9a3jVke6_6Etyb", "-M8KuPcmMqg3FGo2OfP0", "-M8Ks5S8sBftQUM_B4eW","-M8KqgkVRp3y1L1UHd4o", "-M8K3gYx3O1uvXmvq2uZ", "-MAG9evsmMqxEbw_xWuH","-MAGA-TVHcOBcBgZ8voh","-MAGAJn6GK-NZbt9LHmv"]

/*var pogDayCountParser : [String] = ["3일", "4일", "5일","6일","7일","8일","9일","10일","11일","12일","13일","14일","15일","16일"
,"17일","18일","19일","20일","21일","22일","23일","24일","25일","26일","27일","28일","29일","30일","45일","60일","1개월",
"2개월","3개월","6개월"]*/


@objcMembers
class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // Camera view
    var cameraView: CameraView!
    private let activityIndicator = UIActivityIndicatorView()
    
    var delegate:BarcodeDelegate?
    // AV capture session and dispatch queue
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "Session Queue")

//    var delegate:BarcodeDelegate?
    var isShowingAlert = false

    public var ref:DatabaseReference!
    public var recognizedBarcode:String=""
    var ingredientName:String = ""
    var ingredientDate:String = ""
    var barcodeData:String = ""

    
    var captureCount = 0
    var completionCount = 0
    var barcodeFrameView:UIView?
    var alertController:UIAlertController!
    let imgViewTitle = UIImageView()
    var progressBar = UIProgressView()
    
    
    
    override func loadView() {
        cameraView = CameraView()

        view = cameraView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        title = "바코드 스캐너"
        
        session.beginConfiguration()

        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)

                metadataOutput.metadataObjectTypes = [
                    .code128,
                    .code39,
                    .code93,
                    .ean13,
                    .ean8,
                    .qr,
                    .upce
                ]

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
        }

        session.commitConfiguration()

        cameraView.layer.session = session
        cameraView.layer.videoGravity = .resizeAspectFill
        
        
        barcodeFrameView = UIView()
         
        if let barcodeFrameView = barcodeFrameView {
            barcodeFrameView.layer.borderColor = UIColor.green.cgColor
            barcodeFrameView.layer.borderWidth = 2
            barcodeFrameView.frame = CGRect(x: UIScreen.main.bounds.size.width/4, y: UIScreen.main.bounds.size.height/2 - 30, width: UIScreen.main.bounds.size.width/2, height: 90)
            view.addSubview(barcodeFrameView)
            view.bringSubviewToFront(barcodeFrameView)
        }


    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Start AV capture session
        sessionQueue.async {
            self.session.startRunning()
        }
        
            //makeRectangle()
        
        
        
    }
    
  /*  func makeRectangle(){
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
        cameraView.layer.addSublayer(boundingLayer)
        
        // Set initial camera orientation
        cameraView.updateOrientation()
    }*/
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop AV capture session
        sessionQueue.async {
            self.session.stopRunning()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Update camera orientation
        cameraView.updateOrientation()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Display barcode value
        
        //prevent Race Condition
        if(captureCount == 0){
            captureCount += 1
        }else{
            return
        }
        
        
        
        if !isShowingAlert,
            metadataObjects.count > 0,
            metadataObjects.first is AVMetadataMachineReadableCodeObject,
            let scan = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if scan.type == AVMetadataObject.ObjectType.ean13 {
                let barCodeObject = cameraView.layer.transformedMetadataObject(for: scan)
                barcodeFrameView?.frame = barCodeObject!.bounds
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            }
            DispatchQueue.main.async {
                //self.session.stopRunning()
                self.getLoadingScreen()
                self.barcodeData = scan.stringValue!
                self.getIngredientData(code: self.barcodeData, completionBlock:{self.presentAlert()})
            }
            sessionQueue.sync{
                self.session.startRunning()
            }
            //getIngredientData(code: scan.stringValue!)
           //sleep(5)

  
                
         /*   let alertController = UIAlertController(title: "Barcode Scanned", message: "바코드 : \(scan.stringValue) \n 제품명 : \(self.ingredientName) \n 유통기한 : \(self.ingredientDate)", preferredStyle: .alert)

            print("isit\(self.ingredientDate)")
            isShowingAlert = true

            alertController.addAction(UIAlertAction(title: "OK", style: .default) { action in
                self.isShowingAlert = false
                self.delegate?.getBarcodeData(ingredientName: "\(self.ingredientName)", ingredientDate: "\(self.ingredientDate)")
                self.dismiss(animated: true, completion: nil)
                //self.transitioningDelegate.
                
            })

            present(alertController, animated: true)*/
    }
}
    func getLoadingScreen(){
        alertController = UIAlertController(title: "FreshFood", message: "식품 데이터를 조회중이에요!", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: nil)

        let imgTitle = UIImage(named:"loadingcharacter.png")
        imgViewTitle.image = imgTitle
        imgViewTitle.contentMode = .scaleAspectFill

        progressBar.setProgress(0.0, animated: true)
        progressBar.frame = CGRect(x: 10, y: 330, width: 230, height: 0)
        alertController.view.addSubview(progressBar)
        
        var progress: Float = 0.0
        // Do the time critical stuff asynchronously
        DispatchQueue.global(qos: .background).async {
            repeat {
                progress += 0.1
                Thread.sleep(forTimeInterval: 0.25)
                print (progress)
                DispatchQueue.main.async(flags: .barrier) {
                    self.progressBar.setProgress(progress, animated: true)
                }
            } while progress < 1.0
            DispatchQueue.main.async {
            //    self.imgViewTitle.isHidden = true
             //   self.progressBar.isHidden = true
            }
        }
        
        alertController.view.addSubview(imgViewTitle)
        let height = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 360)
        let width = NSLayoutConstraint(item: alertController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        alertController.view.addConstraint(height)
        alertController.view.addConstraint(width)
        imgViewTitle.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.addConstraint(NSLayoutConstraint(item: imgViewTitle, attribute: .centerX, relatedBy: .equal, toItem: alertController.view, attribute: .centerX, multiplier: 1, constant: 0))
        alertController.view.addConstraint(NSLayoutConstraint(item: imgViewTitle, attribute: .centerY, relatedBy: .equal, toItem: alertController.view, attribute: .centerY, multiplier: 1, constant: 0))
        alertController.view.addConstraint(NSLayoutConstraint(item: imgViewTitle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 220))
        alertController.view.addConstraint(NSLayoutConstraint(item: imgViewTitle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 90))
       // alertController.addAction(action)

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func getIngredientData(code:String, completionBlock : @escaping (() -> Void)){
        //let completionBlock : (() -> Void)
        //var parsedPogDayCount : String = ""
        Auth.auth().signInAnonymously(completion: nil)
        recognizedBarcode = code

    
        for i in databaseAccessKeys{
            ref.child(i).child("C005").child("row").runTransactionBlock( { (currentData : MutableData) -> TransactionResult in
            if let array = currentData.value as? [[String:Any]]{
                for aValue in array {
                    if self.recognizedBarcode == aValue["BAR_CD"] as? String{
                        print(aValue["PRDLST_NM"])
                        self.ingredientName = "\(aValue["PRDLST_NM"])"
                        print(aValue["POG_DAYCNT"])
                        self.ingredientDate = "\(aValue["POG_DAYCNT"])"
                        print("data test:\(self.ingredientDate)")
                        /*parsedPogDayCount = (aValue["POG_DAYCNT"] as? String)!
                        for i in pogDayCountParser{
                            if (parsedPogDayCount.contains(i)){
                                    print(i)
                                self.ingredientDate = "\(i)"
                            }else{
                                print("cannot parse")
                            }
                        }*/
                         break
                    }
                }
            }
           // if currentData.value(forKey: "0") as?String == self.recognizedBarcode{
            //}
                
            return TransactionResult.success(withValue: currentData)
            }, andCompletionBlock: {(error, completion, snap) in
              //  print(completion)
               // print(snap)
            if !completion {
                print("The value wasn't able to Update")
                }else if completion{
                self.completionCount += 1
                if self.completionCount == databaseAccessKeys.count{
                completionBlock()
                self.imgViewTitle.isHidden = true
                self.progressBar.isHidden = true
                }
                
            }})
        }
    }
    
    func presentAlert()->Void{
        
       // imgViewTitle.isHidden=true
        let height = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        alertController.view.addConstraint(height)
        
        self.ingredientName = self.ingredientName.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
        self.ingredientDate = self.ingredientDate.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
        
        alertController.title = "상품정보"
        alertController.message = "바코드 : \(barcodeData) \n 제품명 : \(self.ingredientName) \n 유통기한 : \(self.ingredientDate)"
        //UIAlertController(title: "상품정보", message: "바코드 : \(barcodeData) \n 제품명 : \(self.ingredientName) \n 유통기한 : \(self.ingredientDate)", preferredStyle: .alert)

        print("isit\(self.ingredientDate)")
        isShowingAlert = true

        alertController.addAction(UIAlertAction(title: "OK", style: .default) { action in
            self.isShowingAlert = false
            self.delegate?.getBarcodeData(ingredientName: "\(self.ingredientName)", ingredientDate: "\(self.ingredientDate)", ingredientType: "")
            self.dismiss(animated: true, completion: nil)
            //self.transitioningDelegate.
            
        })

       // present(alertController, animated: true)
    }
    
}

class CameraView: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }

    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }

    func updateOrientation() {
        let videoOrientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait

        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown

        case .landscapeLeft:
            videoOrientation = .landscapeRight

        case .landscapeRight:
            videoOrientation = .landscapeLeft

        default:
            videoOrientation = .portrait
        }

        layer.connection?.videoOrientation = videoOrientation
    }
    
}

