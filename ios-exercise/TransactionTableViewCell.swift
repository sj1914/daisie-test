import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var transactionCost: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    
    func setTransaction(transaction: Transaction) {
        self.transactionCost.text = transaction.amount
        self.transactionLabel.text = transaction.description
        
        do {
            if let imageURL = transaction.merchant.logoURL {
                let imageData = try Data(contentsOf: imageURL)
                self.transactionImage.image = UIImage(data: imageData)
            }
        } catch {
//            assertionFailure()
        }
        
    }

}
