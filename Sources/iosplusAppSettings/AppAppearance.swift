//
//  AppAppearance.swift
//
//  Created by Lazar Sidor on 26.01.2022.
//

import UIKit

enum AppAppearanceType: String, Codable {
    case system
    case light
    case dark
    
    static func defaultValue() -> AppAppearanceType {
        return .system
    }
}

public final class AppAppearance {
    private let keyValueStore: PersistentKeyValueStore
    
    init(keyValueStore: PersistentKeyValueStore) {
        self.keyValueStore = keyValueStore
    }

    func isDark() -> Bool {
        let value: AppAppearanceType = currentValue() as! AppAppearanceType
        if value == .system {
            if #available(iOS 12.0, *) {
                return UIScreen.main.traitCollection.userInterfaceStyle == .dark
            } else {
                // Fallback on earlier versions
            }
        }

        return value == .dark
    }
}

extension AppAppearance: AppSettingsEntry {
    func persistentKey() -> String {
        return String(describing: AppAppearance.self)
    }

    func defaultValue() -> Any? {
        return AppAppearanceType.defaultValue()
    }

    func currentValue() -> Any? {
        if keyValueStore.hasValue(forKey: persistentKey()) {
            return AppAppearanceType(rawValue: keyValueStore.value(forKey: persistentKey())!)!
        }

        return AppAppearanceType.defaultValue()
    }

    func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }

    func title() -> String {
        return "Appearance"
    }

    func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }

    func supportedOptions() -> [Any] {
        return [AppAppearanceType.system.rawValue, AppAppearanceType.light.rawValue, AppAppearanceType.dark.rawValue]
    }

    func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let option = supportedOptions()[index]
        return AppAppearanceType.init(rawValue: option as! String) == currentValue() as? AppAppearanceType
    }

    func displayNameForOptionAtIndex(_ index: Int) -> String {
        let option = supportedOptions()[index]
        if option is String {
            return (option as! String).capitalized
        }

        return ""
    }

    func saveWithSupportedValue(at index: Int) {
        let option = supportedOptions()[index]
        let savedValue = AppAppearanceType.init(rawValue: option as! String)!
        keyValueStore.insert(savedValue, forKey: persistentKey())
    }

    func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }
}
