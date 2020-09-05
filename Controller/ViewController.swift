

import UIKit

class ViewController: UIViewController{
    var coinManager = CoinManager()
    

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        currencyLabel.text = currency
        coinManager.getCoinPrice(for: currency)
    }
}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}


//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdatePrice(_ manager: CoinManager, price: Double) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.1f", price)
        }
    }
    
    
}
