//
//  JavascriptParserTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-09.
//

import XCTest
@testable import SwiftHTMLParser

final class JavascriptParserTests: XCTestCase {

    func testJavascriptSimple() {
        guard let fileURL = TestsConfig.javascriptTestFilesDirectoryURL?
            .appendingPathComponent("javascript-simple.html") else {
                XCTFail("Could not get url to test file")
                return
        }

        // get html string from file
        var htmlStringResult: String? = nil
        do {
            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file at: \(fileURL.path)")
        }
        guard let htmlString = htmlStringResult else {
            XCTFail("Could not open file at: \(fileURL.path)")
            return
        }

        // create object from raw html file
        guard let elementArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("script")
        ]

        let matchingElements = HTMLTraverser.findElements(in: elementArray,
                                                                         matching: nodeSelectorPath)
        XCTAssertEqual(matchingElements[0].childElements.count, 0)
    }

    func testJavascriptComments() {
        guard let fileURL = TestsConfig.javascriptTestFilesDirectoryURL?
            .appendingPathComponent("javascript-comments.html") else {
                XCTFail("Could not get url to test file")
                return
        }

        // get html string from file
        var htmlStringResult: String? = nil
        do {
            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file at: \(fileURL.path)")
        }
        guard let htmlString = htmlStringResult else {
            XCTFail("Could not open file at: \(fileURL.path)")
            return
        }

        // create object from raw html file
        guard let elementArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("script")
        ]

        let matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements[0].childElements.count, 0)
        XCTAssertEqual(matchingElements[0].textNodes.count, 1)
    }

    func testJavascriptQuotes() {
        guard let fileURL = TestsConfig.javascriptTestFilesDirectoryURL?
            .appendingPathComponent("javascript-quotes.html") else {
                XCTFail("Could not get url to test file")
                return
        }

        // get html string from file
        var htmlStringResult: String? = nil
        do {
            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file at: \(fileURL.path)")
        }
        guard let htmlString = htmlStringResult else {
            XCTFail("Could not open file at: \(fileURL.path)")
            return
        }

        // create object from raw html file
        guard let elementArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("script")
        ]

        let matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements[0].childElements.count, 0)
        XCTAssertEqual(matchingElements[0].textNodes.count, 1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text.count, 803)
    }

    func testJavascriptQuotesWithEscapeCharacters() {
        guard let fileURL = TestsConfig.javascriptTestFilesDirectoryURL?
            .appendingPathComponent("javascript-quotes-with-escape-characters.html") else {
                XCTFail("Could not get url to test file")
                return
        }

        // get html string from file
        var htmlStringResult: String? = nil
        do {
            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file at: \(fileURL.path)")
        }
        guard let htmlString = htmlStringResult else {
            XCTFail("Could not open file at: \(fileURL.path)")
            return
        }

        // create object from raw html file
        guard let elementArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(elementArray.count, 2)

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("script")
        ]

        let matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].childElements.count, 0)
        XCTAssertEqual(matchingElements[0].textNodes.count, 1)
    }

    static var allTests = [
        ("testJavascriptSimple", testJavascriptSimple),
        ("testJavascriptComments", testJavascriptComments),
        ("testJavascriptQuotes", testJavascriptQuotes),
        ("testJavascriptQuotesWithEscapeCharacters", testJavascriptQuotesWithEscapeCharacters),
    ]
}
