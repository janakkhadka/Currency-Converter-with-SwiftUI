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
                    BottomCardView(fromCurrency: $fromCurrency, toCurrency: $toCurrency, amount: $amount)
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
    
    @ObservedObject private var converterViewModel = ConverterViewModel()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(red: 81/255, green: 117/255, blue: 148/255)).opacity(1)
            .frame(maxWidth: .infinity, maxHeight: 450)
            .padding(.horizontal)
            .padding(.top)
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
                            Text("\(converterViewModel.converter.conversionResult)")
                                .frame(width: 120, height: 50)
                                .padding(.vertical, 5)
                                .background(.white)
                                .font(.system(size: 45))
                                .cornerRadius(5)
                            Spacer()
                        }
                    }
                    
                    Divider()
                        .background()
                        .padding()
                        .padding(.horizontal, 15)
                    
                    Spacer()
                    Button(action: {
                        converterViewModel.fetchConversion(from: fromCurrency, to: toCurrency, amount: amount)
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

import SwiftUI

struct CurrencyPickerView: View {
    @ObservedObject private var viewModel = CurrencyViewModel()
    @Binding var selectedCurrency: String
    
    var body: some View {
        Menu {
            ForEach(viewModel.currencies) { currency in
                Button {
                    selectedCurrency = currency.code
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: currency.flagURL)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 30, height: 20)
                        
                        Text(currency.code)
                            .foregroundColor(Color(red: 81/255, green: 117/255, blue: 148/255))
                            .font(.system(size: 30, weight: .medium))
                    }
                }
            }
        } label: {
            HStack {
                AsyncImage(url: URL(string: viewModel.currencies.first { $0.code == selectedCurrency }?.flagURL ?? "")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 30, height: 20)
                
                Text(selectedCurrency)
                    .foregroundColor(Color(red: 81/255, green: 117/255, blue: 148/255))
                    .font(.system(size: 30, weight: .medium))
                
                Image(systemName: "chevron.down")
                    .foregroundColor(Color(red: 81/255, green: 117/255, blue: 148/255))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}
struct BottomCardView: View {
    @Binding var fromCurrency: String
    @Binding var toCurrency: String
    @Binding var amount: Double
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(maxWidth: .infinity, maxHeight: 250)
            .padding()
            .overlay {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Indicative Exchange Rate")
                                .opacity(0.7)
                                .padding(.top, 30)
                                .padding(.horizontal)
                                .font(.system(size: 20))
                                .padding(.bottom, 2)
                            
                            Text("\(amount) \(fromCurrency) = \(toCurrency)")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.horizontal)
                        }
                        .padding()
                        Spacer()
                    }
                    Divider()
                        .padding(.top)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Last Updated On")
                                .opacity(0.7)
                                .padding(.top, 2)
                                .padding(.horizontal)
                                .font(.system(size: 20))
                                
                            
                            Text("abc")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                                .padding(.top, 2)
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
        
    }
}

#Preview {
    CurrencyConverterView()
}
