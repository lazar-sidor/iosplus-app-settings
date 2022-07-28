//
//  AppAppearance.swift
//
//  Created by Lazar Sidor on 26.01.2022.
//

import UIKit

public enum AppAppearanceType: String, Codable {
    case system
    case light
    case dark
    
    public static func defaultValue() -> AppAppearanceType {
        return .system
    }
}

public final class AppAppearance {
    private let keyValueStore: PersistentKeyValueStore
    
    public init(keyValueStore: PersistentKeyValueStore) {
        self.keyValueStore = keyValueStore
    }

    public func isDark() -> Bool {
        let value: AppAppearanceType = currentValue() as! AppAppearanceType
        if value == .system {
            if #available(iOS 12.0, *) {
                #if os(iOS)
                return UIScreen.main.traitCollection.userInterfaceStyle == .dark
                #endif
            } else {
                // Fallback on earlier versions
            }
        }

        return value == .dark
    }
}

extension AppAppearance: AppSettingsEntry {
    public func persistentKey() -> String {
        return String(describing: AppAppearance.self)
    }

    public func defaultValue() -> Any? {
        return AppAppearanceType.defaultValue()
    }

    public func currentValue() -> Any? {
        if keyValueStore.hasValue(forKey: persistentKey()) {
            return AppAppearanceType(rawValue: keyValueStore.value(forKey: persistentKey())!)!
        }

        return AppAppearanceType.defaultValue()
    }

    public func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }

    public func title() -> String {
        return "Appearance"
    }

    public func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }

    public func supportedOptions() -> [Any] {
        return [AppAppearanceType.system.rawValue, AppAppearanceType.light.rawValue, AppAppearanceType.dark.rawValue]
    }

    public func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let option = supportedOptions()[index]
        return AppAppearanceType.init(rawValue: option as! String) == currentValue() as? AppAppearanceType
    }

    public func displayNameForOptionAtIndex(_ index: Int) -> String {
        let option = supportedOptions()[index]
        if option is String {
            return (option as! String).capitalized
        }

        return ""
    }

    public func saveWithSupportedValue(at index: Int) {
        let option = supportedOptions()[index]
        let savedValue = AppAppearanceType.init(rawValue: option as! String)!
        keyValueStore.insert(savedValue, forKey: persistentKey())
    }

    public func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }
}
