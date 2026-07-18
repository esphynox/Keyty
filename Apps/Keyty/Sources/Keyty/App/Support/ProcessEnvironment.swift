//
//  ProcessEnvironment.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

enum ProcessEnvironment {
    static var isRunningTests: Bool {
        #if DEBUG
        return self.isRunningTests(
            environment: ProcessInfo.processInfo.environment,
            bundlePaths: Bundle.allBundles.map(\.bundlePath),
            classLookup: NSClassFromString
        )
        #else
        return false
        #endif
    }

    static var isRunningApp: Bool {
        !self.isRunningTests
    }

    static func isRunningTests(
        environment: [String: String],
        bundlePaths: [String],
        classLookup: (String) -> AnyClass?
    ) -> Bool {
        let testEnvironmentKeys = [
            "XCTestConfigurationFilePath",
            "XCTestSessionIdentifier",
            "XCInjectBundle",
            "XCInjectBundleInto",
        ]

        return testEnvironmentKeys.contains { environment[$0] != nil }
            || bundlePaths.contains { $0.hasSuffix(".xctest") }
            || classLookup("XCTestCase") != nil
            || classLookup("XCTest.XCTestCase") != nil
    }
}
