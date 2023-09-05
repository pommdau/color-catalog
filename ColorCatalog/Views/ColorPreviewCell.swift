//
//  ColorPreviewCell.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/05.
//

import SwiftUI

extension ColorPreviewCell {
    
    private struct FirstTriangle: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.closeSubpath()
            }
        }
    }
    
    private struct SecondTriangle: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.closeSubpath()
            }
        }
    }
    
}

struct ColorPreviewCell: View {
    
    let appleColor: AppleColor
    
    var colors: [Color] {
        if let nsColor = NSColor.systemName(appleColor.title) as? NSColor {
            return [Color(nsColor: nsColor)]
        } else if let nsColors = NSColor.systemName(appleColor.title) as? [NSColor] {
            return nsColors.map { Color(nsColor: $0) }
        } else {
            return [.clear]
        }
    }
    
    var body: some View {
        
        if appleColor.isBeta {
            betaIcon()
        } else {
            colorPreview()
        }
    }
    
    @ViewBuilder
    private func betaIcon() -> some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(Color(nsColor: .systemYellow))
            .frame(width: 50, height: 16, alignment: .center)
            .help("Can't preview the beta color")
    }
    
    @ViewBuilder
    private func colorPreview() -> some View {
        ZStack {
            Color(nsColor: .controlBackgroundColor)
                .padding(-4)
                .zIndex(-1)
            switch colors.count {
            case 1:
                Rectangle()
                    .foregroundColor(colors[0])
            case 2:
                ZStack {
                    FirstTriangle()
                        .fill(colors[0])
                    SecondTriangle()
                        .fill(colors[1])
                }
            default:
                fatalError()
            }
        }
    }
}

#Preview {
    ColorPreviewCell(appleColor: AppleColor.sampleData.first!)
        .padding()
}

#Preview("colors.count == 2") {
    ColorPreviewCell(appleColor: .init(title: "alternatingContentBackgroundColors",
                                       descriptions: [], type: "",
                                       isDeprecated: false,
                                       isBeta: false,
                                       link: ""))
        .padding()
}

#Preview("isBeta") {
    ColorPreviewCell(appleColor: .init(title: "",
                                       descriptions: [], type: "",
                                       isDeprecated: false,
                                       isBeta: true,
                                       link: ""))
        .padding()
}
