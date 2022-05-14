//
//  TestElementTraverser.swift
//  
//
//  Created by Reid Nantes on 2019-10-22.
//

import XCTest
import SwiftHTMLParser
import TestFiles

final class ElementTraverserTests: XCTestCase {

    func testSelectTagName() {
        guard let fileURL = TestFileURLs.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-multiple-value-class.html") else {
                XCTFail("Could find get file URL to parse")
                return
        }

        var nodeTreeResult: [Node]? = nil
        do {
            nodeTreeResult = try TestHelper.openFileAndParseHTML(fileURL: fileURL)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        guard let nodeTree = nodeTreeResult else {
            XCTFail("nodeTreeResult was nil")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().containingTagName("bod"),
            ElementSelector().withTagName("p")
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertEqual(matchingElements.count, 4)
    }


    func testSelectAttributes() {
        guard let fileURL = TestFileURLs.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-simple.html") else {
                XCTFail("Could find get file URL to parse")
                return
        }

        var nodeTreeResult: [Node]? = nil
        do {
            nodeTreeResult = try TestHelper.openFileAndParseHTML(fileURL: fileURL)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        guard let nodeTree = nodeTreeResult else {
            XCTFail("nodeTreeResult was nil")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath: [NodeSelector] = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("a")
                .withAttribute(AttributeSelector.init(name: "href").withValue("https://duckduckgo.com"))
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is an alternate link")
    }

    func testSelectClassName() {
        guard let fileURL = TestFileURLs.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-multiple-value-class.html") else {
                XCTFail("Could find get file URL to parse")
                return
        }

        var nodeTreeResult: [Node]? = nil
        do {
            nodeTreeResult = try TestHelper.openFileAndParseHTML(fileURL: fileURL)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        guard let nodeTree = nodeTreeResult else {
            XCTFail("nodeTreeResult was nil")
            return
        }

        // find matching elements by traversing the created html object
        var nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p")
                .withClassNamesAny(["body-paragraph"])
        ]

        var matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertTrue(matchingElements.count == 1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the second paragraph.")

        // find matching elements by traversing the created html object
        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p").withClassName("stylized-paragraph")

                //.withoutClassName("into-paragraph")
        ]

        matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertTrue(matchingElements.count == 4)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the first paragraph.")
        XCTAssertEqual(matchingElements[1].textNodes[0].text, "This is the second paragraph.")
        XCTAssertEqual(matchingElements[2].textNodes[0].text, "This is the third paragraph.")
        XCTAssertEqual(matchingElements[3].textNodes[0].text, "This is the fourth paragraph.")

        // find matching elements by traversing the created html object
        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p")
                .withClassNamesExact(["stylized-paragraph"])
        ]

        matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertTrue(matchingElements.count == 1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the third paragraph.")


        // find matching elements by traversing the created html object
        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p")
                .withoutClassNameAny(["into-paragraph"])
        ]
        matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertEqual(matchingElements.count, 3)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the second paragraph.")
        XCTAssertEqual(matchingElements[1].textNodes[0].text, "This is the third paragraph.")
        XCTAssertEqual(matchingElements[2].textNodes[0].text, "This is the fourth paragraph.")
    }

    func testSelectPosition() {
        guard let fileURL = TestFileURLs.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-multiple-value-class.html") else {
                XCTFail("Could find get file URL to parse")
                return
        }

        var nodeTreeResult: [Node]? = nil
        do {
            nodeTreeResult = try TestHelper.openFileAndParseHTML(fileURL: fileURL)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        guard let nodeTree = nodeTreeResult else {
            XCTFail("nodeTreeResult was nil")
            return
        }

        // test position equal
        var nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p").atPosition(1)
        ]
        var matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertTrue(matchingElements.count == 1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the second paragraph.")

        // test position greater than
        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p").whenPositionIsGreaterThan(1)
        ]
        matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertTrue(matchingElements.count == 2)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the third paragraph.")
        XCTAssertEqual(matchingElements[1].textNodes[0].text, "This is the fourth paragraph.")

        // test position less than
        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p").whenPositionIsLessThan(3)
        ]
        matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertTrue(matchingElements.count == 3)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the first paragraph.")
        XCTAssertEqual(matchingElements[1].textNodes[0].text, "This is the second paragraph.")
        XCTAssertEqual(matchingElements[2].textNodes[0].text, "This is the third paragraph.")
    }

    func testSelectInnerText() {
        guard let fileURL = TestFileURLs.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-multiple-value-class.html") else {
                XCTFail("Could find get file URL to parse")
                return
        }

        var nodeTreeResult: [Node]? = nil
        do {
            nodeTreeResult = try TestHelper.openFileAndParseHTML(fileURL: fileURL)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        guard let nodeTree = nodeTreeResult else {
            XCTFail("nodeTreeResult was nil")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p")
                .withChildTextNode(TextNodeSelector().withText("This is the second paragraph."))
        ]
        let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertEqual(matchingElements.count,  1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the second paragraph.")
    }

    func testSelectInnerComment() {
        guard let fileURL = TestFileURLs.attributesTestFilesDirectoryURL?
            .appendingPathComponent("attributes-multiple-value-class.html") else {
                XCTFail("Could find get file URL to parse")
                return
        }

        var nodeTreeResult: [Node]? = nil
        do {
            nodeTreeResult = try TestHelper.openFileAndParseHTML(fileURL: fileURL)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        guard let nodeTree = nodeTreeResult else {
            XCTFail("nodeTreeResult was nil")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p")
                .withChildCommentNode(CommentSelector().containingText("This is a comment"))
        ]
        let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)
        XCTAssertEqual(matchingElements.count,  1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "This is the fourth paragraph.")
    }

}

