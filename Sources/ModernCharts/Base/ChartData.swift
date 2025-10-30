//
//  ChartData.swift
//  ModernCharts
//
//  Created by William Stankus on 10/25/25.
//
import SwiftUI
import Foundation

public class ChartData: ObservableObject, Identifiable {
    @Published var dataPoints: ModernChartDataPoints
    var ID = UUID()
    
    public init(dataPoints: ModernChartDataPoints) {
        self.dataPoints = dataPoints
    }
    
    public func values() -> [Double] {
        return self.dataPoints.map{ $0.1 }
    }
    
    func getDate(index: Int) -> Date {
        return self.dataPoints[index].0
    }
}

public class DatapointSynthezier {
    
    private var properties: SynthezierProperties
    
    public init(properties: SynthezierProperties) {
        self.properties = properties
    }
    
    public func createDataPoints(dates: [Date], values: [Double]) -> ChartData {
        return createDataPoints(data: Array(zip(dates, values)))
    }
    
    public func createDataPoints(data: [(Date, Double)]) -> ChartData {
        return ChartData(dataPoints: self.sortData(data: data))
    }
    
    private func sortData(data: [(Date, Double)]) -> [(Date, Double)] {
        
        if self.properties.ascendingDates {
            return data.sorted { lhs, rhs in
                lhs.0 < rhs.0
            }
        } else {
            return data.sorted { lhs, rhs in
                lhs.0 > rhs.0
            }
        }
        
    }
    
}

public struct SynthezierProperties {
    var fillAllXAxisLabels: Bool = true
    var ascendingDates: Bool = true
    
    public init(fillAllXAxisLabels: Bool, ascendingDates: Bool) {
        self.fillAllXAxisLabels = fillAllXAxisLabels
        self.ascendingDates = ascendingDates
    }
}


// String: X-Axis Label
// Double: Y-Axis Value
public typealias ModernChartDataPoints = [(Date, Double)]
