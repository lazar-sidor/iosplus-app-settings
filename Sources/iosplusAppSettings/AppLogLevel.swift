//
//  AppLogLevel.swift
//
//  Created by Lazar Sidor on 27.01.2022.
//

import UIKit

public final class AppLogLevel: AppSettingsEntry {
    private let keyValueStore: PersistentKeyValueStore
    
    init(keyValueStore: PersistentKeyValueStore) {
        self.keyValueStore = keyValueStore
    }
        
    func persistentKey() -> String {
        return String(describing: AppLogLevel.self)
    }
    
    func defaultValue() -> Any? {
        return LogLevel.defaultValue()
    }
    
    func currentValue() -> Any? {
        if keyValueStore.hasValue(forKey: persistentKey()) {
            return LogLevel(rawValue: keyValueStore.value(forKey: persistentKey())!)!
        }
        
        return LogLevel.defaultValue()
    }
    
    func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }
    
    func title() -> String {
        return "Logging"
    }
    
    func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }
    
    func supportedOptions() -> [Any] {
        return [
            LogLevel.verbose.rawValue,
            LogLevel.debug.rawValue,
            LogLevel.info.rawValue,
            LogLevel.warning.rawValue,
            LogLevel.error.rawValue
        ]
    }
    
    func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let option = supportedOptions()[index]
        return LogLevel.init(rawValue: option as! Int) == currentValue() as? LogLevel
    }
    
    func displayNameForOptionAtIndex(_ index: Int) -> String {
        let option = supportedOptions()[index]
        return LogLevel.init(rawValue: option as! Int)!.title
    }
    
    func saveWithSupportedValue(at index: Int) {
        let option = supportedOptions()[index]
        let savedValue = LogLevel.init(rawValue: option as! Int)!
        keyValueStore.insert(savedValue, forKey: persistentKey())
    }
    
    func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }
}
