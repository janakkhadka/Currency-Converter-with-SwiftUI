//
//  Conversion.swift
//  JK Currency Converter
//
//  Created by Janak Khadka on 19/02/2025.
//

import Foundation

struct Conversion: Identifiable {
    let id = UUID()
    let conversionRate: Double
    let conversionResult: Double
    let lastUpdate: String
    let fromCurrency: String
    let toCurrency: String
}
