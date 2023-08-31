//
//  TestView.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/01.
//

import SwiftUI

struct TestView: View {
    let colors: [Color] = [.purple, .pink, .orange]
    @State private var selection: Color? = nil // Nothing selected by default.
    
    
    var body: some View {
        NavigationSplitView {
            List(colors, id: \.self, selection: $selection) { color in
                NavigationLink(color.description, value: color)
            }
        } detail: {
            if let color = selection {
//                ColorDetail(color: color)
                Rectangle()
                    .foregroundColor(color)
            } else {
                Text("Pick a color")
            }
        }
    }

}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
