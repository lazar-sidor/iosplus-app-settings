//
//  AppLanguage.swift
//
//  Created by Lazar Sidor on 13.01.2022.
//

import UIKit

final public class AppLanguageType: NSObject {
    var localeIdentifier: String
    
    convenience init(localeId: String) {
        self.init()
        self.localeIdentifier = localeId
    }
    
    override init() {
        self.localeIdentifier = "en_US"
        super.init()
    }
    
    static func defaultValue() -> AppLanguageType {
        return AppLanguageType(localeId: "en_US")
    }
    
    func abbreviation() -> String {
        let code = languageCode()
        let country = countryCode()
        if code.lowercased() == country.lowercased() {
            return code.lowercased()
        }
        
        return localeIdentifier.lowercased()
    }
    
    func languageCode() -> String {
        let locale = Locale(identifier: localeIdentifier)
        return locale.languageCode!
    }
    
    func countryCode() -> String {
        let locale = Locale(identifier: localeIdentifier)
        return locale.regionCode!
    }
    
    func lprojName() -> String {
        let code = languageCode()
        let country = countryCode()
        if code.lowercased() == country.lowercased() {
            return code.lowercased()
        }
        
        return "\(code)-\(country.uppercased())"
    }
}
    
final public class AppLanguage {
    private var supportedLocaleIdentifiers: [String] = []
    private var keyValueStore: PersistentKeyValueStore
    
    init() {
        supportedLocaleIdentifiers = NSLocale.availableLocaleIdentifiers
        self.keyValueStore = PersistentKeyValueStore(defaults: UserDefaults.standard)
    }
    
    convenience init(localeIdentifiers: [String], keyValueStore: PersistentKeyValueStore) {
        self.init()
        self.supportedLocaleIdentifiers = localeIdentifiers
        self.keyValueStore = keyValueStore
    }
    
    func currentLanguageCode() -> String {
        let value = (currentValue() as! AppLanguageType).languageCode()
        return value
    }
    
    func currentLocale() -> Locale {
        let localeId: String = (currentValue() as! AppLanguageType).localeIdentifier
        return Locale(identifier: localeId)
    }
}

extension AppLanguage: AppSettingsEntry {
    func persistentKey() -> String {
        return String(describing: AppLanguage.self)
    }

    func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }

    func defaultValue() -> Any? {
        if supportedLocaleIdentifiers.contains(Locale.current.identifier) {
            return AppLanguageType(localeId: Locale.current.identifier)
        }

        return AppLanguageType.defaultValue()
    }

    func currentValue() -> Any? {
        let key = persistentKey()
        if keyValueStore.hasValue(forKey: key) {
            return AppLanguageType(localeId: keyValueStore.value(forKey: key)!)
        }

        return AppLanguageType.defaultValue()
    }
    
    func supportedOptions() -> [Any] {
        return supportedLocaleIdentifiers
    }

    func title() -> String {
        return "Language"
    }

    func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }

    func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let localeId: String = supportedLocaleIdentifiers[index]
        return localeId == (currentValue() as! AppLanguageType).localeIdentifier
    }

    func displayNameForOptionAtIndex(_ index: Int) -> String {
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

    func saveWithSupportedValue(at index: Int) {
        let localeId: String = supportedOptions()[index] as! String
        keyValueStore.insert(localeId, forKey: persistentKey())
    }

    func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }
}
