//
//  AppSecureStorage.swift
//

import UIKit
import KeychainSwift

enum AppSecureStorageEntry {
    case accessToken
    case custom(key: String)
    
    var entryKey: String {
        switch self {
        case .accessToken: return "Access-Token"
        case .custom(let key): return key
        }
    }
}

protocol AppSecureStorage {
    func item(for entry: AppSecureStorageEntry) -> String?
    func exists(for entry: AppSecureStorageEntry) -> Bool
    func save(_ value: String, forEntry entry: AppSecureStorageEntry)
    func saveBool(_ value: Bool, forEntry entry: AppSecureStorageEntry)
    func delete(_ entry: AppSecureStorageEntry)
    func clearAllExceptToken()
    func clearAll()
}

final public class SystemAppSecureStorage: AppSecureStorage {
    private let keychain = KeychainSwift()

    func item(for entry: AppSecureStorageEntry) -> String? {
        keychain.get(entry.entryKey)
    }

    func exists(for entry: AppSecureStorageEntry) -> Bool {
        item(for: entry) != nil
    }

    func save(_ value: String, forEntry entry: AppSecureStorageEntry) {
        keychain.set(value, forKey: entry.entryKey)
    }

    func saveBool(_ value: Bool, forEntry entry: AppSecureStorageEntry) {
        keychain.set(value, forKey: entry.entryKey)
    }

    func delete(_ entry: AppSecureStorageEntry) {
        keychain.delete(entry.entryKey)
    }

    func clearAll() {
        keychain.clear()
    }

    func clearAllExceptToken() {
        for key in keychain.allKeys where key != AppSecureStorageEntry.accessToken.entryKey {
            keychain.delete(key)
        }
    }
}
