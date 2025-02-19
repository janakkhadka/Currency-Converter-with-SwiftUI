//
//  ContentView.swift
//  JK Currency Converter
//
//  Created by Janak Khadka on 19/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedCurrency = "USD"
    
    var body: some View {
        VStack {
            Text("Select Currency")
                .font(.headline)
            
            Picker("Currency", selection: $selectedCurrency) {
                ForEach(Array(currencyFlags.keys.sorted()), id: \.self) { code in
                    HStack {
                        AsyncImage(url: URL(string: currencyFlags[code]!)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 16, height: 12)
                        
                        Text(code)
                    }
                    .tag(code)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Text("Selected Currency: \(selectedCurrency)")
                .padding(.top, 20)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
