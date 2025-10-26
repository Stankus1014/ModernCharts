//
//  ChartStyles.swift
//  ModernCharts
//
//  Created by William Stankus on 10/25/25.
//
import Foundation
import SwiftUI

public struct ModernChartStyle: Sendable {
    public var backgroundColor: Color
    public var chartColor: ModernChartColor
    public var textColor: Color
    public var legendTextColor: Color
    public var dropShadowColor: Color
    
    public var indicatorKnob: Color
    
    // @TODO: Add Support Later
    //public weak var darkModeStyle: ModernChartStyle?
    
    public init(backgroundColor: Color, chartColor: ModernChartColor, textColor: Color, legendTextColor: Color, dropShadowColor: Color, indicatorKnob: Color) {
        self.backgroundColor = backgroundColor
        self.chartColor = chartColor
        self.textColor = textColor
        self.legendTextColor = legendTextColor
        self.dropShadowColor = dropShadowColor
        self.indicatorKnob = indicatorKnob
    }
}

public enum DefaultModernChartStyles {
    
    case orangeTheme
    
    public var style: ModernChartStyle {
            switch self {
            case .orangeTheme:
                return ModernChartStyle(
                    backgroundColor: .clear,
                    chartColor: DefaultModernChartColors.orange.value,
                    textColor: .black,
                    legendTextColor: .gray,
                    dropShadowColor: .gray,
                    indicatorKnob: Color(hexString: "#FF57A6")
                )
        }
    }
    
}
