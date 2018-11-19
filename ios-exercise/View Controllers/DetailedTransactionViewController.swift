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
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var merchant: UILabel!
    
    @IBOutlet weak var spent: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var transaction: Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.show(transaction: self.transaction)
        // Do any additional setup after loading the view.
    }
    
    func show(transaction: Transaction) {
        self.spent.text = String(transaction.amount)
        self.merchant.text = transaction.merchant.name
        self.address.text = String(describing: transaction.merchant.address)
        self.address.lineBreakMode = .byWordWrapping
        do {
            if let imageURL = transaction.merchant.logoURL {
                let imageData = try Data(contentsOf: imageURL)
                self.merchantLogo.image = UIImage(data: imageData)
            }
        } catch {
            
        }
        self.categoryImageView.image = getCategoryIcon(category: transaction.merchant.category)
        self.categoryImageView.contentMode = .scaleAspectFit
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCategoryIcon(category: String) -> UIImage {

        switch category {
        case "eating_out":
            return UIImage(named: "eatingOut")!
        case "travel":
            return UIImage(named: "travel")!
        case "shopping":
            return UIImage(named: "shopping")!
        default:
            return UIImage(named: "placeholder")!
        }
        
    }


}
