//
//  CocoaLumberjackLogger.swift
//

import CocoaLumberjackSwift

public typealias LogCategory = String

public class CocoaLumberjackLogger: LoggingServiceProtocol {
    public init() {
        DDLog.sharedInstance.add(DDOSLogger.sharedInstance)
    }
    
    public func set(identificator: String?) {}
    
    public func verbose(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt) {
        let message = logMessage(level: .verbose, category: category, msg: msg)
        DDLogVerbose(message, file: file, function: function, line: line)
    }
    
    public func debug(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt) {
        let message = logMessage(level: .debug, category: category, msg: msg)
        DDLogDebug(message, file: file, function: function, line: line)
    }
    
    public func info(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt) {
        let message = logMessage(level: .info, category: category, msg: msg)
        DDLogInfo(message, file: file, function: function, line: line)
    }
    
    public func warning(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt) {
        let message = logMessage(level: .warning, category: category, msg: msg)
        DDLogWarn(message, file: file, function: function, line: line)
    }
    
    public func error(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt) {
        let message = logMessage(level: .error, category: category, msg: msg)
        DDLogError(message, file: file, function: function, line: line)
    }
    
    private func logMessage(level: LogLevel, category: LogCategory?, msg: String) -> String {
        if let category = category {
            return "\(level.iconSymbol) [\(category)] \(msg)"
        }
        
        return "\(level.iconSymbol) \(msg)"
    }
}
