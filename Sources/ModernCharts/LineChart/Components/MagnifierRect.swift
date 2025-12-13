//
//  MagnifierRect.swift
//  ModernCharts
//
//  Created by William Stankus on 10/25/25.
//

import SwiftUI

struct MagnifierRect: View {
    @Binding var currentNumber: Double
    var valueSpecifier:String
    
    @Environment(\.modernChartStyle) private var style: ModernChartStyle
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        ZStack{
            Text("\(self.currentNumber, specifier: valueSpecifier)")
                .font(.system(size: 18, weight: .bold))
                .offset(x: 0, y:-110)
                .foregroundColor(style.textColor)
        }
        .offset(x: 0, y: -15)
    }
}
