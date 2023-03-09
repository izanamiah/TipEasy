//
//  BarChartView.swift
//  TipEasy
//
//  Created by Jeremiah Liu on 3/8/23.
//

import SwiftUI
import Charts

struct BarChartView: View {
    

    let data: [test] = [
        test(value: 70, category: "PreTax"),
        test(value: 10, category: "Tip"),
        test(value: 20, category: "tax"),
    ]
   
    
    var body: some View {
        
        Form{
            Section{
                Chart(data) {
                    BarMark(x: .value("value", $0.value))
                    .foregroundStyle(by: .value("category", $0.category))
                }
            }
        }
    }
}


struct test : Identifiable{
    var id = UUID()
    let value: Double
    let category: String
}



struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView()
    }
}
