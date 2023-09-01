//
//  AppleColorCollection.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/01.
//

import Foundation

struct AppleColorDesctiption: Codable, Identifiable, Hashable {
    var id: String { language }
    let language: String
    let description: String
    
    static let sampleData: [AppleColorDesctiption] = [
        .init(language: "en", description: "English Sample"),
        .init(language: "ja", description: "Japanese Sample")
    ]
}

struct AppleColor: Codable, Identifiable, Hashable {
    var id: String { title }
    let title: String
    let descriptions: [AppleColorDesctiption]
    let link: String
    
    static let sampleData: [AppleColor] = [
        .init(title: "Sample AppleColor1",
              descriptions: AppleColorDesctiption.sampleData,
              link: "https://sample"),
        .init(title: "Sample AppleColor2",
              descriptions: AppleColorDesctiption.sampleData,
              link: "https://sample")
    ]
}

struct AppleColorSection: Codable, Identifiable, Hashable {
    var id: String { title }
    let title: String
    let colors: [AppleColor]
    
    static let sampleData: [AppleColorSection] = [
        .init(title: "SampleSection1",
              colors: AppleColor.sampleData),
        .init(title: "SampleSection2",
              colors: AppleColor.sampleData)
    ]
}

struct AppleColorCollection: Codable, Identifiable, Hashable {
    var id: String { title }
    let title: String
    let sections: [AppleColorSection]
}
