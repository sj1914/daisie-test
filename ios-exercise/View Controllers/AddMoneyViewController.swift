//
//  AddMoneyViewController.swift
//  ios-exercise
//
//  Created by Summer Jones on 19/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import UIKit

class AddMoneyViewController: UIViewController {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var addMoneyButton: UIButton!
    
    var amountToAdd: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "AddMoneyView"
        self.amountLabel.accessibilityIdentifier = "amountLabel"
        self.decreaseButton.layer.cornerRadius = 4.0
        self.increaseButton.layer.cornerRadius = 4.0
        self.addMoneyButton.layer.cornerRadius = 4.0
        self.setAmountLabel()
    }
    
    func setAmountLabel() {
        if let currencySymbol = Locale.current.currencySymbol {
            self.amountLabel.text = "\(currencySymbol)\(amountToAdd)"
        } else {
            self.amountLabel.text = "£\(amountToAdd)"
            print("Could not localise currency symbol.")
        }
    }

    @IBAction func addMoney(_ sender: Any) {
    }
    
    @IBAction func decreaseAmount(_ sender: Any) {
        self.amountToAdd = self.amountToAdd - 10
        self.setAmountLabel()
        
        if self.amountToAdd <= 10 {
            self.decreaseButton.isUserInteractionEnabled = false
            self.decreaseButton.backgroundColor = UIColor.gray
        }
    }
    
    @IBAction func increaseAmount(_ sender: Any) {
        self.decreaseButton.isUserInteractionEnabled = true
        self.decreaseButton.backgroundColor = UIColor(displayP3Red: 77/255, green: 154/255, blue: 172/255, alpha: 1)
        self.amountToAdd = self.amountToAdd + 10
        self.setAmountLabel()
    }
}
