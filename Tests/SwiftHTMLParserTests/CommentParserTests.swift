//
//  CommentTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-11.
//

import XCTest
@testable import SwiftHTMLParser

final class CommentParserTests: XCTestCase {
    func testComments() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Comments/comments.html"
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
        var elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements[0].nodeOrder.count, 14)
        XCTAssertEqual(matchingElements[0].comments.count, 4)
        XCTAssertEqual(matchingElements[0].childElements.count, 3)
        XCTAssertEqual(matchingElements[0].innerTextBlocks.count, 7)

        XCTAssertEqual(matchingElements[0].comments[0].text, " This is a comment ")
        XCTAssertEqual(matchingElements[0].comments[1].text, " This is annother comment ")
        XCTAssertEqual(matchingElements[0].comments[3].text, " no space between the comment and div ")

        elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "div"),
        ]

        matchingElements = traverser.findElements(in: elementArray, matchingElementSelectorPath: elementSelectorPath)
        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].innerTextBlocks.first!.text, "This is a div")
    }

    func testConditionalComments() throws {
        guard let fileURL = TestsConfig.commentsTestFilesDirectoryURL?
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
        let htmlParser = HTMLParser()
        guard let elementArray = try? htmlParser.parse(pageSource: htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        //XCTAssertEqual(elementArray.count, 2)

        // find matching elements by traversing the created html object
        let elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body")
        ]

        let traverser = HTMLTraverser()
        let matchingElements = traverser.findElements(in: elementArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements.first!.comments.count, 1)
        let commentText = try XCTUnwrap(matchingElements.first?.comments.first?.text)
        XCTAssertTrue(commentText.contains("<p>You are using Internet Explorer 6. :( </p>"))
    }
}
