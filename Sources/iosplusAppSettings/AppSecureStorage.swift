//
//  AppSecureStorage.swift
//

import UIKit
import KeychainSwift

public enum AppSecureStorageEntry {
    case accessToken
    case custom(key: String)
    
    public var entryKey: String {
        switch self {
        case .accessToken: return "Access-Token"
        case .custom(let key): return key
        }
    }
}

public protocol AppSecureStorage {
    func item(for entry: AppSecureStorageEntry) -> String?
    func exists(for entry: AppSecureStorageEntry) -> Bool
    func save(_ value: String, forEntry entry: AppSecureStorageEntry)
    func saveBool(_ value: Bool, forEntry entry: AppSecureStorageEntry)
    func delete(_ entry: AppSecureStorageEntry)
    func clearAllExceptToken()
    func clearAll()
}

public final class SystemAppSecureStorage: AppSecureStorage {
    private let keychain = KeychainSwift()

    public func item(for entry: AppSecureStorageEntry) -> String? {
        keychain.get(entry.entryKey)
    }

    public func exists(for entry: AppSecureStorageEntry) -> Bool {
        item(for: entry) != nil
    }

    public func save(_ value: String, forEntry entry: AppSecureStorageEntry) {
        keychain.set(value, forKey: entry.entryKey)
    }

    public func saveBool(_ value: Bool, forEntry entry: AppSecureStorageEntry) {
        keychain.set(value, forKey: entry.entryKey)
    }

    public func delete(_ entry: AppSecureStorageEntry) {
        keychain.delete(entry.entryKey)
    }

    public func clearAll() {
        keychain.clear()
    }

    public func clearAllExceptToken() {
        for key in keychain.allKeys where key != AppSecureStorageEntry.accessToken.entryKey {
            keychain.delete(key)
        }
    }
}
