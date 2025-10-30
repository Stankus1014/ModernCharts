//
//  IndicatorPoint.swift
//  ModernCharts
//
//  Created by William Stankus on 10/25/25.
//

import SwiftUI

struct IndicatorPoint: View {
    @Environment(\.modernChartStyle) private var style
    
    var body: some View {
        ZStack{
            Circle()
                .fill(style.indicatorKnob)
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
        }
        .frame(width: 14, height: 14)
        .shadow(color: style.legendTextColor, radius: 6, x: 0, y: 6)
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint()
    }
}
