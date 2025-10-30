//
//  PreviewData.swift
//  ModernCharts
//
//  Created by William Stankus on 10/29/25.
//
import Foundation

class PreviewData {
    
    static var weekOfBodyweight: ModernChartDataPoints {
        let day1 = Date()
        let calendar = Calendar.current
        let day2 = calendar.date(byAdding: .day, value: -1, to: day1)
        let day3 = calendar.date(byAdding: .day, value: -2, to: day1)
        let day4 = calendar.date(byAdding: .day, value: -3, to: day1)
        let day5 = calendar.date(byAdding: .day, value: -4, to: day1)
        let day6 = calendar.date(byAdding: .day, value: -5, to: day1)
        let day7 = calendar.date(byAdding: .day, value: -6, to: day1)
        
        return [
            (day1, 212.21),
            (day2!, 213.12),
            (day3!, 212.82),
            (day4!, 213.22),
            (day5!, 213.92),
            (day6!, 213.52),
            (day7!, 213.22)
        ].reversed()
    }
    
}
