//
//  SVGParserTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-12.
//

import Foundation

import XCTest
@testable import SwiftHTMLParser

final class SVGParserTests: XCTestCase {
    func testSVG() {
        guard let fileURL = TestsConfig.svgTestFilesDirectoryURL?
            .appendingPathComponent("svg-simple.html") else {
                XCTFail("Could find get file URL to parse")
                return
        }

        // get html string from file
        var htmlStringResult: String? = nil
        do {
            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file URL: \(fileURL)")
            return
        }
        guard let htmlString = htmlStringResult else {
            XCTFail("Could not open file URL: \(fileURL)")
            return
        }

        // create object from raw html file
        guard let elementArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(elementArray.count, 2)
    }
}
