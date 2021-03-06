import UIKit

class CardViewController: UIViewController, DataRefreshDelegate {

    @IBOutlet weak var roundedCornerButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    private var addMoneyView: AddMoneyViewController!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "CardView"
        self.roundedCornerButton.accessibilityIdentifier = "AddMoneyButton"
        self.fetchBalanceData()
        roundedCornerButton.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func refreshData() {
        self.fetchBalanceData()
    }
    
    private func fetchBalanceData() {
        dataManager.balanceData() { (balanceData, error) in
            DispatchQueue.main.async {
                if let balance = balanceData {
                    self.balanceLabel.text = "Balance \(balance.balance)"
                }
            }
        }
    }

    @IBAction func showAddMoneyView(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.addMoneyView = storyboard.instantiateViewController(withIdentifier: "AddMoneyView") as? AddMoneyViewController
        self.addMoneyView.title = "Add Money"

        if let navigator = self.tabBarController?.viewControllers?[1] as? UINavigationController {
            navigator.pushViewController(self.addMoneyView, animated: true)
        }
    }

}

