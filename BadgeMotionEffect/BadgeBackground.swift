

import SwiftUI

struct BadgeBackground: View {
    
    @Binding var isShadow: Bool
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                var width = min(geometry.size.width, geometry.size.height)
                let height = width
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale

                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + HexagonParameters.adjustment)
                    )
                )

                HexagonParameters.segments.forEach { segment in
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )

                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
            }
//            .stroke(.red, lineWidth: 20)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Self.gradientStart, .orange, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0.2),
                endPoint: UnitPoint(x: 0.3, y: 0.6))
            )
            .shadow(color: .red, radius: isShadow ? 14 : 0)
            .shadow(color: .red.opacity(0.8), radius: isShadow ? 14 : 0)
            .shadow(color: .red.opacity(0.4), radius: isShadow ? 14 : 0)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    static let gradientStart = Color(red: 244 / 255, green: 68 / 255, blue: 102 / 255)
    static let gradientEnd = Color(red: 252 / 255, green: 232 / 255, blue: 82 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground(isShadow: .constant(false))
    }
}
