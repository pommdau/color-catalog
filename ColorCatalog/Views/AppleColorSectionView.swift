//
//  AppleColorSectionView.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/01.
//

import SwiftUI

struct AppleColorSectionView: View {
    
    let section: AppleColorSection
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(section.title)
                .font(.title3)
            List(section.colors) { color in
                HStack {
                    Circle()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(nsColor: NSColor.systemName(color.title) as? NSColor ?? NSColor.red))
                    Text(color.title)
                    Badge(isDeprecated: color.isDeprecated,
                          isBeta: color.isBeta)
                }
                .background(Color(nsColor: .windowBackgroundColor))
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

struct AppleColorSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppleColorSectionView(section: AppleColorSection.sampleData.first!)
    }
}
