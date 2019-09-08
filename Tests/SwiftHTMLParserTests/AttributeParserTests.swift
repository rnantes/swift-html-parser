//
//  AttributeParserTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import XCTest
@testable import SwiftHTMLParser

final class AttributeParserTests: XCTestCase {

    func testAttributes() {
        guard let fileURL = TestsConfig.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-simple.html") else {
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
        let htmlParser = HTMLParser()
        guard let nodeTree = try? htmlParser.parse(pageSource: htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        var elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "a")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: nodeTree, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 2)

        // test basic example
        XCTAssertEqual(matchingElements[0].attributeValue(for: "href"), "https://www.google.com")

        // test multiple attributes
        // id short form and attribute id should be the same
        XCTAssertEqual(matchingElements[1].id!, "alternate-search-engine")
        XCTAssertEqual(matchingElements[1].attributeValue(for: "id")!, "alternate-search-engine")
        XCTAssertEqual(matchingElements[1].attributeValue(for: "href")!, "https://duckduckgo.com")


        // test empty attribute - ex <p emptyAtrribute="">
        elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "div")
        ]

        matchingElements = traverser.findElements(in: nodeTree, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.first!.attributeValue(for: "emptyAtrribute")!, "")


        elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "form"),
            ElementSelector.init(tagName: "input")
        ]

        matchingElements = traverser.findElements(in: nodeTree, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)

        // test attribute with name but no value
        XCTAssertEqual(matchingElements[0].containsAttribute("disabled"), true)
        XCTAssertEqual(matchingElements[0].attributeValue(for: "disabled"), nil)
    }



    func testAttributesQuotes() {
        guard let fileURL = TestsConfig.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-quotes.html") else {
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
        let htmlParser = HTMLParser()
        guard let elementArray = try? htmlParser.parse(pageSource: htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "p")
        ]

        let traverser = HTMLTraverser()
        let matchingElements = traverser.findElements(in: elementArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 2)

        // test attribute with double quotes within single quotes
        XCTAssertEqual(matchingElements[0].openingTag.attributes.count, 2)
        XCTAssertEqual(matchingElements[0].attributeValue(for: "title")!, "John \"ShotGun\" Nelson")

        // test attribute with single quotes within double quotes
        XCTAssertEqual(matchingElements[1].openingTag.attributes.count, 2)
        XCTAssertEqual(matchingElements[1].attributeValue(for: "title")!, "John 'ShotGun' Nelson")

        print("HI")

    }

    static var allTests = [
        ("testAttributes", testAttributes),
        ("testAttributesQuotes", testAttributesQuotes),
    ]

}
