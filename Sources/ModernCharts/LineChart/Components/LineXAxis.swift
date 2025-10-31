//
//  LineXAxis.swift
//  ModernCharts
//
//  Created by William Stankus on 10/26/25.
//

import SwiftUI

struct LineXAxis: View {
    @Binding var data: ChartData
    @Binding var currentlyDraggedIndex: Int
    var numberOfXAxisLabels: Int
    var labelFormat: XAxisLabelFormat

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let step = width / CGFloat(max(data.dataPoints.count - 1, 1))

            ZStack {
                ForEach(0..<self.calculateNumberOfLabels(), id: \.self) { index in
                    XAxisLabel(
                        currentlyDraggedIndex: self.$currentlyDraggedIndex,
                        date: self.data.getDate(index: index),
                        index: index,
                        xPosition: CGFloat(index) * step,
                        yPosition: proxy.size.height / 2,
                        labelFormat: labelFormat
                    )
                }
            }
            .frame(width: width, height: proxy.size.height)
        }
    }
    
    
    private func calculateNumberOfLabels() -> Int {
        
        return min(self.data.dataPoints.count, self.numberOfXAxisLabels)
        
    }
    
}

struct XAxisLabel: View {
    
    @Binding var currentlyDraggedIndex: Int
    
    var date: Date
    var index: Int
    var xPosition: CGFloat
    var yPosition: CGFloat
    var labelFormat: XAxisLabelFormat
    
    var body: some View {
        
        let font = (currentlyDraggedIndex == index) ? Font.headline.bold() : Font.caption
        
         Text(self.getXAxisLabel(date: date))
            .font(font)
            .position(
                x: xPosition,
                y: yPosition
            )
            .frame(maxWidth: .infinity)
    }
    
    private func getXAxisLabel(date: Date) -> String {
        
        let formatter = DateFormatter()
        
        switch self.labelFormat {
        case .dayOfWeek:
            formatter.dateFormat = "E"
        case .day:
            formatter.dateFormat = "d"
        case .month:
            formatter.dateFormat = "MMM"
        case .year:
            formatter.dateFormat = "yyyy"
        }
        
        return formatter.string(from: date)
    }
}

#Preview {
    LineXAxis(
        data: .constant(ChartData(dataPoints: PreviewData.weekOfBodyweight)),
        currentlyDraggedIndex: .constant(1),
        numberOfXAxisLabels: 7,
        labelFormat: .dayOfWeek
    )
        .frame(height: 20)
        .padding(50)
}


public enum XAxisLabelFormat {
    case dayOfWeek
    case day
    case month
    case year
}
