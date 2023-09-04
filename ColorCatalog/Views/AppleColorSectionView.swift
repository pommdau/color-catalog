//
//  AppleColorSectionView.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/01.
//

import SwiftUI

struct AppleColorSectionView: View {
           
    let colors: [AppleColor]
    let language: Language
    
    var body: some View {
        
        Table(colors) {
            TableColumn("") { color in
                if color.isBeta {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(nsColor: .systemYellow))
                        .frame(width: 50, height: 16, alignment: .center)
                        .help("Can't preview the beta color")
                } else {
                    ZStack {
                        Color(nsColor: .controlBackgroundColor)
                            .padding(-4)
                        Rectangle()
                            .frame(width: 42, height: 16)
                            .foregroundColor(Color(nsColor: NSColor.systemName(color.title) as? NSColor ?? NSColor.clear))
                    }
                }
            }
            .width(50)
            
            TableColumn("Name") { color in
                Text(color.title)
            }
            
            TableColumn("Description") { color in
                if let description = color.descriptions.first(where: { $0.language == language.code })?.description {
                    Text(description)
                } else {
                    Text("")
                }
            }
            
            TableColumn("Status") { color in
                AnnotationBadge(isDeprecated: color.isDeprecated, isBeta: color.isBeta)
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
    }
}

//struct AppleColorSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppleColorSectionView(colors: AppleColor.sampleData)
//    }
//}
