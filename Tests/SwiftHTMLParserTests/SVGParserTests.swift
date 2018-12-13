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
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/SVG/svg-simple.html"
        let fullPath = "\(ProjectConfig().projectPath)\(relativePath)"
        let fileURL = URL.init(fileURLWithPath: fullPath)

        // get html string from file
        var htmlStringResult: String? = nil
        do {
            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file at: \(fullPath)")
        }
        guard let htmlString = htmlStringResult else {
            XCTFail("Could not open file at: \(fullPath)")
            return
        }

        // create object from raw html file
        let htmlParser = HTMLParser()
        guard let elementArray = try? htmlParser.parse(pageSource: htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(elementArray.count, 2)
    }
}
