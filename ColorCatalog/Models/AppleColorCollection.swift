//
//  AppleColorCollection.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/01.
//

import Foundation

struct AppleColorDesctiption: Codable, Identifiable {
    var id: String { language }
    let language: String
    let description: String
}

struct AppleColor: Codable, Identifiable {
    var id: String { title }
    let title: String
    let descriptions: [AppleColorDesctiption]
    let link: String
}

struct AppleColorSection: Codable, Identifiable {
    var id: String { title }
    let title: String
    let colors: [AppleColor]
}

struct AppleColorCollection: Codable, Identifiable {
    var id: String { title }
    let title: String
    let sections: [AppleColorSection]
}
