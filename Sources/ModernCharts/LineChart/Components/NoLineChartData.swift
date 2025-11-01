//
//  NoLineChartData.swift
//  ModernCharts
//
//  Created by William Stankus on 11/1/25.
//
import SwiftUI

struct NoLineChartData: View {
    @Environment(\.modernChartStyle) private var style: ModernChartStyle
    @State private var animate = false
    
    let message: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    style.chartColor.startColor.opacity(animate ? 0.25 : 0.15),
                    style.chartColor.endColor.opacity(animate ? 0.15 : 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: 150, height: 150)
            .ignoresSafeArea()
            .blur(radius: 50)
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
            
            VStack(spacing: 10) {
                Image(systemName: "chart.xyaxis.line")
                    .font(.system(size: 48))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(radius: 4)
                Text(message)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(radius: 4)
            }
        }
        .onAppear { animate = true }
    }
}

#Preview {
    NoLineChartData(message: "No data to display")
        .modernChartStyle(DefaultModernChartStyles.orangeTheme.style)
        .frame(width: 400, height: 400)
}
