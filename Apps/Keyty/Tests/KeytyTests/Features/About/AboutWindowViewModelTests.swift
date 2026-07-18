//
//  AboutWindowViewModelTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

@MainActor
final class AboutWindowViewModelTests: XCTestCase {
    func testContributorsAreListedInPriorityOrder() {
        let viewModel = AboutWindowViewModel()

        XCTAssertEqual(viewModel.contributors.count, 1)
        XCTAssertEqual(
            viewModel.contributors.first?.listItems.map(\.title),
            [
                "Serhii Bykov",
                "Yullia Babichuk",
                "Oleksii Petruk",
                "Serhii Butenko",
            ]
        )
    }

    func testContributorTabSelectsContributorList() {
        let viewModel = AboutWindowViewModel()

        viewModel.selectedTab = .contributors

        XCTAssertEqual(viewModel.selectedSections.first?.title, "Contributors")
        XCTAssertEqual(viewModel.selectedSections.first?.subtitle, "People who helped make Keyty better.")
        XCTAssertEqual(viewModel.selectedSections.first?.listItems.count, 4)
    }
}
