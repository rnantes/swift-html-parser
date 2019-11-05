//
//  AppendableITests.swift.swift
//  
//
//  Created by Reid Nantes on 2019-11-05.
//

import Foundation

import XCTest
@testable import SwiftHTMLParser

final class AppendableTests: XCTestCase {

    func testAppendOrIntialize() {
        // single value
        var optArray: [String]? = nil
        optArray.appendOrInit("hello appendOrInit")
        XCTAssertEqual(optArray![0], "hello appendOrInit")

        // multiple values
        var optArray2: [String]? = nil
        optArray2.appendOrInit(contentsOf: ["sunny", "rainy", "cloudy"])
        XCTAssertEqual(optArray2?.count, 3)

        var optSet: Set<String>? = nil
        optSet.insertOrInit("apple")
        optSet.formUnionOrInit(["banana", "pineapple", "cherry", "pear"])
        XCTAssertEqual(optSet?.count, 5)
    }
}
