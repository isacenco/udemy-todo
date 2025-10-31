//
//  ThemeSettings.swift
//  Todo App
//
//  Created by Ghenadie Isacenco on 31/10/2025.
//

import SwiftUI

// MARK: - THEME CLASS

class ThemeSettings: ObservableObject {
    
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    public static let shared = ThemeSettings()
}
