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
        .init(language: "en", description: "The primary color to use for text labels."),
        .init(language: "ja", description: "日本語訳が入るよ")
    ]
}

struct AppleColor: Codable, Identifiable, Hashable {
    var id: String { title }
    let title: String
    let descriptions: [AppleColorDesctiption]
    let type: String  // "NSColor"
    let isDeprecated: Bool
    let isBeta: Bool
    let link: String
    
    enum CodingKeys: String, CodingKey {
//        case id
        case title
        case descriptions
        case type
        case isDeprecated = "is_deprecated"
        case isBeta = "is_beta"
        case link
    }
    
    static let sampleData: [AppleColor] = [
        .init(title: "labelColor",
              descriptions: AppleColorDesctiption.sampleData,
              type: "NSColor",
              isDeprecated: false,
              isBeta: false,
              link: "https://developer.apple.com/documentation/appkit/nscolor/1534657-labelcolor"),
        .init(title: "secondaryLabelColor",
              descriptions: AppleColorDesctiption.sampleData,
              type: "NSColor",
              isDeprecated: false,
              isBeta: false,
              link: "https://developer.apple.com/documentation/appkit/nscolor/1533254-secondarylabelcolor")
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
