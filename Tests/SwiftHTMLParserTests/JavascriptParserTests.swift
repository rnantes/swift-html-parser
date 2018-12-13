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
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Javascript/javascript-simple.html"
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

        // find matching elements by traversing the created html object
        let elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "script")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray,
                                                                         matchingElementSelectorPath: elementSelectorPath)
        XCTAssertEqual(matchingElements[0].childElements.count, 0)
    }

    func testJavascriptComments() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Javascript/javascript-comments.html"
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

        // find matching elements by traversing the created html object
        let elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "script")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements[0].childElements.count, 0)
        XCTAssertEqual(matchingElements[0].innerTextBlocks.count, 1)
    }

    func testJavascriptQuotes() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Javascript/javascript-quotes.html"
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

        // find matching elements by traversing the created html object
        let elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "script")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray,
                                                                         matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements[0].childElements.count, 0)
        XCTAssertEqual(matchingElements[0].innerTextBlocks.count, 1)
        XCTAssertEqual(matchingElements[0].innerTextBlocks[0].text.count, 825)
    }

    func testJavascriptQuotesWithEscapeCharacters() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Javascript/javascript-quotes-with-escape-characters.html"
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

        // find matching elements by traversing the created html object
        let elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "script")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].childElements.count, 0)
        XCTAssertEqual(matchingElements[0].innerTextBlocks.count, 1)
    }

    static var allTests = [
        ("testJavascriptSimple", testJavascriptSimple),
        ("testJavascriptComments", testJavascriptComments),
        ("testJavascriptQuotes", testJavascriptQuotes),
        ("testJavascriptQuotesWithEscapeCharacters", testJavascriptQuotesWithEscapeCharacters),
    ]
}
