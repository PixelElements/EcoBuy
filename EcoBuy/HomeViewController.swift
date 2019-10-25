//
//  ViewController.swift
//  EcoBuy
//
//  Created by Konrad on 13/10/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit

let customLightGrayColor : UIColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha: 0.94)

class HomeViewController: UIViewController {
    
    //MARK: ScrollView objects configuration
    
    private var mainScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private var contentView : UIView = {
       var content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .black
        return content
    }()
    
    //MARK: Last scanned items objects configuration
    
    private var lastScannedItem  = ProductView(text1: "Last Scanned", text2: "Mineral water 1.5l", text3: "Date 1.10.2020", imageName: "productImage")
    
    private var tipOfTheDay : ProductView = ProductView(text1: "Tip of the day", text2: "Lorem ipsum dolor sit amet", text3: "Lorem ipsum ", imageName: "productImage")
    
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
    
    //MARK: See all items objects configuration
    
    private var seeAllView : UIView = {
       var content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = customLightGrayColor
        content.layer.cornerRadius = 25
        return content
    }()
    
    private var seeAllTitle : UILabel = {
        var text = UILabel()
        text.text = "See all scanned products"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var seeAllAmount : UILabel = {
        var text = UILabel()
        text.text = "121 products"
        text.textColor = UIColor(red:0.92, green:0.92, blue:0.96, alpha:0.6)
        text.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var seePreviousTips : UIView = {
       var content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = customLightGrayColor
        content.layer.cornerRadius = 25
        return content
    }()
    
    private var seePreviousTipsTitle : UILabel = {
        var text = UILabel()
        text.text = "See previous tips"
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = customLightGrayColor
        mainScrollView.contentSize = contentView.frame.size
        
        setupView()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.barTintColor = customLightGrayColor
        
        self.navigationController?.view.backgroundColor = customLightGrayColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .green
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"barcode.viewfinder" ), style: UIBarButtonItem.Style.plain, target: self, action: #selector(scanTapped))
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupView() {
        
        lastScannedItem.translatesAutoresizingMaskIntoConstraints = false
        tipOfTheDay.translatesAutoresizingMaskIntoConstraints = false
        let contentWidth = UIScreen.main.bounds.width - 32
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(lastScannedItem)
        contentView.addSubview(tipOfTheDay)
        contentView.addSubview(seeAllView)
        contentView.addSubview(seePreviousTips)
        seeAllView.addSubview(seeAllTitle)
        seeAllView.addSubview(seeAllAmount)
        seePreviousTips.addSubview(seePreviousTipsTitle)


        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": mainScrollView]))
        view.addConstraint(NSLayoutConstraint.init(item: mainScrollView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        view.addConstraint(NSLayoutConstraint.init(item: mainScrollView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: view.layoutMarginsGuide, attribute: .top, multiplier: 1.0, constant: 1.0))
        
    mainScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": contentView]))
    mainScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(920)]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": contentView]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(contentWidth))]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": seeAllView]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(contentWidth))]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": lastScannedItem]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(350)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": lastScannedItem]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(contentWidth))]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": tipOfTheDay]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(contentWidth))]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": seePreviousTips]))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seeAllView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 16.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seeAllView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: lastScannedItem, attribute: .width, multiplier: 1.0, constant: 1.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seeAllView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 85.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seeAllView, attribute: .top, relatedBy: .equal, toItem: lastScannedItem, attribute: .bottom, multiplier: 1.0, constant: 16.0))
        
        seeAllView.addConstraint(NSLayoutConstraint.init(item: seeAllTitle, attribute: .top, relatedBy: .equal, toItem: seeAllView, attribute: .top, multiplier: 1.0, constant: 20.0))
        
        seeAllView.addConstraint(NSLayoutConstraint.init(item: seeAllAmount, attribute: .top, relatedBy: .equal, toItem: seeAllTitle, attribute: .bottom, multiplier: 1.0, constant: 6.0))
        
        seeAllView.addConstraint(NSLayoutConstraint.init(item: seeAllTitle, attribute: .left, relatedBy: .equal, toItem: seeAllView, attribute: .left, multiplier: 1.0, constant: 20))
        
        seeAllView.addConstraint(NSLayoutConstraint.init(item: seeAllAmount, attribute: .left, relatedBy: .equal, toItem: seeAllView, attribute: .left, multiplier: 1.0, constant: 20))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: tipOfTheDay, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: lastScannedItem, attribute: .width, multiplier: 1.0, constant: 1.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: tipOfTheDay, attribute: .top, relatedBy: .equal, toItem: seeAllView, attribute: .bottom, multiplier: 1.0, constant: 16.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: tipOfTheDay, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 350.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seePreviousTips, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seePreviousTips, attribute: .top, relatedBy: .equal, toItem: tipOfTheDay, attribute: .bottom, multiplier: 1.0, constant: 16.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seePreviousTipsTitle, attribute: .left, relatedBy: .equal, toItem: seePreviousTips, attribute: .left, multiplier: 1.0, constant: 20.0))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: seePreviousTipsTitle, attribute: .top, relatedBy: .equal, toItem: seePreviousTips, attribute: .top, multiplier: 1.0, constant: 28.0))
        
                      
               
    }
    
    @objc func scanTapped() {
        print("Tapped scan button")
        navigationController?.pushViewController(ScannerViewController(), animated: true)
    }
}



