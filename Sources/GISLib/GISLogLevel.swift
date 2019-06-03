//
//  GISLogLevel.swift
//  GISLib
//
//  Created by GG on 2019/6/2.
//

import Logging

/// 与 苹果官方swift-log框架的 Logger.Level 一一对应
public enum GISLogLevel {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical
}

/// 将 GISLogLevel 转成 苹果官方swift-log框架的 Logger.Level
internal func map2LoggerLevel(_ level: GISLogLevel) ->  Logger.Level{
    switch level {
    case .trace:
        return Logger.Level.trace
    case .debug:
        return Logger.Level.debug
    case .info:
        return Logger.Level.info
    case .notice:
        return Logger.Level.notice
    case .warning:
        return Logger.Level.warning
    case .error:
        return Logger.Level.error
    case .critical:
        return Logger.Level.critical
    }
}


