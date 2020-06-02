import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseInstallations

var databaseAccessKeys : [String] = ["-M8KuWSvftXzRy9Ivipc", "-M8KuUE3PpbanLl-Q6yj",
"-M8KuS9a3jVke6_6Etyb", "-M8KuPcmMqg3FGo2OfP0", "-M8Ks5S8sBftQUM_B4eW","-M8KqgkVRp3y1L1UHd4o", "-M8K3gYx3O1uvXmvq2uZ"]

var pogDayCountParser : [String] = ["3일", "4일", "5일","6일","7일","8일","9일","10일","11일","12일","13일","14일","15일","16일"
,"17일","18일","19일","20일","21일","22일","23일","24일","25일","26일","27일","28일","29일","30일","45일","60일","1개월",
"2개월","3개월","6개월"]


@objcMembers
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // Camera view
    var cameraView: CameraView!

    // AV capture session and dispatch queue
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "Session Queue")

    var isShowingAlert = false

    public var ref:DatabaseReference!
    public var recognizedBarcode:String=""
    var ingredientName:String = ""
    var ingredientDate:String = ""
    
    
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Start AV capture session
        sessionQueue.async {
            self.session.startRunning()
        }
    }

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
        
        
        
        if !isShowingAlert,
            metadataObjects.count > 0,
            metadataObjects.first is AVMetadataMachineReadableCodeObject,
            let scan = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            getIngredientData(code: scan.stringValue!)
            sleep(5)
            let alertController = UIAlertController(title: "Barcode Scanned", message: "바코드 : \(scan.stringValue) \n 제품명 : \(self.ingredientName) \n 유통기한 : \(self.ingredientDate)", preferredStyle: .alert)

            print("isit\(self.ingredientDate)")
            isShowingAlert = true

            alertController.addAction(UIAlertAction(title: "OK", style: .default) { action in
                self.isShowingAlert = false
            })

            present(alertController, animated: true)
        }
    }
    
    func getIngredientData(code:String){
        var parsedPogDayCount : String = ""
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
                        parsedPogDayCount = (aValue["POG_DAYCNT"] as? String)!
                        for i in pogDayCountParser{
                            if (parsedPogDayCount.contains(i)){
                                    print(i)
                                self.ingredientDate = "\(i)"
                            }else{
                                print("cannot parse")
                            }
                        }
                    }
                }
            }
           // if currentData.value(forKey: "0") as?String == self.recognizedBarcode{
            //}
            return TransactionResult.success(withValue: currentData)
            })
        }

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
