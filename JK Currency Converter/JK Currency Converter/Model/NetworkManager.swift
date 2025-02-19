//
//  NetworkManager.swift
//  JK Currency Converter
//
//  Created by Janak Khadka on 19/02/2025.
//
import Foundation

class NetworkManager {
    private let apiKey = "05842c2b34c84d079e9db505"
    private let baseURL = "https://v6.exchangerate-api.com/v6"
    
    func getExchangeRate(from: String, to: String, amount: Double, completion: @escaping (Conversion?) -> Void) {
        let apiURL = "\(baseURL)/\(apiKey)/pair/\(from)/\(to)/\(amount)"
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Parsed JSON: \(json)")
                    
                    if let conversionRate = json["conversion_rate"] as? Double,
                       let conversionResult = json["conversion_result"] as? Double,
                       let lastUpdate = json["time_last_update_utc"] as? String {
                        let conversion = Conversion(conversionRate: conversionRate, conversionResult: conversionResult, lastUpdate: lastUpdate)
                        completion(conversion)
                    } else {
                        print("Failed to parse required fields from JSON")
                        completion(nil)
                    }
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}
