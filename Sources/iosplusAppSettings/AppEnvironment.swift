//
//  AppEnvironment.swift
//  GoolaApp
//
//  Created by Lazar Sidor on 13.01.2022.
//

import UIKit

protocol AppSettingOption {
    var intValue: Int { get }
    var titleValue: String { get }
}

final public class SingleSelectionSettingsEntry: AppSettingsEntry {
    private let keyValueStore: PersistentKeyValueStore
    private let options: [AppSettingOption]
    private let defaultOption: AppSettingOption
    private let optionsGroupName: String
    
    init(keyValueStore: PersistentKeyValueStore, options: [AppSettingOption], defaultOption: AppSettingOption, optionsGroupName: String) {
        self.keyValueStore = keyValueStore
        self.options = options
        self.defaultOption = defaultOption
        self.optionsGroupName = optionsGroupName
    }
        
    func persistentKey() -> String {
        return String(describing: defaultOption.self)
    }
    
    func defaultValue() -> Any? {
        return defaultOption.intValue
    }
    
    func currentValue() -> Any? {
        if keyValueStore.hasValue(forKey: persistentKey()) {
            return Int(keyValueStore.value(forKey: persistentKey())!)!
        }
        
        return defaultOption.intValue
    }
    
    func persistentStore() -> PersistentKeyValueStore {
        return keyValueStore
    }
    
    func title() -> String {
        return optionsGroupName
    }
    
    func selectionType() -> AppSettingSelectionType {
        return .singleSelection
    }
    
    func supportedOptions() -> [Any] {
        return options.map { $0.titleValue }
    }
    
    func hasSelectedOptionAtIndex(_ index: Int) -> Bool {
        let option = options[index]
        return option.intValue == currentValue() as! Int
    }
    
    func displayNameForOptionAtIndex(_ index: Int) -> String {
        let option = options[index]
        return option.titleValue.capitalized
    }
    
    func saveWithSupportedValue(at index: Int) {
        let option = options[index]
        let savedValue = option.intValue
        keyValueStore.insert(savedValue, forKey: persistentKey())
    }
    
    func clear() {
        keyValueStore.removeValue(forKey: persistentKey())
    }
}
