//
//  LineYAxis.swift
//  ModernCharts
//
//  Created by William Stankus on 10/30/25.
//
import SwiftUI

struct LineYAxis: View {
    @Environment(\.modernChartStyle) private var style
    @Binding var data: ChartData
    
    let valueSpecifier: String
    private let padding: CGFloat = 3
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                let numLabels = self.calculateNumberOfYLabels()
                ForEach(0...numLabels - 1, id: \.self) { index in
                    
                    if (numLabels == 1) {
                        Spacer()
                    }
                    
                    Text("\(self.getYLegendSafe(height: index), specifier: valueSpecifier)")
                        .font(.caption)
                        .foregroundColor(style.legendTextColor)
                    
                    if (index != numLabels - 1 || numLabels == 1) {
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func calculateNumberOfYLabels() -> Int {
        switch self.data.dataPoints.count {
        case 0, 1:
            return 1
        default:
            let range = calculateRange()
            
            if range > 0.5 {
                return 5
            } else if range > 0.3 {
                return 3
            } else {
                return 2
            }
        }
    }
    
    private func calculateRange() -> Double {
        guard let max = self.data.values().max(),
              let min = self.data.values().min() else { return 0 }
        return abs(max - min)
    }
    
    private func getYLegendSafe(height: Int) -> CGFloat {
        if let legend = getYLegend(), height < legend.count {
            return CGFloat(legend[height])
        }
        return 0
    }
    
    private func getYLegend() -> [Double]? {
        let points = self.data.values()
        guard let max = points.max(), let min = points.min() else { return nil }
        let step = Double(max - min) / 4
        let labels = stride(from: 0, through: 4, by: 1).map { min + step * Double($0) }
        return labels.sorted { lhs, rhs in
            lhs > rhs
        }
    }
    
}

#Preview {
    LineYAxis(
        data: .constant(ChartData(dataPoints: PreviewData.twoDatapoints)),
        valueSpecifier: "%.1f",
    )
        .frame(height: 400)
}
