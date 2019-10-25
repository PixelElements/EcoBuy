import UIKit

class ProductView : UIView {
    
    private var lastScannedItem : UIView = {
       var item = UIView()
        item.backgroundColor = customLightGrayColor
        item.layer.cornerRadius = 25
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    private var productImage : UIImageView = {
       var image = UIImageView()
        image.image = UIImage(named: "productImage")
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        image.layer.cornerRadius = 25
        image.backgroundColor = .red
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var lastScannedItemTitle : UILabel = {
        var text = UILabel()
        text.text = "Last scanned"
        text.textColor = UIColor(red:0.92, green:0.92, blue:0.96, alpha:0.6)
        text.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var lastScannedItemName : UILabel = {
        var text = UILabel()
        text.text = "Mineral water 1.5l"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var lastScannedItemDescription : UILabel = {
        var text = UILabel()
        text.text = "Date: 1.10.2020"
        text.textColor = UIColor(red:0.92, green:0.92, blue:0.96, alpha:0.6)
        text.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        //setupViews()
    }
     
    init(text1 : String, text2 : String, text3 : String, imageName: String) {
        super.init(frame: .zero)
        setupViews(text1: text1, text2: text2, text3: text3, imageName: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(text1 : String, text2 : String, text3 : String, imageName: String) {
        
        lastScannedItemTitle.text = text1
        lastScannedItemName.text = text2
        lastScannedItemDescription.text = text3
        productImage.image = UIImage.init(named: imageName)
        
        addSubview(lastScannedItem)
        lastScannedItem.addSubview(lastScannedItemTitle)
        lastScannedItem.addSubview(lastScannedItemName)
        lastScannedItem.addSubview(lastScannedItemDescription)
        lastScannedItem.addSubview(productImage)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": lastScannedItem]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": lastScannedItem]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(250)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productImage]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productImage]))
        
        addConstraint(NSLayoutConstraint.init(item: lastScannedItemTitle, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1.0, constant: 20.0))
        
        addConstraint(NSLayoutConstraint.init(item: lastScannedItemTitle, attribute: NSLayoutConstraint.Attribute.left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0))
        
        addConstraint(NSLayoutConstraint.init(item: lastScannedItemName, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: lastScannedItemTitle, attribute: .bottom, multiplier: 1.0, constant: 6.0))
        
        addConstraint(NSLayoutConstraint.init(item: lastScannedItemName, attribute: NSLayoutConstraint.Attribute.left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0))
        
        addConstraint(NSLayoutConstraint.init(item: lastScannedItemDescription, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: lastScannedItemName, attribute: .bottom, multiplier: 1.0, constant: 6.0))
        
        addConstraint(NSLayoutConstraint.init(item: lastScannedItemDescription, attribute: NSLayoutConstraint.Attribute.left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0))
    }
}
