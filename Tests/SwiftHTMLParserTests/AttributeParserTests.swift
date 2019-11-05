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
        guard let nodeTree = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        var nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("a")
        ]

        var matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 2)

        // test basic example
        XCTAssertEqual(matchingElements[0].attributeValue(for: "href"), "https://www.google.com")

        // test multiple attributes
        // id short form and attribute id should be the same
        XCTAssertEqual(matchingElements[1].id!, "alternate-search-engine")
        XCTAssertEqual(matchingElements[1].attributeValue(for: "id")!, "alternate-search-engine")
        XCTAssertEqual(matchingElements[1].attributeValue(for: "href")!, "https://duckduckgo.com")


        // test empty attribute - ex <p emptyAtrribute="">
        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div")
        ]

        matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.first!.attributeValue(for: "emptyAtrribute")!, "")


        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("form"),
            ElementSelector().withTagName("input")
        ]

        matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)

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
        guard let elementArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p")
        ]

        let matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 2)

        // test attribute with double quotes within single quotes
        XCTAssertEqual(matchingElements[0].openingTag.attributes.count, 2)
        XCTAssertEqual(matchingElements[0].attributeValue(for: "title")!, "John \"ShotGun\" Nelson")

        // test attribute with single quotes within double quotes
        XCTAssertEqual(matchingElements[1].openingTag.attributes.count, 2)
        XCTAssertEqual(matchingElements[1].attributeValue(for: "title")!, "John 'ShotGun' Nelson")
    }

    func testAttributesTabs() {
        guard let fileURL = TestsConfig.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-tabs.html") else {
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

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("img")
        ]

        let matchingElements = HTMLTraverser.findElements(in: elementArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].openingTag.tagName, "img")

        // test attribute
        XCTAssertEqual(matchingElements[0].attributeValue(for: "height")!, "580")
        XCTAssertEqual(matchingElements[0].attributeValue(for: "width")!, "480")
        XCTAssertEqual(matchingElements[0].attributeValue(for: "src")!, "/some/img.jpg")
        XCTAssertEqual(matchingElements[0].attributeValue(for: "alt")!, "/some/other/img.png")
    }

    static var allTests = [
        ("testAttributes", testAttributes),
        ("testAttributesQuotes", testAttributesQuotes),
    ]

}
