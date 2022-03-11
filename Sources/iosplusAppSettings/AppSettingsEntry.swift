//
//  AppSettingsEntry.swift
//  Created by Lazar Sidor on 12.01.2022.
//

import UIKit

public enum AppSettingSelectionType: Int {
    case singleSelection
}

public protocol AppSettingsInterface {
    func persistentKey() -> String
    func currentValue() -> Any?
    func persistentStore() -> PersistentKeyValueStore
    func hasSelectedOptionAtIndex(_ index: Int) -> Bool
    func displayNameForOptionAtIndex(_ index: Int) -> String
    func saveWithSupportedValue(at index: Int)
    func defaultValue() -> Any?
    func title() -> String
    func supportedOptions() -> [Any]
    func selectionType() -> AppSettingSelectionType
    func clear()
}

public typealias AppSettingsEntry = AppSettingsInterface
