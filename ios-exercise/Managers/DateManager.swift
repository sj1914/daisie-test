//
//  DateManager.swift
//  ios-exercise
//
//  Created by Summer Jones on 17/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    
    case Unknown
    case FailedRequest
    case InvalidResponse
    
}

class DataManager {
    
    typealias TransactionDataCompletion = (Transactions?, DataManagerError?) -> ()
    typealias BalanceDataCompletion = (Balance?, DataManagerError?) -> ()
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func transactionData(completion: @escaping TransactionDataCompletion) {
        let url = baseURL.appendingPathComponent("transactions")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.didFetchTransactionData(data: data, response: response, error: error, completion: completion)
            
            }.resume()
    }
    
    func updateTransactionData(transaction: Transaction) {
        let url = baseURL.appendingPathComponent("transactions")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(transaction)
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
        }
        task.resume()
    }
    
    func balanceData(completion: @escaping BalanceDataCompletion) {
        let url = baseURL.appendingPathComponent("balance")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.didFetchBalanceData(data: data, response: response, error: error, completion: completion)
            
            }.resume()
    }
    
    private func didFetchTransactionData(data: Data?, response: URLResponse?, error: Error?, completion: TransactionDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processTransactionData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
            
        } else {
            completion(nil, .Unknown)
        }
        
    }
    
    private func didFetchBalanceData(data: Data?, response: URLResponse?, error: Error?, completion: BalanceDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processBalanceData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
            
        } else {
            completion(nil, .Unknown)
        }
        
    }
    
    private func processTransactionData(data: Data, completion:TransactionDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) {
            completion(Transactions(JSON: JSON), nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
    private func processBalanceData(data: Data, completion:BalanceDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) {
            completion(Balance(JSON: JSON), nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
}


