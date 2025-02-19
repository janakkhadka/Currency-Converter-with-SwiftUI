//
//  CurrencyConverterView.swift
//  JK Currency Converter
//
//  Created by Janak Khadka on 19/02/2025.
//

import SwiftUI

struct CurrencyConverterView: View {
    @State private var fromCurrency = "USD"
    @State private var toCurrency = "NPR"
    @State private var amount: Double = 1
    
    @StateObject private var converterViewModel = ConverterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
                VStack {
                    ConverterCardView(fromCurrency: $fromCurrency, toCurrency: $toCurrency, amount: $amount, converterViewModel: converterViewModel)
                    BottomCardView(fromCurrency: $fromCurrency, toCurrency: $toCurrency, amount: $amount, converterViewModel: converterViewModel)
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
        .onAppear {
            converterViewModel.fetchConversion(from: fromCurrency, to: toCurrency, amount: amount) //suruma load huda ko l lagi
        }
    }
}

struct ConverterCardView: View {
    @Binding var fromCurrency: String
    @Binding var toCurrency: String
    @Binding var amount: Double
    
    @ObservedObject var converterViewModel: ConverterViewModel
    
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
                                .frame(width: 120, height: 55)
                                .padding(.vertical, 5)
                                .background(.white)
                                .font(.system(size: 35))
                                .cornerRadius(5)
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
                            if let converter = converterViewModel.converter{
                                Text("\(String(format: "%.2f",converter.conversionResult))")
                                    .frame(width: 120, height: 55)
                                    .padding(.vertical, 5)
                                    .background(.white)
                                    .font(.system(size: 30))
                                    .cornerRadius(5)
                                
                            }else{
                                Text("\(toCurrency)")
                                    .frame(width: 120, height: 55)
                                    .padding(.vertical, 5)
                                    .background(.white)
                                    .font(.system(size: 35))
                                    .cornerRadius(5)
                            }
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
    
    @ObservedObject var converterViewModel: ConverterViewModel
    
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
                            if let converter = converterViewModel.converter{
                                Text("1.00 \(converter.fromCurrency) = \(String(format: "%.2f",converter.conversionRate)) \(converter.toCurrency)")
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.horizontal)
                            }else{
                                Text("\(String(format: "%.2f",amount)) \(fromCurrency) = \(toCurrency)")
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.horizontal)
                            }
                            
                        }
                        .padding()
                        Spacer()
                    }
                    Divider()
                        .padding(.top)
                        .padding(.horizontal,30)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Last Updated On")
                                .opacity(0.7)
                                .padding(.top, 2)
                                .padding(.horizontal)
                                .font(.system(size: 20))
                                
                            if let converter = converterViewModel.converter{
                                if let (date, time) = extractDateAndTime(from: converter.lastUpdate){
                                    
                                    Text("\(date)")
                                        .font(.system(size: 24, weight: .bold))
                                        .padding(.horizontal)
                                        .padding(.top, 1)
                                    Text("\(time)")
                                        .font(.system(size: 24, weight: .bold))
                                        .padding(.horizontal)
                                        .padding(.bottom, 30)
                                        
                                }
                            }else{
                                Text("hello")
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.horizontal)
                                    .padding(.top, 1)
                                    .opacity(0)
                                Text("")
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.horizontal)
                                    .padding(.bottom, 30)
                                    .opacity(0)
                            }
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
        
    }
}

func extractDateAndTime(from dateString: String) -> (String, String)? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
    print(dateFormatter.string(from: date))
        
        return (dateFormatter.string(from: date), timeFormatter.string(from: date))
    }

#Preview {
    CurrencyConverterView()
}
