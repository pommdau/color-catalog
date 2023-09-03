//
//  Badge.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/03.
//

import SwiftUI

struct Badge: View {
    @State private var size: CGSize = .zero
    let isDeprecated: Bool
    let isBeta: Bool
    
    var text: String {
        if isDeprecated {
            return "Deprecated"
        } else if isBeta {
            return "Beta"
        } else {
            return " "
        }
    }
    
    var color: Color {
        if isDeprecated {
            return Color(nsColor: .systemRed.blended(withFraction: 0.3, of: .black)!)
        } else if isBeta {
            return Color(nsColor: .systemGreen.blended(withFraction: 0.3, of: .black)!)
        } else {
            return .clear
        }
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .lineLimit(1)
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .overlay(
                RoundedRectangle(cornerRadius: size.height / 2)
                    .stroke(color)
                    .frame(width: size.width, height: size.height)
            )
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
    
    init(isDeprecated: Bool = false, isBeta: Bool = false) {
        self.isDeprecated = isDeprecated
        self.isBeta = isBeta
    }
}

#Preview {
    Badge(isDeprecated: true)
        .padding()
}

#Preview {
    Badge(isBeta: true)
        .padding()
}

#Preview {
    Badge()
        .padding()
}
