//
//  LineYAxis.swift
//  ModernCharts
//
//  Created by William Stankus on 10/26/25.
//
import SwiftUI

struct LineYAxis: View {
    @Environment(\.modernChartStyle) private var style
    @Binding var data: ChartData
    
    let valueSpecifier: String
    private let padding: CGFloat = 3
    
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            let stepHeight = self.computeStepHeight(frame: frame)
            let min = CGFloat(self.data.values().min() ?? 0)
            
            ZStack() {
                ForEach(0...4, id: \.self) { index in
                    Text("\(self.getYLegendSafe(height: index), specifier: valueSpecifier)")
                        .font(.caption)
                        .foregroundColor(style.legendTextColor)
                        .position(
                            x: frame.width / 2,
                            y: frame.height - self.getYposition(index: index, min: min, stepHeight: stepHeight)
                        )
                }
            }
        }
        
    }
    
    // MARK: - Helpers
    
    private func computeStepHeight(frame: CGRect) -> CGFloat {
        let points = self.data.values()
        guard let min = points.min(), let max = points.max(), min != max else { return 0 }
        return (frame.height - padding) / CGFloat(max - min)
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
        return stride(from: 0, through: 4, by: 1).map { min + step * Double($0) }
    }
    
    private func getYposition(index: Int, min: CGFloat, stepHeight: CGFloat) -> CGFloat {
        let value = getYLegendSafe(height: index)
        return (value - min) * stepHeight
    }
}

#Preview {
    LineYAxis(
        data: .constant(ChartData(dataPoints: PreviewData.weekOfBodyweight)),
        valueSpecifier: "%.2f",
    )
        .frame(height: 400)
}
