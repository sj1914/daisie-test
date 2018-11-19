import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var roundedCornerButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchBalanceData()
        roundedCornerButton.layer.cornerRadius = 4
    }
    
    private func fetchBalanceData() {
        dataManager.balanceData() { (balanceData, error) in
            DispatchQueue.main.async {
                if let balance = balanceData {
                    self.balanceLabel.text = "Balance: \(balance.balance)"
                }
            }
        }
    }
    
    func addMoney() {
        
    }

}

