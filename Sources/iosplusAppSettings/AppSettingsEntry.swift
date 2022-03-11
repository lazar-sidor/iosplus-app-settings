//
//  AppSettingsEntry.swift
//  Created by Lazar Sidor on 12.01.2022.
//

import UIKit

enum AppSettingSelectionType: Int {
    case singleSelection
}

protocol AppSettingsInterface {
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

typealias AppSettingsEntry = AppSettingsInterface
