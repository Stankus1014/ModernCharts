//
//  LineXAxis.swift
//  ModernCharts
//
//  Created by William Stankus on 10/31/25.
//

import SwiftUI

struct LineXAxis: View {
    @Binding var data: ChartData
    @Binding var currentlyDraggedIndex: Int
    var numberOfXAxisLabels: Int
    var labelFormat: XAxisLabelFormat

    var body: some View {
        GeometryReader { proxy in
            HStack {
                let numXAxisLabels = self.calculateNumberOfLabels()
                ForEach(0..<numXAxisLabels, id: \.self) { index in
                    XAxisLabelDynamic(
                        currentlyDraggedIndex: self.$currentlyDraggedIndex,
                        date: self.data.getDate(index: index),
                        index: index,
                        labelFormat: labelFormat
                    )
                    
                    if index != numXAxisLabels - 1 {
                        Spacer()
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    
    private func calculateNumberOfLabels() -> Int {
        
        return min(self.data.dataPoints.count, self.numberOfXAxisLabels)
        
    }
    
}

struct XAxisLabelDynamic: View {
    
    @Binding var currentlyDraggedIndex: Int
    
    var date: Date
    var index: Int
    var labelFormat: XAxisLabelFormat
    
    var body: some View {
        
        let font = (currentlyDraggedIndex == index) ? Font.headline.bold() : Font.caption
        
         Text(self.getXAxisLabel(date: date))
            .font(font)
    }
    
    private func getXAxisLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = self.labelFormat.dateFormat
        return formatter.string(from: date)
    }
}

public enum XAxisLabelFormat {
    case dayOfWeek
    case day
    case month
    case year
    case custom(format: String)
}

extension XAxisLabelFormat {
    var dateFormat: String {
        switch self {
        case .dayOfWeek: return "E"
        case .day: return "d"
        case .month: return "MMM"
        case .year: return "yyyy"
        case .custom(let format): return format
        }
    }
}

#Preview {
    LineXAxis(
        data: .constant(ChartData(dataPoints: PreviewData.twoDatapoints)),
        currentlyDraggedIndex: .constant(1),
        numberOfXAxisLabels: 2,
        labelFormat: .dayOfWeek
    )
    .frame(height: 14)
    .padding(20)
}

