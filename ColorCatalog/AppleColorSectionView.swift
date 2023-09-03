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
        VStack {
            Text(section.title)
            List(section.colors) { color in
                VStack(alignment: .leading) {
//                    Rectangle()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(Color(nsColor: NSColor(name: color.title)))
//                        .foregroundColor(createColor(withTitle: color.title))
                    HStack {
                        Text(color.title)
                        Text("\(color.isDeprecated ? "Dep" : "OK")")
                    }
                    
//                    Text(color.link)
                }
            }
        }
    }
    
    func createColor(withTitle title: String) -> Color {
//        guard let nsColor = NSColor(named: NSColor.Name(title)) else {
//            return .clear
//        }
//        print(NSColor.labelColor.colorNameComponent)
        if let nsColor = NSColor(named: NSColor.Name("labelColor")) {
            return Color(nsColor: nsColor)
        }
        
        return .red
    }
}

struct AppleColorSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppleColorSectionView(section: AppleColorSection.sampleData.first!)
    }
}
