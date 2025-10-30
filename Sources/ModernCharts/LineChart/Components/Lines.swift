//
//  Lines.swift
//  ModernCharts
//
//  Created by William Stankus on 10/26/25.
//
import SwiftUI

struct Lines: View {
    @Environment(\.modernChartStyle) private var style
    @Binding var data: ChartData
    @Binding var hideHorizontalLines: Bool
    let padding: CGFloat = 3
    
    var stepHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            let stepHeight = self.computeStepHeight(frame: frame)
            let minValue = CGFloat(self.data.values().min() ?? 0)
            
            ZStack {
                ForEach(0...4, id: \.self) { height in
                    let yValue = self.getYLegendSafe(height: height)
                    self.line(atHeight: yValue, width: frame.width, min: minValue, stepHeight: stepHeight)
                        .stroke(
                            style.legendTextColor,
                            style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, height == 0 ? 0 : 5])
                        )
                        .opacity((self.hideHorizontalLines && height != 0) ? 0 : 1)
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeOut(duration: 0.2), value: hideHorizontalLines)
                        .clipped()
                }
            }
        }
    }
}

extension Lines {
    private func computeStepHeight(frame: CGRect) -> CGFloat {
        let points = self.data.values()
        guard let min = points.min(), let max = points.max(), min != max else { return 0 }
        return (frame.size.height - padding) / CGFloat(max - min)
    }
    
    private func getYLegendSafe(height: Int) -> CGFloat {
        if let legend = getYLegend() {
            return CGFloat(legend[height])
        }
        return 0
    }
    
    private func getYLegend() -> [Double]? {
        let points = self.data.values()
        guard let max = points.max(), let min = points.min() else { return nil }
        let step = Double(max - min) / 4
        return [min + step * 0, min + step * 1, min + step * 2, min + step * 3, min + step * 4]
    }
    
    private func line(atHeight: CGFloat, width: CGFloat, min: CGFloat, stepHeight: CGFloat) -> Path {
        var path = Path()
        let y = (atHeight - min) * stepHeight
        path.move(to: CGPoint(x: 5, y: y))
        path.addLine(to: CGPoint(x: width, y: y))
        return path
    }
}

#Preview {
    Lines(
        data: .constant(ChartData(dataPoints: PreviewData.weekOfBodyweight)),
        hideHorizontalLines: .constant(false)
    )
        .frame(height: 400)
}
