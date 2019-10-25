//
//  ProductViewController.swift
//  EcoBuy
//
//  Created by Konrad on 16/10/2019.
//  Copyright © 2019 Konrad. All rights reserved.
//

import UIKit
import Firebase

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var barcode : String?
    
    var ingredients = [Product]()
        
    private var productImage : UIImageView = {
       var image = UIImageView()
        image.image = UIImage.init(named: "productImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var productImageColor : UIView = {
       var view = UIView()
        view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.45)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var productTitle : UITextView = {
        var text = UITextView()
        text.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        text.text = "Mineral water 1.5l"
        text.textColor = .white
        text.backgroundColor = .clear
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private var productScrollView : UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width:  UIScreen.main.bounds.width, height: 1000)
        return scrollView
    }()
    private var contentView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    private var ingredientsLabel : UITextView = {
        var text = UITextView()
        text.text = "Składniki:"
        text.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        text.textColor = .white
        text.backgroundColor = .clear
        text.isEditable = false
        text.isSelectable = false
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private var alternative : ProductView?
    private var ingredientsCV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var constraintVariable: NSLayoutConstraint = ingredientsCV.heightAnchor.constraint(equalToConstant: CGFloat(ingredients.count * 40))
        constraintVariable.isActive = true

        let ref = Database.database().reference(withPath: "products").child(barcode!)
        let ingredientsRef = Database.database().reference(withPath: "products").child(barcode!).child("goodIngredients")
        alternative = ProductView(text1: "Available in Tesco", text2: "Woda mineralna", text3: "plactic", imageName: "productImage")
        alternative?.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
        ingredientsCV.register(IngredientCell.self, forCellWithReuseIdentifier: "ingredientCell")
        ingredientsCV.delegate = self
        ingredientsCV.dataSource = self
        ref.observe(.value, with: { snapshot in
            if let data = snapshot.value as? NSDictionary {
                let name = data["name"] as? String ?? "errorString"
                self.productTitle.text = name
            }
        })
        ref.child("goodIngredients").observe(.value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.key
                let ing = value
                self.ingredients.append(Product(name: ing, isGood: true))
            }
            
            constraintVariable.constant = CGFloat(self.ingredients.count * 40)
            self.view.layoutIfNeeded()
        })
        ref.child("badIngredients").observe(.value, with: { snapshot in
                 for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let value = snap.key
                    let ing = value
                    self.ingredients.append(Product(name: ing, isGood: false))
                }

            constraintVariable.constant = CGFloat(self.ingredients.count * 40)
            self.view.layoutIfNeeded()
            self.ingredientsCV.reloadData()
            })
        
        setupViews()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Ingredients count: \(ingredients.count)")
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.name.text = ingredients[indexPath.item].name
        if ingredients[indexPath.item].isGood == true {
            cell.icon.image = UIImage.init(named: "Goodingredient")
        } else {
            cell.icon.image = UIImage.init(named: "Badingredient")
        }
        print(ingredients[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: 30)
    }
    
    private func setupViews() {
        
        let contentWidth = UIScreen.main.bounds.width - 32

        view.addSubview(productImage)
        productImage.addSubview(productImageColor)
        productImage.addSubview(productTitle)
        view.addSubview(productScrollView)
        productScrollView.addSubview(contentView)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(alternative!)
        contentView.addSubview(ingredientsCV)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productImage]))
    productImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productImageColor]))
    productImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productImageColor]))
        
        productImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    productImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-190-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productTitle]))
    productImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-6-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productTitle]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": productScrollView]))
        
        view.addConstraint(NSLayoutConstraint.init(item: productScrollView, attribute: .top, relatedBy: .equal, toItem: productImage, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        
        view.addConstraint(NSLayoutConstraint.init(item: productScrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        productScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0(\(UIScreen.main.bounds.width))]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": contentView]))
        productScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(1000)]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": contentView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": ingredientsLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(40)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": ingredientsLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(contentWidth))]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": alternative!]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(\(contentWidth))]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": ingredientsCV]))
        
        //contentView.addConstraint(NSLayoutConstraint.init(item: ingredientsCV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(ingredients.count * 40)))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: ingredientsCV, attribute: .top, relatedBy: .equal, toItem: ingredientsLabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: alternative!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 350))
        
        contentView.addConstraint(NSLayoutConstraint.init(item: alternative!, attribute: .top, relatedBy: .equal, toItem: ingredientsCV, attribute: .bottom, multiplier: 1.0, constant: 16))
    }

}

class IngredientCell : UICollectionViewCell {
    
    var icon : UIImageView = {
       var icon = UIImageView()
        icon.image = UIImage.init(named: "Goodingredient")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var name : UITextView = {
       var name = UITextView()
        name.text = "Mączka świętojańska"
        name.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        name.textColor = .white
        name.backgroundColor = .clear
        name.translatesAutoresizingMaskIntoConstraints = false
        name.contentMode = .scaleAspectFill
        name.isSelectable = false
        name.isUserInteractionEnabled = false
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        addSubview(icon)
        addSubview(name)
        //addConstraint(NSLayoutConstraint.init(item: icon, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 1.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(20)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": icon]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0(20)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": icon]))
        addConstraint(NSLayoutConstraint.init(item: name, attribute: .left, relatedBy: .equal, toItem: icon, attribute: .right, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint.init(item: name, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300))
        addConstraint(NSLayoutConstraint.init(item: name, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint.init(item: name, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        
        
    }
    
}
