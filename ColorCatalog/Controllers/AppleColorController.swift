//
//  AppleColorController.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/04.
//

import Foundation
import Combine
import SwiftUI

class AppleColorController: ObservableObject {
        
    // MARK: - Properties
    
    @Published var appleColorCollections: [AppleColorCollection]
    @Published var selectedSection: AppleColorSection
    @Published var searchingKeyword: String
    
    var selectedSectionColors: [AppleColor] {
        if searchingKeyword.isEmpty {
            return selectedSection.colors
        }
        
        return selectedSection.colors.compactMap { color in
            if color.title.lowercased().contains(searchingKeyword.lowercased()) {
                return color
            }
            return nil
        }
    }
    
    // MARK: - LifeCycle
    
    init() {
        let appleColorCollections = Self.loadJson()
        self.appleColorCollections = Self.loadJson()
        self.selectedSection = appleColorCollections.first!.sections.first!
        self.searchingKeyword = ""
    }
    
    // MARK: - Helpers
    
    private static func loadJson() -> [AppleColorCollection] {
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
        colorCollections.sort { first, second in
            first.title > second.title
        }
        colorCollections.insert(createAllAppleColorSection(collections: colorCollections), at: 0)
        
        return colorCollections
    }
    
    private static func createAllAppleColorSection(collections: [AppleColorCollection]) -> AppleColorCollection {
        
        var allColors: [AppleColor] = []
        for collection in collections {
            for section in collection.sections {
                allColors += section.colors
            }
        }
        
        return AppleColorCollection(
            title: "All",
            sections: [
                AppleColorSection(title: "All Colors", colors: allColors)
            ])
    }
}
