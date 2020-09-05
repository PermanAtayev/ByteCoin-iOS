
import Foundation

struct Info{
    
}

protocol CoinManagerDelegate{
    func didFailWithError(error: Error)
    func didUpdatePrice(_ manager: CoinManager, price: Double)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "873E98CA-AAB9-4195-9D63-23CA25F5EC6C"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let url = baseURL + "/" + currency + "?apikey=" + apiKey
        print(url)
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let info = self.parseJSON(safeData){
                        self.delegate?.didUpdatePrice(self, price: info)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
