//
//  AppLanguage.swift
//
//  Created by Lazar Sidor on 13.01.2022.
//

import UIKit

public final class AppLanguageType: NSObject {
    var localeIdentifier: String
    
    public convenience init(localeId: String) {
        self.init()
        self.localeIdentifier = localeId
    }
    
    public override init() {
        self.localeIdentifier = "en_US"
        super.init()
    }
    
    public static func defaultValue() -> AppLanguageType {
        return AppLanguageType(localeId: "en_US")
    }
    
    public func abbreviation() -> String {
        let code = languageCode()
        let country = countryCode()
        if code.lowercased() == country.lowercased() {
            return code.lowercased()
        }
        
        return localeIdentifier.lowercased()
    }
    
    public func languageCode() -> String {
        let locale = Locale(identifier: localeIdentifier)
        return locale.languageCode!
    }
    
    public func countryCode() -> String {
        let locale = Locale(identifier: localeIdentifier)
        return locale.regionCode!
    }
    
    public func lprojName() -> String {
        let code = languageCode()
        let country = countryCode()
        if code.lowercased() == country.lowercased() {
            return code.lowercased()
        }
        
        return "\(code)-\(country.uppercased())"
    }
}
    
public final class AppLanguage {
    private var supportedLocaleIdentifiers: [String] = []
    private var keyValueStore: PersistentKeyValueStore
    private var displayedTitle: String
    
    public init() {
        supportedLocaleIdentifiers = NSLocale.availableLocaleIdentifiers
        self.keyValueStore = PersistentKeyValueStore(defaults: UserDefaults.standard)
        self.displayedTitle = "Language"
    }
    
    public convenience init(localeIdentifiers: [String], keyValueStore: PersistentKeyValueStore, displayedTitle: String? = nil) {
        self.init()
        self.supportedLocaleIdentifiers = localeIdentifiers
        self.keyValueStore = keyValueStore

        if let displayedTitle = displayedTitle {
            self.displayedTitle = displayedTitle
        }
    }
    
    public func currentLanguageCode() -> String {
        let value = (currentValue() as! AppLanguageType).languageCode()
        return value
    }
    
    public func currentLocale() -> Locale {
        let localeId: String = (currentValue() as! AppLanguageType).localeIdentifier
        return Locale(identifier: localeId)
    }
}

extension AppLanguage: AppSettingsEntry {
    public func persistentKey() -> String {
        return String(describing: AppLanguage.self)
    }

    public func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }

    public func defaultValue() -> Any? {
        if supportedLocaleIdentifiers.contains(Locale.current.identifier) {
            return AppLanguageType(localeId: Locale.current.identifier)
        }

        return AppLanguageType.defaultValue()
    }

    public func currentValue() -> Any? {
        let key = persistentKey()
        if keyValueStore.hasValue(forKey: key) {
            return AppLanguageType(localeId: keyValueStore.value(forKey: key)!)
        }

        let defaultType: AppLanguageType = AppLanguageType.defaultValue()
        let deviceIdentifier = Locale.current.identifier
        if supportedLocaleIdentifiers.contains(deviceIdentifier) {
            return AppLanguageType(localeId: deviceIdentifier)
        }

        if supportedLocaleIdentifiers.contains(defaultType.localeIdentifier) {
            return defaultType
        }

        if let firstSupportedIdentifier = supportedLocaleIdentifiers.first {
            return AppLanguageType(localeId: firstSupportedIdentifier)
        }

        return AppLanguageType.defaultValue()
    }
    
    public func supportedOptions() -> [Any] {
        return supportedLocaleIdentifiers
    }

    public func title() -> String {
        return displayedTitle
    }

    public func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }

    public func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let localeId: String = supportedLocaleIdentifiers[index]
        return localeId == (currentValue() as! AppLanguageType).localeIdentifier
    }

    public func displayNameForOptionAtIndex(_ index: Int) -> String {
        let localeId: String = supportedLocaleIdentifiers[index]
        let locale = Locale(identifier: localeId)

        if let langageCode = locale.languageCode {
            if langageCode == locale.regionCode {
                return locale.localizedString(forLanguageCode: langageCode)!
            }

            if let regionCode = locale.regionCode {
                if let regionName = locale.localizedString(forRegionCode: regionCode) {
                    return "\(locale.localizedString(forLanguageCode: langageCode)!) (\(regionName))"
                }
            }
        }

        return localeId
    }

    public func localizedCurentValue() -> String? {
        let localeId = (currentValue() as! AppLanguageType).localeIdentifier
        if let index = supportedLocaleIdentifiers.firstIndex(of: localeId) {
            return displayNameForOptionAtIndex(index)
        }

        return nil
    }

    public func saveWithSupportedValue(at index: Int) {
        let localeId: String = supportedOptions()[index] as! String
        keyValueStore.insert(localeId, forKey: persistentKey())
    }

    public func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }

    public func save(with localeId: String) {
        keyValueStore.insert(localeId, forKey: persistentKey())
    }
}
