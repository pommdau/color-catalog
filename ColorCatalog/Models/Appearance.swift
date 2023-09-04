//
//  Appearance.swift
//  ColorCatalog
//
//  Created by HIROKI IKEUCHI on 2023/09/04.
//

import AppKit

enum Appearance: String, CaseIterable, Identifiable {
        
    /// refs: https://developer.apple.com/documentation/appkit/nsappearance/name/1534115-aqua
    case aqua
    case darkAqua
    case vibrantLight
    case vibrantDark
    case accessibilityHighContrastAqua
    case accessibilityHighContrastDarkAqua
    case accessibilityHighContrastVibrantLight
    case accessibilityHighContrastVibrantDark
    
    var id: String { self.rawValue }
    
    var nsAppearance: NSAppearance? {
        switch self {
        case .aqua:
            return NSAppearance(named: .aqua)
        case .darkAqua:
            return NSAppearance(named: .darkAqua)
        case .vibrantLight:
            return NSAppearance(named: .vibrantLight)
        case .vibrantDark:
            return NSAppearance(named: .vibrantDark)
        case .accessibilityHighContrastAqua:
            return NSAppearance(named: .accessibilityHighContrastAqua)
        case .accessibilityHighContrastDarkAqua:
            return NSAppearance(named: .accessibilityHighContrastDarkAqua)
        case .accessibilityHighContrastVibrantLight:
            return NSAppearance(named: .accessibilityHighContrastVibrantLight)
        case .accessibilityHighContrastVibrantDark:
            return NSAppearance(named: .accessibilityHighContrastVibrantDark)
        }
    }
}
