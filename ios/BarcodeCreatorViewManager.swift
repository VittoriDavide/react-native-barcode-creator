@objc(BarcodeCreatorViewManager)
class BarcodeCreatorViewManager: RCTViewManager {
    
    override func view() -> (BarcodeCreatorView) {
        return BarcodeCreatorView()
    }
    @objc
    override func constantsToExport() -> [AnyHashable : Any]! {
        return ["AZTEC": "CIAztecCodeGenerator",
                "CODE128": "CICode128BarcodeGenerator",
                "PDF417": "CIPDF417BarcodeGenerator",
                "QR": "CIQRCodeGenerator",
                "EAN13": "CIEANBarcodeGenerator",
                "UPCA": "CIEANBarcodeGenerator"
        ]
    }
}

class BarcodeCreatorView :  UIView {
    lazy var imageView = UIImageView()
    @objc var format = "CIQRCodeGenerator" {
        didSet {
            generateCode()
        }
    }
    
    @objc var value = "" {
        didSet {
            generateCode()
        }
    }
    
    @objc var foregroundColor: UIColor = .black {
        didSet {
            generateCode()
        }
    }
    
    @objc var background: UIColor = .white {
        didSet {
            generateCode()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        CIEANBarcodeGenerator.register()
        addSubview(imageView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    func generateCode() {
        guard !value.isEmpty, let filter = CIFilter(name: format),
              let data = value.data(using: .isoLatin1, allowLossyConversion: false) else {
            return
        }
    
        filter.setValue(data, forKey: "inputMessage")
        
        guard let ciImage = filter.outputImage else {
            return
        }
        
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        let invertFilter = CIFilter(name: "CIColorInvert")
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)
        
        let alphaFilter = CIFilter(name: "CIMaskToAlpha")
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        
        if let outputImage = alphaFilter?.outputImage  {
            imageView.tintColor = foregroundColor
            imageView.backgroundColor = background
            imageView.image = UIImage(ciImage: outputImage, scale: 2.0, orientation: .up)
                .withRenderingMode(.alwaysTemplate)
        }
    }
    
    @objc var color: String = "" {
        didSet {
            self.backgroundColor = hexStringToUIColor(hexColor: color)
        }
    }
    
    func hexStringToUIColor(hexColor: String) -> UIColor {
        let stringScanner = Scanner(string: hexColor)
        
        if(hexColor.hasPrefix("#")) {
            stringScanner.scanLocation = 1
        }
        var color: UInt32 = 0
        stringScanner.scanHexInt32(&color)
        
        let r = CGFloat(Int(color >> 16) & 0x000000FF)
        let g = CGFloat(Int(color >> 8) & 0x000000FF)
        let b = CGFloat(Int(color) & 0x000000FF)
        
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
}

