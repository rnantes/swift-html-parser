//
//  PerformanceTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-11.
//

import XCTest
@testable import SwiftHTMLParser

final class PerformanceTests: XCTestCase {

    func testStringIteration() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/RealWorld/google-home-page.html"
        let fullPath = "\(ProjectConfig().projectPath)\(relativePath)"
        let fileURL = URL.init(fileURLWithPath: fullPath)

        // get html string from file
        var textStringResult: String? = nil
        do {
            textStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file at: \(fullPath)")
        }
        guard let text = textStringResult else {
            XCTFail("Could not open file at: \(fullPath)")
            return
        }

        var currentIndex = text.startIndex
        var numberOfMatchingCharacters = 0

        let lookaheadValidator = LookaheadValidator()
        let scriptEndTag = "</script>"

        let start = Date()
        while currentIndex < text.endIndex {
            // test for character
            if containsInner(text: text, currentIndex: currentIndex) {
                numberOfMatchingCharacters += 1
            }

            // test speed of lookahead validator
            if lookaheadValidator.isValidLookahead(for: text, atIndex: currentIndex, checkFor: scriptEndTag) {
                //print("found")
            }

            // iterate current index
            currentIndex = text.index(currentIndex, offsetBy: 1)
        }
        let end = Date()

        let timeElapsed = end.timeIntervalSince(start)
        print("time elapsed: \(timeElapsed) seconds")

        print("found \(numberOfMatchingCharacters) matching characters.")

        print("--------------------")
    }

    func containsInner(text: String, currentIndex: String.Index) -> Bool {
        let localIndex = currentIndex

        if text[localIndex] == "a" || text[localIndex] == "A" {
            return true
        } else {
            return false
        }
    }

    func testDeep() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Performance/deep.html"
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
            ElementSelector.init(tagName: "body")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray,
                                                      matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements[0].childElements.count, 300)
    }

    func timeDeep() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/deep.html"
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
        let start = Date()
        let htmlParser = HTMLParser()
        for _ in 0..<20 {
            do {
                _ = try htmlParser.parse(pageSource: htmlString)
            } catch {
                 XCTFail("Could not parse HTML")
            }
        }
        let end = Date()

        let timeElapsed = end.timeIntervalSince(start)
        print("time elapsed: \(timeElapsed) seconds")
    }
}
