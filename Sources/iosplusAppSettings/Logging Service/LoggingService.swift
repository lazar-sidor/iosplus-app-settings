//
//  LogginServiceProtocol.swift
//

import Foundation

protocol LoggingServiceProtocol: AnyObject {
    /// Defines context for identifying log message.
    func set(identificator: String?)
    
    /// Defines functions for each of log level.
    func verbose(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt)
    func debug(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt)
    func info(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt)
    func warning(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt)
    func error(_ category: LogCategory?, _ msg: String, file: StaticString, function: StaticString, line: UInt)
}

final public class LoggingService {
    static var shared: LoggingService?
    
    private static var sharedLoggers: [LoggingServiceProtocol] {
        return shared?.loggers ?? []
    }
    
    private var loggers: [LoggingServiceProtocol]
    
    init(_ loggers: [LoggingServiceProtocol]) {
        self.loggers = loggers
    }
    
    private static let queue = DispatchQueue(label: "\(LoggingService.self)_Queue", qos: .background, target: nil)
    
    /// Defines context for identify log message.
    class func set(identificator: String?) {
        for logger in sharedLoggers {
            logger.set(identificator: identificator)
        }
    }
    
    /**
     Logs content as verbose.
     Used to log verbose data like JSON, etc...
     */
    class func verbose(_ category: LogCategory?, _ msg: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        queue.async {
            for logger in sharedLoggers {
                logger.verbose(category, msg, file: file, function: function, line: line)
            }
        }
    }
    /**
     Logs content as debug.
     Used to log relevant information for debugging the app.
     */
    class func debug(_ category: LogCategory?, _ msg: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        queue.async {
            for logger in sharedLoggers {
                logger.debug(category, msg, file: file, function: function, line: line)
            }
        }
    }
    /**
    Logs content as info.
     
    Use to log fine-grained informational events.
     */
    class func info(_ category: LogCategory?, _ msg: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        queue.async {
            for logger in sharedLoggers {
                logger.info(category, msg, file: file, function: function, line: line)
            }
        }
    }
    /**
     Logs content as warning.
     
     Use to log unexpected events or warnings.
     */
    class func warning(_ category: LogCategory?, _ msg: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        queue.async {
            for logger in sharedLoggers {
                logger.warning(category, msg, file: file, function: function, line: line)
            }
        }
    }
    
    /**
     Logs content as error.
     
     Use to log whenever an error occurs.
     */
    class func error(_ category: LogCategory?, _ msg: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        queue.async {
            for logger in sharedLoggers {
                logger.error(category, msg, file: file, function: function, line: line)
            }
        }
    }
    /**
    Logs content as fatal error.
     
     Use to log whenever an error occurs that will terminate application execution.
     */
    class func fatalError(_ category: LogCategory?, _ msg: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Never {
        for logger in sharedLoggers {
            logger.error(category, msg, file: file, function: function, line: line)
        }
        Swift.fatalError(msg)
    }
}
