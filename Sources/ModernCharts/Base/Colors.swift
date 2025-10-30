//
//  Colors.swift
//  ModernCharts
//
//  Created by William Stankus on 10/25/25.
//

import Foundation
import SwiftUI

public struct ModernChartColor: Sendable {
    var startColor: Color
    var endColor: Color
    
    func getGradient() -> Gradient {
        return Gradient(colors: [startColor, endColor])
    }
}

public enum DefaultModernChartColors {
    
    case orange
    
    public var value: ModernChartColor {
        switch self {
        case .orange:
            return ModernChartColor(startColor: ChartColors.orangeStart, endColor: ChartColors.orangeEnd)
        }
    }
    
}

struct ChartColors {
    static let orangeStart: Color = Color(hexString: "#EC2301")
    static let orangeEnd: Color = Color(hexString: "#FF782C")
}

extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
