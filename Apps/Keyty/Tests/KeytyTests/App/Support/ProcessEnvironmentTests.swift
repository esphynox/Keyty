//
//  ProcessEnvironmentTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class ProcessEnvironmentTests: XCTestCase {
    func testDetectsXCTestConfigurationEnvironment() {
        XCTAssertTrue(
            ProcessEnvironment.isRunningTests(
                environment: ["XCTestConfigurationFilePath": "/tmp/KeytyTests.xctestconfiguration"],
                bundlePaths: [],
                classLookup: { _ in nil }
            )
        )
    }

    func testDetectsInjectedXCTestBundle() {
        XCTAssertTrue(
            ProcessEnvironment.isRunningTests(
                environment: [:],
                bundlePaths: ["/tmp/KeytyTests.xctest"],
                classLookup: { _ in nil }
            )
        )
    }

    func testDetectsLoadedXCTestClass() {
        XCTAssertTrue(
            ProcessEnvironment.isRunningTests(
                environment: [:],
                bundlePaths: [],
                classLookup: { name in
                    name == "XCTest.XCTestCase" ? XCTestCase.self : nil
                }
            )
        )
    }

    func testDoesNotDetectTestsWithoutXCTestSignals() {
        XCTAssertFalse(
            ProcessEnvironment.isRunningTests(
                environment: [:],
                bundlePaths: ["/Applications/Keyty.app"],
                classLookup: { _ in nil }
            )
        )
    }
}
