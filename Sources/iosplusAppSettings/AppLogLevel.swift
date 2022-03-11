//
//  AppLogLevel.swift
//
//  Created by Lazar Sidor on 27.01.2022.
//

import UIKit

public final class AppLogLevel: AppSettingsEntry {
    private let keyValueStore: PersistentKeyValueStore
    
    public init(keyValueStore: PersistentKeyValueStore) {
        self.keyValueStore = keyValueStore
    }
        
    public func persistentKey() -> String {
        return String(describing: AppLogLevel.self)
    }
    
    public func defaultValue() -> Any? {
        return LogLevel.defaultValue()
    }
    
    public func currentValue() -> Any? {
        if keyValueStore.hasValue(forKey: persistentKey()) {
            return LogLevel(rawValue: keyValueStore.value(forKey: persistentKey())!)!
        }
        
        return LogLevel.defaultValue()
    }
    
    public func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }
    
    public func title() -> String {
        return "Logging"
    }
    
    public func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }
    
    public func supportedOptions() -> [Any] {
        return [
            LogLevel.verbose.rawValue,
            LogLevel.debug.rawValue,
            LogLevel.info.rawValue,
            LogLevel.warning.rawValue,
            LogLevel.error.rawValue
        ]
    }
    
    public func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let option = supportedOptions()[index]
        return LogLevel.init(rawValue: option as! Int) == currentValue() as? LogLevel
    }
    
    public func displayNameForOptionAtIndex(_ index: Int) -> String {
        let option = supportedOptions()[index]
        return LogLevel.init(rawValue: option as! Int)!.title
    }
    
    public func saveWithSupportedValue(at index: Int) {
        let option = supportedOptions()[index]
        let savedValue = LogLevel.init(rawValue: option as! Int)!
        keyValueStore.insert(savedValue, forKey: persistentKey())
    }
    
    public func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }
}
