//
//  Language.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/04.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
        
    case english = "English"
    case japanese = "Japanese"
    
    var id: String { self.rawValue }
    
    var code: String {
        switch self {
        case .english:
            return "en"
        case .japanese:
            return "ja"
        }
    }
}
