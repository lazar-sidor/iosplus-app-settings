//
//  Logger.swift
//
//  Created by Lazar Sidor on 27.01.2022.
//

import UIKit


public final class AppLogManager: NSObject {
    static var shared: AppLogManager?
    private var appLogLevel = LogLevel.defaultValue()
    
    init(_ loggers: [LoggingServiceProtocol], appLogLevel: LogLevel) {
        LoggingService.shared = LoggingService(loggers)
        self.appLogLevel = appLogLevel
    }
    
    func log(_ category: LogCategory?, level: LogLevel, _ msg: String?) {
        if level.rawValue < appLogLevel.rawValue {
            // If configured app log level is bigger the one requested to log message, then don't log anything
            return
        }
        
        switch level {
        case .verbose:
            LoggingService.verbose(category, msg ?? "")
        case .debug:
            LoggingService.debug(category, msg ?? "")
        case .info:
            LoggingService.info(category, msg ?? "")
        case .warning:
            LoggingService.warning(category, msg ?? "")
        case .error:
            LoggingService.error(category, msg ?? "")
        }
    }
}
