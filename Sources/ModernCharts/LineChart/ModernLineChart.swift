//
//  ModernLineChart.swift
//  ModernCharts
//
//  Created by William Stankus on 11/1/25.
//

import SwiftUI

public struct ModernLineChart: View {
    
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
    private var xAxisLabelFormat: XAxisLabelFormat
    
    public init(
        data: Binding<ChartData>,
        hideHorizontalLines: Bool = false,
        chartHeight: CGFloat,
        xAxisPadding: CGFloat = 20,
        yAxisPadding: CGFloat = 10,
        yAxisWidth: CGFloat = 50,
        xAxisHeight: CGFloat = 14,
        valueSpecifier: String = "%.2f",
        numXLabels: Int = 7,
        xAxisLabelFormat: XAxisLabelFormat = .day
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
        self.xAxisLabelFormat = xAxisLabelFormat
    }
    
    public var body: some View {
        if self.data.dataPoints.count == 0 {
            NoLineChartData(message: "No data to display")
        } else {
            LineChart(
                data: $data,
                hideHorizontalLines: hideHorizontalLines,
                chartHeight: chartHeight,
                xAxisPadding: xAxisPadding,
                yAxisPadding: yAxisPadding,
                yAxisWidth: yAxisWidth,
                xAxisHeight: xAxisHeight,
                valueSpecifier: valueSpecifier,
                numXLabels: numXLabels,
                xAxisLabelFormat: xAxisLabelFormat
            )
        }
    }
    
}

#Preview {
    ModernLineChart(
        data: .constant(ChartData(dataPoints: PreviewData.weekOfBodyweight)),
        chartHeight: 300.0,
        valueSpecifier: "%.1f",
        xAxisLabelFormat: .dayOfWeek
    )
}
