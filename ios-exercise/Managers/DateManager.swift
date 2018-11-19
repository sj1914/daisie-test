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
