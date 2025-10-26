//
//  Theme.swift
//  ModernCharts
//
//  Created by William Stankus on 10/26/25.
//
import SwiftUI

private struct ModernChartStyleKey: EnvironmentKey {
    static let defaultValue: ModernChartStyle = DefaultModernChartStyles.orangeTheme.style
}

public extension EnvironmentValues {
    var modernChartStyle: ModernChartStyle {
        get { self[ModernChartStyleKey.self] }
        set { self[ModernChartStyleKey.self] = newValue }
    }
}

public extension View {
    func modernChartStyle(_ style: ModernChartStyle) -> some View {
        environment(\.modernChartStyle, style)
    }
}
