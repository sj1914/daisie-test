//
//  DetailedTransactionViewController.swift
//  ios-exercise
//
//  Created by Summer Jones on 18/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import UIKit

class DetailedTransactionViewController: UIViewController {
    
    @IBOutlet weak var merchantLogo: UIImageView!
    
    @IBOutlet weak var categoryLabel: UIView!
    @IBOutlet weak var editNoteButton: UIButton!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var merchant: UILabel!
    
    @IBOutlet weak var spent: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var transaction: Transaction!
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.dataManager.updateTransactionData(transaction: self.transaction)
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        self.spent.text = String(self.transaction.amount)
        self.merchant.text = self.transaction.merchant.name
        self.address.text = String(describing: self.transaction.merchant.address)
        self.address.lineBreakMode = .byWordWrapping
        do {
            if let imageURL = self.transaction.merchant.logoURL {
                let imageData = try Data(contentsOf: imageURL)
                let image = UIImage(data: imageData)!
                self.merchantLogo.image = self.cropToBounds(image: image, width: 50, height: 50)
            }
        } catch {
            
        }
        self.buildCategoryLabel()
        self.noteField.text = self.transaction.notes
    }
    
    func buildCategoryLabel() {
        var (icon, name) = getCategoryAssets(category: self.transaction.merchant.category)
        icon = icon.withRenderingMode(.alwaysTemplate)
        self.categoryImageView.image = icon
        self.categoryImageView.tintColor = UIColor.white
        
        self.categoryImageView.contentMode = .scaleAspectFit
        self.categoryName.text = name
        self.categoryLabel.layer.cornerRadius = 4.0
        self.categoryLabel.layer.masksToBounds = true
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCategoryAssets(category: String) -> (icon: UIImage, name: String) {

        switch category {
        case "eating_out":
            return (UIImage(named: "eatingOut")!, "Eating Out")
        case "travel":
            return (UIImage(named: "travel")!, "Travel")
        case "shopping":
            return (UIImage(named: "shopping")!, "Shopping")
        default:
            return (UIImage(named: "placeholder")!, "None")
        }
        
    }

    @IBAction func editNote(_ sender: Any) {
        if (self.noteField.isUserInteractionEnabled) {
            self.noteField.isUserInteractionEnabled = false
            self.editNoteButton.setImage(UIImage(named: "edit"), for: .normal)
            self.transaction.notes = self.noteField.text!
            self.noteField.borderStyle = .none
        } else {
            self.editNoteButton.setImage(UIImage(named: "save"), for: .normal)
//            self.editNoteButton.imageView?.image = UIImage(named: "save")
            self.noteField.isUserInteractionEnabled = true
            self.noteField.borderStyle = .roundedRect
        }
    }
    
}
