//
//  DetailedTransactionViewController.swift
//  ios-exercise
//
//  Created by Summer Jones on 18/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailedTransactionViewController: UIViewController {
    
    @IBOutlet weak var merchantLogo: UIImageView!
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
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
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "DetailedTransactionView"
        self.setupView()
        self.addMapView()
    }
    
    override func viewDidLayoutSubviews() {
        self.mapView.frame = self.mapContainerView.frame
    }
    
    func setupView() {
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10.0
        self.backgroundView.backgroundColor = UIColor(displayP3Red: 94/255, green: 174/255, blue: 205/255, alpha: 0.5)
        self.spent.text = String(self.transaction.amount)
        self.merchant.text = self.transaction.merchant.name
        self.address.text = String(describing: self.transaction.merchant.address)
        self.address.lineBreakMode = .byWordWrapping
        do {
            if let imageURL = self.transaction.merchant.logoURL {
                let imageData = try Data(contentsOf: imageURL)
                let image = UIImage(data: imageData)!
                let width = Double(self.merchantLogo.frame.width)
                let height = Double(self.merchantLogo.frame.height)
                self.merchantLogo.image = image.cropToBounds(width: width, height: height)
            }
        } catch {
            self.merchantLogo.image = UIImage(named: "placeholder")
        }
        self.buildCategoryLabel()
        self.noteField.text = self.transaction.notes
        self.merchantLogo.layer.masksToBounds = true
        self.merchantLogo.layer.cornerRadius = 4.0
    }
    
    func addMapView() {
        
        let latitude = self.transaction.merchant.address.latitude
        let longitude = self.transaction.merchant.address.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = self.mapView
        
        self.mapContainerView.addSubview(self.mapView)
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
