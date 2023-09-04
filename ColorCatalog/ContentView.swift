//
//  ContentView.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var appleColorController = AppleColorController()
    
    @AppStorage("selected-description-language") var selectedDescriptionLaguage: String = "en"
    @AppStorage("selected-appearance") var selectedAppearance: String = "system"
    @AppStorage("searching-keyword") var searchingKeyword: String = Appearance.allCases.first?.rawValue ?? ""
    
    var body: some View {
        NavigationSplitView {
            List(selection: $appleColorController.selectedSection) {
                ForEach(appleColorController.appleColorCollections) { collection in
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
            AppleColorSectionView(section: appleColorController.selectedSection)
                .navigationTitle(appleColorController.selectedSection.title)
//            .navigationSubtitleappleColorController(appleColorController.selectedSection == nil ? "" : "\(appleColorController.selectedSection!.colors.count) Colors")
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Picker("Description Language", selection: $selectedDescriptionLaguage) {
                    Text("English").tag("en")
                    Text("Japanese").tag("ja")
                }
                .frame(width: 100)
                Picker("Appearance", selection: $selectedAppearance) {
                    ForEach(Appearance.allCases) { appearance in
                        Text(appearance.rawValue).tag(appearance.rawValue)
                    }
                }
                .frame(width: 100)
            }
        }
        .searchable(text: $searchingKeyword, prompt: "Search")
        .onSubmit {
            print(searchingKeyword)
        }
        .onChange(of: selectedAppearance) { newValue in
            // TODO:
        }
        .onChange(of: searchingKeyword) { newValue in
            print(searchingKeyword)
        }
        .onAppear() {

        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
