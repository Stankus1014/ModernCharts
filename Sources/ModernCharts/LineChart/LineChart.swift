//
//  LineGrid.swift
//  ModernCharts
//
//  Created by William Stankus on 10/26/25.
//

import SwiftUI

struct LineChart: View {
    
    @Binding var data: ChartData
    
    @State private var dragLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var indicatorLocation: CGPoint = .zero
    @State private var hideHorizontalLines: Bool = false
    @State private var currentDataNumber: Double = 0
    @State private var currentlyDraggedIndex: Int = -1
    @State private var opacity: Double = 0
    
    var chartHeight: CGFloat
    
    var xAxisPadding: CGFloat = 20
    var yAxisPadding: CGFloat = 10
    
    var yAxisWidth: CGFloat = 50
    var xAxisHeight: CGFloat = 14
    
    var valueSpecifier: String = "%.2f"
    
    var body: some View {
        VStack() {
            HStack(spacing: yAxisPadding) {
                LineYAxis(
                    data: $data,
                    valueSpecifier: valueSpecifier
                )
                    .frame(width: yAxisWidth)
                
                GeometryReader { proxy in
                    ZStack {
                        Lines(
                            data: $data,
                            hideHorizontalLines: self.$hideHorizontalLines
                        )
                        
                        Line(
                            data: self.data,
                            frame: .constant(
                                CGRect(
                                    x: 0,
                                    y: 0,
                                    width: proxy.size.width,
                                    height: proxy.size.height - 3 // @TODO Hook this up to a var & cascase downward
                                )
                            ),
                            touchLocation: self.$indicatorLocation,
                            showIndicator: self.$hideHorizontalLines,
                            minDataValue: .constant(nil),
                            maxDataValue: .constant(nil),
                            showBackground: false
                        )
                        .gesture(DragGesture()
                            .onChanged({ value in
                                
                                guard isDragInsideChartBounds(
                                    dragLocationX: value.location.x,
                                    frame: proxy.frame(in: .local)
                                ) else {
                                    return
                                }
                                
                                self.dragLocation = value.location
                                self.indicatorLocation = CGPoint(x: max(value.location.x,0), y: 32)
                                self.opacity = 1
                                self.closestPoint = self.getClosestDataPoint(
                                    toPoint: value.location,
                                    width: proxy.size.width,
                                    height: chartHeight
                                )
                                self.hideHorizontalLines = true
                            })
                                .onEnded({ value in
                                    self.opacity = 0
                                    self.currentlyDraggedIndex = -1
                                    self.hideHorizontalLines = false
                                })
                        )
                        MagnifierRect(
                            currentNumber: self.$currentDataNumber,
                            valueSpecifier: self.valueSpecifier
                        )
                            .frame(height: proxy.size.height)
                            .opacity(self.opacity)
                            .offset(
                                x: self.getMagnifierXOffset(containerWidth: proxy.size.width),
                                y: 14
                            )
                    }
                }
            }
            .frame(height: chartHeight)
            .padding(.trailing, 20)
            LineXAxis(
                data: $data,
                currentlyDraggedIndex: self.$currentlyDraggedIndex,
                numberOfXAxisLabels: 7,
                labelFormat: .dayOfWeek
            )
                .frame(height: xAxisHeight)
                .padding(.top, xAxisPadding)
                .padding(.leading, yAxisWidth + yAxisPadding)
                .padding(.trailing, 20)
        }
        
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
        let values = self.data.values()
        guard values.count > 1 else { return .zero }

        let stepWidth = width / CGFloat(values.count - 1)
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 1
        let range = maxValue - minValue
        let stepHeight = height / CGFloat(range == 0 ? 1 : range)

        // Estimate index based on x
        let index = Int(round(toPoint.x / stepWidth))
        self.currentlyDraggedIndex = index

        guard index >= 0 && index < values.count else { return .zero }

        self.currentDataNumber = values[index]

        // Invert Y so higher values appear higher on screen
        let x = CGFloat(index) * stepWidth
        let y = height - CGFloat(values[index] - minValue) * stepHeight

        return CGPoint(x: x, y: y)
    }
    
    func getMagnifierXOffset(containerWidth: CGFloat) -> CGFloat {
        return self.dragLocation.x + (-containerWidth / 2)
    }
    
    func isDragInsideChartBounds(dragLocationX: CGFloat, frame: CGRect) -> Bool {
        if dragLocationX < frame.minX || dragLocationX > frame.maxX {
            return false
        }
        
        return true
    }
}

#Preview {
    LineChart(
        data: .constant(ChartData(dataPoints: PreviewData.weekOfBodyweight)),
        chartHeight: 300.0,
        valueSpecifier: "%.1f"
    )
    .padding(20)
}
