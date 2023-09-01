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
        Text(section.title)
    }
}

struct AppleColorSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AppleColorSectionView(section: AppleColorSection.sampleData.first!)
    }
}
