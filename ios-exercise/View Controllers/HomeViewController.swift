import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var balanceViewLabel: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    private let refreshControl = UIRefreshControl()
    
    private var balance: Balance?
    private var transactions: [Transaction] = []
    private var transactionsDaily: [(date: Date, transactions: [Transaction])] = []
    
    private var detailedTransactionView: DetailedTransactionViewController!
    
    var dataDelegate: DataRefreshDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "HomeView"
        self.transactionTableView.accessibilityIdentifier = "transactionView"
        self.setupTableView()
        
        self.fetchTransactionData()
        self.fetchBalanceData()
        
        //Make balance refresh on both pages, set data delegate
        let cardNavController = self.tabBarController?.viewControllers?[1] as? UINavigationController
        self.dataDelegate = cardNavController?.viewControllers[0] as? DataRefreshDelegate
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTableView() {
        if #available(iOS 10.0, *) {
            transactionTableView.refreshControl = refreshControl
        } else {
            transactionTableView.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        fetchTransactionData()
        fetchBalanceData()
        self.dataDelegate?.refreshData()
    }
    
    private func groupTransactionsDaily(transactions: [Transaction]) -> [(Date, [Transaction])] {
        var transactionsDaily: [Date : [Transaction]] = [:]
        
        for transaction in transactions {
            let dateWithoutTime = Calendar.current.startOfDay(for: transaction.created)
            if var value = transactionsDaily[dateWithoutTime] {
                value.append(transaction)
                transactionsDaily.updateValue(value, forKey: dateWithoutTime)
            } else {
                transactionsDaily[dateWithoutTime] = [transaction]
            }
        }
        var fullySortedTransactions: [(Date, [Transaction])] = []
        for day in transactionsDaily {
            let transactionsByTime = day.value.sorted() {$0.created > $1.created}
            fullySortedTransactions.append((day.key, transactionsByTime))
        }
        fullySortedTransactions.sort() {$0.0 > $1.0}
        return fullySortedTransactions
    }
    
    private func fetchTransactionData() {
        dataManager.transactionData() { (transactionData, error) in
            DispatchQueue.main.async {
                if let transactions = transactionData {
                    self.transactions = transactions.transactions
                    self.transactionsDaily = self.groupTransactionsDaily(transactions: self.transactions)
                }
                self.transactionTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func fetchBalanceData() {
        dataManager.balanceData() { (balanceData, error) in
            DispatchQueue.main.async {
                if let balance = balanceData {
                    self.balance = balanceData
                    self.balanceViewLabel.text = "Balance: \(balance.balance)"
                }
                self.transactionTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionsDaily.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.transactionsDaily[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        let date = self.transactionsDaily[section].date
        label.text = date.formatToString()
        view.addSubview(label)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transactions = self.transactionsDaily[indexPath.section].transactions
        let transaction = transactions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as! TransactionTableViewCell
        cell.accessibilityIdentifier = "myCell_\(indexPath.section)_\(indexPath.row)"
        cell.setTransaction(transaction: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let transactions = self.transactionsDaily[indexPath.section].transactions
        let transaction = transactions[indexPath.row]
        self.pushDetailedTransactionView(for: transaction)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func pushDetailedTransactionView(for transaction: Transaction) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.detailedTransactionView = storyboard.instantiateViewController(withIdentifier: "DetailedTransactionView") as? DetailedTransactionViewController
        
        self.detailedTransactionView.transaction = transaction
        self.detailedTransactionView.title = "\(transaction.created.formatToString()) \(transaction.time)"
        
        if let navigator = self.tabBarController?.viewControllers?[0] as? UINavigationController {
            navigator.pushViewController(self.detailedTransactionView, animated: true)
        }
        
    }

}

protocol DataRefreshDelegate {
    func refreshData()
}
