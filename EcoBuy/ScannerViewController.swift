import AVFoundation
import UIKit
import Firebase

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
        
    var barcode : String = ""
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var ref : DatabaseReference?
    
    private var previewView : UIView = {
        var view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var barcodeText : UITextView = {
        var text = UITextView()
        text.text = "Umieść kod kreskowy w środku"
        text.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        text.textColor = UIColor(red:0.92, green:0.92, blue:0.96, alpha:0.6)
        text.backgroundColor = .clear
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "products")

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"square.and.pencil" ), style: UIBarButtonItem.Style.plain, target: self, action: #selector(typedBarcode))
        
        navigationItem.title = "Scan product"
        view.backgroundColor = .black
        view.addSubview(previewView)
        view.addSubview(barcodeText)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[v0(\(UIScreen.main.bounds.width - 100))]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": previewView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[v0]-50-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": previewView]))
        view.addConstraint(NSLayoutConstraint.init(item: barcodeText, attribute: .top, relatedBy: .equal, toItem: previewView, attribute: .bottom, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint.init(item: barcodeText, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25.0))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0(\(UIScreen.main.bounds.width))]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": barcodeText]))
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.backgroundColor = UIColor.black.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame.size = self.previewView.frame.size
        previewView.layer.addSublayer(previewLayer)
        
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        
        self.navigationController?.navigationBar.backgroundColor = customLightGrayColor
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        self.barcode = code
        let productView = ProductViewController()
        productView.barcode = self.barcode
        self.navigationController?.pushViewController(productView, animated: true)
    }
    
    @objc func typedBarcode() {
        let alert = UIAlertController(title: "Dodaj kod kreskowy", message: "Jeśli nie możesz zeskanować kodu produktu wprowadź go ręcznie", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Kod kreskowy"
        
        alert.addAction(UIAlertAction.init(title: "Szukaj", style: .default, handler: { (action) in
            
            if let code = textField.text {
                self.barcode = code
                let productView = ProductViewController()
                if self.barcode != "" {
                    
                    self.ref!.observeSingleEvent(of: .value, with: { (snapshot) in

                        if snapshot.hasChild(self.barcode){
                            productView.barcode = self.barcode
                            self.navigationController?.pushViewController(productView, animated: true)

                        } else {
                            self.failBarcode(alert: alert, withMessage: "Nie ma w naszej bazie takiego kodu")
                        }

                    })
                } else {
                    self.failBarcode(alert: alert, withMessage: "Wpisz kod")
                }
            } else {
                self.failBarcode(alert: alert, withMessage: "Wpisz kod")
            }
        }))
    }
        self.present(alert, animated: true, completion: nil)
}
    
    func failBarcode(alert : UIAlertController, withMessage : String) {
        alert.dismiss(animated: true, completion: {
            let alertController = UIAlertController(title: withMessage, message:
                    "Podaj kod jeszcze raz", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Wyjdź", style: .default))

                self.present(alertController, animated: true, completion: nil)
        })
    }
}
