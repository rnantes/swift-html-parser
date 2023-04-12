//
//  CommentTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-11.
//

import XCTest
@testable import SwiftHTMLParser
import TestFiles

final class CommentParserTests: XCTestCase {
    func testComments() {
        guard let fileURL = TestFileURLs.commentsTestFilesDirectoryURL?
            .appendingPathComponent("comments.html") else {
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
        var nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body")
        ]

        var matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements[0].childNodes.count, 15)
        XCTAssertEqual(matchingElements[0].commentNodes.count, 6)
        XCTAssertEqual(matchingElements[0].childElements.count, 3)
        XCTAssertEqual(matchingElements[0].textNodes.count, 6)

        XCTAssertEqual(matchingElements[0].commentNodes[0].text, " This is a comment ")
        XCTAssertEqual(matchingElements[0].commentNodes[1].text, " This is annother comment ")
        XCTAssertEqual(matchingElements[0].commentNodes[3].text, " no space between the comment and div ")
        XCTAssertEqual(matchingElements[0].commentNodes[4].text, "x")
        XCTAssertEqual(matchingElements[0].commentNodes[5].text, "")

        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div"),
        ]

        matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)
        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].textNodes.first!.text, "This is a div")
    }

    func testConditionalComments() throws {
        guard let fileURL = TestFileURLs.commentsTestFilesDirectoryURL?
            .appendingPathComponent("conditional-comments-salvageable.html") else {
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

        //XCTAssertEqual(elementArray.count, 2)

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body")
        ]

        let matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements.first!.commentNodes.count, 1)
        //let commentText = try XCTUnwrap(matchingElements.first?.commentNodes.first?.text)
        let commentText = matchingElements.first!.commentNodes.first!.text
        XCTAssertTrue(commentText.contains("<p>You are using Internet Explorer 6. :( </p>"))
    }
}
