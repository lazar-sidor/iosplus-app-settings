//
//  AppLocalizationService.swift
//
//  Created by Lazar Sidor on 14.01.2022.
//

import UIKit

public class AppLocalizationService: NSObject {
    public class func localizedStringsDictionary(for localizationName: String) -> NSDictionary? {
        let appLanguage = AppLanguageType()
        if let urlPath = Bundle(for: type(of: appLanguage)).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: localizationName) {
            if FileManager.default.fileExists(atPath: urlPath.path) {
                return NSDictionary.init(contentsOf: urlPath)
            }
        }
        
        return nil
    }
    
    public class func localizedString(_ key: String, language: AppLanguageType) -> String {
        let locName: String = language.lprojName()
        if let dict: NSDictionary = AppLocalizationService.localizedStringsDictionary(for: locName) {
            if let value = dict.value(forKey: key) {
                return value as! String
            }
        }
        
        return NSLocalizedString(
            key,
            tableName: nil,
            bundle: Bundle.main,
            value: "",
            comment: ""
        )
    }
}
