//
//  CurrencyConverterView.swift
//  JK Currency Converter
//
//  Created by Janak Khadka on 19/02/2025.
//

import SwiftUI

struct CurrencyConverterView: View {
    @State private var fromCurrency = "NPR"
    @State private var toCurrency = "USD"
    @State private var amount: Double = 1
    
    @ObservedObject private var currencyViewModel = CurrencyViewModel()
    @ObservedObject private var converterViewModel = ConverterViewModel()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                VStack {
                    ConverterCardView(fromCurrency: $fromCurrency, toCurrency: $toCurrency, amount: $amount)
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("JK Currency Converter")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct ConverterCardView: View {
    @Binding var fromCurrency: String
    @Binding var toCurrency: String
    @Binding var amount: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(red: 81/255, green: 117/255, blue: 148/255)).opacity(1)
            .frame(maxWidth: .infinity, maxHeight: 450)
            .padding()
            .overlay {
                VStack{
                    Spacer()
                    VStack{
                        HStack {
                            Text("Amount")
                                .foregroundStyle(.white)
                                .padding(.horizontal,35)
                                .font(.system(size: 25))
                            Spacer()
                        }
                        
                        HStack{
                            Spacer()
                            CurrencyPickerView(selectedCurrency: $fromCurrency)
                            Spacer()
                            TextField("\(fromCurrency)", value: $amount, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 120, height: 50)
                                .padding(.vertical, 5)
                                .background(.white)
                                .font(.system(size: 45))
                            Spacer()
                        }
                    }
                    Spacer()
                    
                    Divider()
                        .background()
                        .padding()
                        .padding(.horizontal, 15)
                    
                    
                    VStack{
                        HStack {
                            Text("Converted Amount")
                                .foregroundStyle(.white)
                                .padding(.horizontal,35)
                                .font(.system(size: 25))
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            CurrencyPickerView(selectedCurrency: $toCurrency)
                            Spacer()
                            Text("\(toCurrency)")
                                .frame(width: 120, height: 50)
                                .padding(.vertical, 5)
                                .background(.white)
                                .font(.system(size: 45))
                                .cornerRadius(5)
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    Button(action: {
                        // Your action here
                    }) {
                        Text("Convert")
                            .font(.headline)
                            .foregroundColor(Color(red: 81/255, green: 117/255, blue: 148/255)) // Text color
                            .frame(width: 200, height: 50)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                }
            }
    }
}

struct CurrencyPickerView: View {
    @Binding var selectedCurrency: String
    
    var body: some View {
        Picker("Currency", selection: $selectedCurrency) {
            ForEach(Array(currencyFlags.keys.sorted()), id: \.self) { code in
                HStack {
                    AsyncImage(url: URL(string: currencyFlags[code]!)) { image in
                        image.resizable()
                            .font(.system(size: 20))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 10, height: 12)
                    Text(code)
                        .foregroundColor(Color(red: 81/255, green: 117/255, blue: 148/255))
                        .font(.system(size: 27, weight: .medium))
                }
                .tag(code)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    CurrencyConverterView()
}
