//
//  AppleColorSectionView.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/01.
//

import SwiftUI

struct AppleColorSectionView: View {
    
    @AppStorage("selected-description-language") var selectedDescriptionLaguage: String = "en"
    @AppStorage("selected-appearance") var selectedAppearance: String = "system"
    @AppStorage("searching-keyword") var searchingKeyword: String = ""
    
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
                Text(color.descriptions[1].description)
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
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Picker("Description Language", selection: $selectedDescriptionLaguage) {
                    Text("English").tag("en")
                    Text("Japanese").tag("ja")
                }
                .frame(width: 100)
                Picker("Appearance", selection: $selectedAppearance) {
                    Text("System").tag("system")
                    Text("Light").tag("aqua")
                    Text("Dark").tag("dark")
                }
                .frame(width: 100)
            }
        }
    }
}

struct AppleColorSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppleColorSectionView(section: AppleColorSection.sampleData[1])
    }
}
