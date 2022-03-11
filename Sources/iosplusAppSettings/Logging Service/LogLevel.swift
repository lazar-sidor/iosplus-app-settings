//
//  LogLevel.swift
//

import Foundation

enum LogLevel: Int, Codable {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    
    static func defaultValue() -> LogLevel {
        var level: LogLevel = .warning
#if DEBUG
    level = .verbose
#endif
    return level
    }

    var iconSymbol: String {
        switch self {
        case .verbose:
            return "⚪"
        case .debug:
            return "🟢"
        case .info:
            return "🔵"
        case .warning:
            return "🟠"
        case .error:
            return "🔴"
        }
    }
    
    var title: String {
        switch self {
        case .verbose:
            return "Verbose"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        }
    }
}
