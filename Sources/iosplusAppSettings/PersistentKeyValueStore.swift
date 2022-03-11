//
//  PersistentKeyValueStore.swift
//  Created by Lazar Sidor on 11.01.2022.
//

import Foundation

final public class PersistentKeyValueStore {
    private let defaults: UserDefaults
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var jsonEncoder = JSONEncoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    convenience init(appGroup: String) {
        let suite = UserDefaults.init(suiteName: appGroup)
        self.init(defaults: suite!)
    }

    func insert<T: Codable>(_ value: T, forKey key: String) {
        // Wrapping value in array to enable encoding of primitives
        // swiftlint:disable:next force_try
        let value = try! jsonEncoder.encode([value])
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }

    func value<T: Codable>(forKey key: String) -> T? {
        // Wrapping value in array to enable encoding of primitives
        guard let encodedValue = defaults.value(forKey: key) as? Data else {
            return nil
        }

        let value = try? jsonDecoder.decode([T].self, from: encodedValue)
        return value?.first
    }

    func hasValue(forKey key: String) -> Bool {
        return defaults.value(forKey: key) != nil
    }

    func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    func clear() {
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
    }
}