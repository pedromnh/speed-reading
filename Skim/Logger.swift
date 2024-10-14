//
//  Logger.swift
//  Skim
//
//  Created by Pedro Henriques on 13/10/2024.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    public static let urlProcessing = Logger(subsystem: subsystem, category: "URLTextExtractor")
    public static let fileStorage = Logger(subsystem: subsystem, category: "FileStorageManager")
    public static let shareExtension = Logger(subsystem: subsystem, category: "ShareExtension")
    public static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    public static let statistics = Logger(subsystem: subsystem, category: "statistics")
}
