//
//  ContentView.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    
    @State var appleColorCollections: [AppleColorCollection] = []
    @State var selectedAppleColorCollection: AppleColorCollection?
    
    var body: some View {    
        NavigationSplitView {
            List(appleColorCollections, selection: $selectedAppleColorCollection) { apppleColorCollection in
                NavigationLink(value: apppleColorCollection) {
                    Text(apppleColorCollection.title)
                }
            }
        } detail: {
            if let selectedAppleColorCollection {
                Text(selectedAppleColorCollection.title)
            } else {
                Text("Pick a color")
            }
        }
        .onAppear() {
            self.appleColorCollections = loadJson()
        }
    }
    
    private func loadJson() -> [AppleColorCollection] {
        guard
            let resourceURL = Bundle.main.resourceURL,
            let jsonFiles = try? FileManager.default.contentsOfDirectory(atPath: resourceURL.path).filter({ $0.hasSuffix(".json") }),
            jsonFiles.count > 0
            else {
            return []
        }
        
        var colorCollections: [AppleColorCollection] = []
        let jsonFileURLs = jsonFiles.map { resourceURL.appendingPathComponent($0) }
        for jsonFileURL in jsonFileURLs {
            guard let jsonString = try? String(contentsOf: jsonFileURL),
                  let jsonData = jsonString.data(using: .utf8),
                  let colorCollection = try? JSONDecoder().decode(AppleColorCollection.self, from: jsonData)
            else {
                return []
            }
            colorCollections.append(colorCollection)
        }
        
        return colorCollections
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
