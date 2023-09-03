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
        
        Table(section.colors) {
            TableColumn("") { color in
                if color.isBeta {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Color(nsColor: .systemYellow))
                        .frame(width: 16, height: 16)
                        .help("Can't preview the beta color")
                } else {
                    ZStack {
                        Color(nsColor: .controlBackgroundColor)
                            .padding(-4)
                        Circle()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color(nsColor: NSColor.systemName(color.title) as? NSColor ?? NSColor.clear))
                    }
                }
            }
            .width(min: 0, ideal: 20, max: 20)
            TableColumn("Name") { color in
                Text(color.title)
            }
            TableColumn("Description") { color in
                Text(color.descriptions.first!.description)
            }
            TableColumn("Status") { color in
                Badge(isDeprecated: color.isDeprecated, isBeta: color.isBeta)
                    .padding(.horizontal)
            }
            .width(min: 0, ideal: 110, max: 110)
            
            TableColumn("Apple Page") { color in
                Button("Link") {
                    NSWorkspace.shared.open(URL(string: color.link)!)
                }
                .buttonStyle(.link)
            }
            .width(min: 0, ideal: 100, max: 100)
        }
        
        /*
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
         */
    }
}

struct AppleColorSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppleColorSectionView(section: AppleColorSection.sampleData[1])
    }
}
