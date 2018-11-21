import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var transactionCost: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    
    func setTransaction(transaction: Transaction) {
        self.transactionCost.text = transaction.amount
        self.transactionLabel.text = transaction.description
        self.setTransactionImage(for: transaction)
    }
    
    private func setTransactionImage(for transaction: Transaction) {
        var image = UIImage(named: "placeholder")
        if let imageURL = transaction.merchant.logoURL {
            do {
                let imageData = try Data(contentsOf: imageURL)
                image = UIImage(data: imageData)
            } catch {
                print("Image data not successfully decoded.")
            }
        }
        let width = Double(self.transactionImage.frame.width)
        let height = Double(self.transactionImage.frame.height)
        if let image = image {
            self.transactionImage.image = image.cropToBounds(width: width, height: height)
        }
    }

}
