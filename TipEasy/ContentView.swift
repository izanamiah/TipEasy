//
//  ContentView.swift
//  TipEasy
//
//  Created by Jeremiah Liu on 3/4/23.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    @State private var postTaxAmount = 0.0
    @State private var tempPostTaxAmount : Double?
    @State private var preTaxAmount = 0.0
    @State private var tempPreTaxAmount : Double?
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 15
    @State private var isSpliting = false
    @State private var isPreTax = false
    @State private var isCustomTip = false
    @FocusState private var postTaxAmountIsFocused: Bool
    @FocusState private var preTaxAmountIsFocused: Bool
    @FocusState private var tipPercentageIsFocused: Bool
    
    let tipPercentages = [10,15,20,0]

    var taxAmount : Double{
        postTaxAmount - preTaxAmount
    }
    
    var tipAmount : Double {
        let tipSelection = Double(tipPercentage)
        let postTaxTipValue = postTaxAmount / 100 * tipSelection
        let preTaxTipValue = preTaxAmount / 100 * tipSelection;
        return isPreTax ? preTaxTipValue : postTaxTipValue
    }
    
    var grandTotal : Double {
        isPreTax ? preTaxAmount + tipAmount + taxAmount : postTaxAmount + tipAmount
    }
    
    var totalPerPerson : Double {
        let peopleCount = Double(numberOfPeople)
        let amountPerPerson = grandTotal / peopleCount
        return  amountPerPerson
    }

    var body: some View {
        NavigationView {
            Form {
                Section{
                    Toggle("Tip on Pre-Tax", isOn: $isPreTax)
                        .onChange(of: isPreTax){ value in
                            if !value {
                                preTaxAmount = 0.0
                                tempPreTaxAmount = nil
                            }
                        }
                    
                    VStack(spacing:1){
                        Text("Post-Tax (Required)")
                            .font(.system(size: 15.0))
          
                        TextField("Post-Tax Amount", value: $tempPostTaxAmount, format:
                                .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .multilineTextAlignment(.center)
                        .font(.system(size: 35, weight: .bold))
                        .keyboardType(.decimalPad)
                        .focused($postTaxAmountIsFocused)
                        
                        if isPreTax{
                            Divider().padding(.vertical,10)
                            Text("Pre-Tax")
                                .font(.system(size: 15.0))
                            TextField("Pre-Tax Amount", value: $tempPreTaxAmount, format:
                                    .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .multilineTextAlignment(.center)
                            .font(.system(size: 35, weight: .bold))
                            .keyboardType(.decimalPad)
                            .focused($preTaxAmountIsFocused)

                        }
                        
                        
                    }
            

                } header : {
                    Text("Check Info")
                } footer: {
                    
                    if preTaxAmount > postTaxAmount {
                        Text("Note: You are inputing a pre-tax amount that is greater than or equal to post-tax amout. Please check both numbers and input them correctly.")
                            .foregroundColor(.red)
//                            .font(.system(size: 13.0, weight: .semibold))
                    }
                }
                
        

                
                Section {
                    if !isCustomTip {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                    } else {
                        TextField("Amount", value: $tipPercentage, format: .percent)
                        .keyboardType(.decimalPad)
                        .focused($tipPercentageIsFocused)
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                    }
         
                    Toggle("Custom Percentage", isOn: $isCustomTip)
                    
                    HStack{
                        
                        Text(tipAmount, format:
                                .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size:20 , weight: .bold))
                        
                  

                        Text("Tip Total")
                            .font(.system(size: 13.0, weight: .bold))
                            .foregroundColor(.white)
                               .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                               .background(.indigo)
                               .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        
               
                    }
                   
                } header : {
                    Text("Tip")
                }
                
            
            
                Section{
                    
                    HStack{
                        Text(grandTotal, format:
                                .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 20, weight: .bold))
                        
                        Text("Grand Total")
                            .font(.system(size: 13.0, weight: .bold))
                            .foregroundColor(.white)
                               .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                               .background(.green)
                               .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    }
                  
                        
                } header : {
                    Text("Bill Total")
                }
                
                
                
                Section{
                    Toggle("Split Check", isOn: $isSpliting)
                    
                    if isSpliting {
                        Stepper("Among  **\(numberOfPeople.formatted())**",value: $numberOfPeople, in: 2...15, step: 1)
                        HStack{
                            Text(totalPerPerson, format:
                                    .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.system(size: 20, weight: .bold))
                            
                            Text("Per Person")
                                .font(.system(size: 13.0, weight: .bold))
                                .foregroundColor(.white)
                                   .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                                   .background(.gray)
                                   .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }
                    }
                    
                   
                } header : {
                    Text("Split")
                }
                
                
                
            }
            
            .navigationTitle("TipEasy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Confirm"){
                            postTaxAmount = tempPostTaxAmount ?? 0.0
                            preTaxAmount = tempPreTaxAmount ?? 0.0
                            postTaxAmountIsFocused = false
                            preTaxAmountIsFocused = false
                            tipPercentageIsFocused = false
                    }
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
