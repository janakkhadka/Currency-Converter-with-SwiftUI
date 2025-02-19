//
//  ConverterViewModel.swift
//  JK Currency Converter
//
//  Created by Janak Khadka on 19/02/2025.
//

import Foundation

class ConverterViewModel: ObservableObject {
    @Published var converter: Conversion?
    @Published var isLoading = false
    @Published var error: String?
    
    private let networkManager = NetworkManager()
    
    func fetchConversion(from: String, to: String, amount: Double){
        isLoading = true
        error = nil
        
        networkManager.getExchangeRate(from: from, to: to, amount: amount) { [weak self] converter in
            DispatchQueue.main.async{
                self?.isLoading = false
                if let converter = converter {
                    self?.converter = converter
                }else {
                    self?.error = "failed to fetch conversion"
                }
            }
        }
    }
}
