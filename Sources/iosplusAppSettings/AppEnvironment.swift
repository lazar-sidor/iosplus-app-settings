//
//  AppEnvironment.swift
//  GoolaApp
//
//  Created by Lazar Sidor on 13.01.2022.
//

import UIKit

public protocol AppSettingOption {
    var intValue: Int { get }
    var titleValue: String { get }
}

final public class SingleSelectionSettingsEntry: AppSettingsEntry {
    private let keyValueStore: PersistentKeyValueStore
    private let options: [AppSettingOption]
    private let defaultOption: AppSettingOption
    private let optionsGroupName: String
    
    public init(keyValueStore: PersistentKeyValueStore, options: [AppSettingOption], defaultOption: AppSettingOption, optionsGroupName: String) {
        self.keyValueStore = keyValueStore
        self.options = options
        self.defaultOption = defaultOption
        self.optionsGroupName = optionsGroupName
    }
        
    public func persistentKey() -> String {
        return String(describing: defaultOption.self)
    }
    
    public func defaultValue() -> Any? {
        return defaultOption.intValue
    }
    
    public func currentValue() -> Any? {
        if keyValueStore.hasValue(forKey: persistentKey()) {
            return Int(keyValueStore.value(forKey: persistentKey())!)!
        }
        
        return defaultOption.intValue
    }
    
    public func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }
    
    public func title() -> String {
        return optionsGroupName
    }
    
    public func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }
    
    public func supportedOptions() -> [Any] {
        return options.map { $0.titleValue }
    }
    
    public func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let option = options[index]
        return option.intValue == currentValue() as! Int
    }
    
    public func displayNameForOptionAtIndex(_ index: Int) -> String {
        let option = options[index]
        return option.titleValue.capitalized
    }
    
    public func saveWithSupportedValue(at index: Int) {
        let option = options[index]
        let savedValue = option.intValue
        keyValueStore.insert(savedValue, forKey: persistentKey())
    }
    
    public func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }
}
