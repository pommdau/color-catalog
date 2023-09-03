//
//  ContentView.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    
    @State var appleColorCollections: [AppleColorCollection] = []
    @State var selectedSection: AppleColorSection?
    
    @AppStorage("selected-description-language") var selectedDescriptionLaguage: String = "en"
    @AppStorage("selected-appearance") var selectedAppearance: String = "system"
    @AppStorage("searching-keyword") var searchingKeyword: String = ""
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSection) {
                ForEach(appleColorCollections) { collection in
                    Section(collection.title) {
                        ForEach(collection.sections) { section in
                            NavigationLink(value: section) {
                                Text(section.title)
                            }
                        }
                    }
                }
            }
        } detail: {
            Group {
                if let selectedSection {
                    AppleColorSectionView(section: selectedSection)
                } else {
                    Text("Pick a color")
                }
            }
            .navigationTitle(selectedSection?.title ?? "Color Catalog")
            .navigationSubtitle(selectedSection == nil ? "" : "\(selectedSection!.colors.count) Colors")
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
        .searchable(text: $searchingKeyword, prompt: "Search")
        .onSubmit {
            print(searchingKeyword)
        }
        .onAppear() {
            self.appleColorCollections = loadJson()
            if let selectedSection = appleColorCollections.first?.sections.first {
                self.selectedSection = selectedSection
            }
        }
        .onChange(of: selectedAppearance) { newValue in
            // TODO:
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
        
        return colorCollections.sorted { first, second in
            first.title > second.title
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
