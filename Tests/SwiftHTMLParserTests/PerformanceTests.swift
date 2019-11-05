//
//  PerformanceTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-11.
//

import XCTest
@testable import SwiftHTMLParser

final class PerformanceTests: XCTestCase {

    func testIteratingString() {
        guard let fileURL = TestsConfig.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("google-home-page.html") else {
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

        var currentIndex = htmlString.startIndex
        var numberOfMatchingCharacters = 0
        let charToMatch: Character  = "a"

        let start = Date()
        while currentIndex < htmlString.endIndex {
            if (htmlString[currentIndex] == charToMatch) {
                numberOfMatchingCharacters += 1
            }

            // iterate current index
            currentIndex = htmlString.index(currentIndex, offsetBy: 1)
        }
        let end = Date()

        let timeElapsed = end.timeIntervalSince(start)
        print("time elapsed: \(timeElapsed) seconds")

        print("found \(numberOfMatchingCharacters) matching the string '\(charToMatch)'")

        print("--------------------")
    }

    func testStringIteration() {
        guard let fileURL = TestsConfig.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("google-home-page.html") else {
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
        guard let text = htmlStringResult else {
            XCTFail("Could not open file at: \(fileURL.path)")
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

//    func testDeep() {
//        guard let fileURL = TestsConfig.performanceTestFilesDirectoryURL?
//            .appendingPathComponent("deep.html") else {
//                XCTFail("Could not get url to test file")
//                return
//        }
//
//        // get html string from file
//        var htmlStringResult: String? = nil
//        do {
//            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
//        } catch {
//            XCTFail("Could not open file at: \(fileURL.path)")
//        }
//        guard let htmlString = htmlStringResult else {
//            XCTFail("Could not open file at: \(fileURL.path)")
//            return
//        }
//
//        // create object from raw html file
//        let htmlParser = HTMLParser()
//        guard let elementArray = try? HTMLParser.parse(htmlString) else {
//            XCTFail("Could not parse HTML")
//            return
//        }
//
//        // find matching elements by traversing the created html object
//        let nodeSelectorPath = [
//            ElementSelector.init(tagName: "html"),
//            ElementSelector.init(tagName: "body")
//        ]
//
//        let traverser = HTMLTraverser()
//        let matchingElements = traverser.findElements(in: elementArray,
//                                                      matchingNodeSelectorPath: nodeSelectorPath)
//
//        XCTAssertEqual(matchingElements[0].childElements.count, 300)
//    }

//    func testTimeDeep() {
//        guard let fileURL = TestsConfig.performanceTestFilesDirectoryURL?
//            .appendingPathComponent("deep.html") else {
//                XCTFail("Could not get url to test file")
//                return
//        }
//
//        // get html string from file
//        var htmlStringResult: String? = nil
//        do {
//            htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
//        } catch {
//            XCTFail("Could not open file at: \(fileURL.path)")
//        }
//        guard let htmlString = htmlStringResult else {
//            XCTFail("Could not open file at: \(fileURL.path)")
//            return
//        }
//
//        // create object from raw html file
//        let start = Date()
//        let htmlParser = HTMLParser()
//        for _ in 0..<20 {
//            do {
//                _ = try HTMLParser.parse(htmlString)
//            } catch {
//                 XCTFail("Could not parse HTML")
//            }
//        }
//        let end = Date()
//
//        let timeElapsed = end.timeIntervalSince(start)
//        print("time elapsed: \(timeElapsed) seconds")
//    }
}
