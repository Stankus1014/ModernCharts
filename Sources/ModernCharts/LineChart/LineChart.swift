//
//  LineGrid.swift
//  ModernCharts
//
//  Created by William Stankus on 10/26/25.
//

import SwiftUI

public struct LineChart: View {
    
    @Binding private var data: ChartData
    
    @State private var dragLocation: CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var indicatorLocation: CGPoint = .zero
    @State private var currentDataNumber: Double = 0
    @State private var currentlyDraggedIndex: Int = -1
    @State private var opacity: Double = 0
    
    @State private var hideHorizontalLines: Bool
    private var chartHeight: CGFloat
    private var xAxisPadding: CGFloat
    private var yAxisPadding: CGFloat
    private var yAxisWidth: CGFloat
    private var xAxisHeight: CGFloat
    private var valueSpecifier: String
    private var numXLabels: Int
    
    public init(
        data: Binding<ChartData>,
        hideHorizontalLines: Bool = false,
        chartHeight: CGFloat,
        xAxisPadding: CGFloat = 20,
        yAxisPadding: CGFloat = 10,
        yAxisWidth: CGFloat = 50,
        xAxisHeight: CGFloat = 14,
        valueSpecifier: String = "%.2f",
        numXLabels: Int = 7
    ) {
        self._data = data
        self.hideHorizontalLines = hideHorizontalLines
        self.chartHeight = chartHeight
        self.xAxisPadding = xAxisPadding
        self.yAxisPadding = yAxisPadding
        self.yAxisWidth = yAxisWidth
        self.xAxisHeight = xAxisHeight
        self.valueSpecifier = valueSpecifier
        self.numXLabels = numXLabels
    }
    
    public var body: some View {
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
                numberOfXAxisLabels: self.numXLabels,
                labelFormat: .dayOfWeek,
            )
                .frame(height: xAxisHeight)
                .padding(.top, xAxisPadding)
                .padding(.leading, yAxisWidth + yAxisPadding)
                .padding(.trailing, 20)
        }
        
    }
    
    private func getClosestDataPoint(toPoint: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
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
    
    private func getMagnifierXOffset(containerWidth: CGFloat) -> CGFloat {
        return self.dragLocation.x + (-containerWidth / 2)
    }
    
    private func isDragInsideChartBounds(dragLocationX: CGFloat, frame: CGRect) -> Bool {
        if dragLocationX < frame.minX || dragLocationX > frame.maxX {
            return false
        }
        
        return true
    }
}

#Preview {
    LineChart(
        data: .constant(ChartData(dataPoints: [(Date(),212.2)])),
        chartHeight: 300.0,
        valueSpecifier: "%.1f",
        numXLabels: 1
    )
    .padding(20)
}
