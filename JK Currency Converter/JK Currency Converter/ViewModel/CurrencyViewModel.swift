//
//  CurrencyViewModel.swift
//  JK Currency Converter
//
//  Created by Janak Khadka on 19/02/2025.
//

import SwiftUI

class CurrencyViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var selectedCurrency: String = "USD"
    
    
    init() {
        loadCurrencies()
    }
    
    // Load currencies CurrecnyFlagDict, mathy model maa xa
    private func loadCurrencies() {
        currencies = currencyFlags.map { Currency(code: $0.key, flagURL: $0.value) }
    }
}
