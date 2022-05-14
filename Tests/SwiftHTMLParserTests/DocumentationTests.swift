//
//  DocumentationTests.swift
//  
//
//  Created by Reid Nantes on 2019-11-04.
//

import XCTest
@testable import SwiftHTMLParser
import TestFiles

final class DocumentationTests: XCTestCase {

    func parseAndTraverseSimpleHTML() throws {
        // get string from file
        let fileURL = TestFileURLs.documentationTestFilesDirectoryURL!.appendingPathComponent("simple.html")
        let htmlString = try String(contentsOf: fileURL, encoding: .utf8)

        // parse the htmlString into a tree of node objects (DOM)
        let nodeTree = try HTMLParser.parse(htmlString)

        // create a node selector path to describe what nodes to match in the nodeTree
        let nodeSelectorPath: [NodeSelector] = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div").atPosition(0),
            ElementSelector().withTagName("p").withClassName("body-paragraph")
        ]

        // find the elements that match the nodeSelectorPath
        // notice we use the findElements() function which only matches elements
        let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)

        // matchingElements will contain the 3 matching <p> elements with the className 'body-paragraph'
        // will print: 3
        print(matchingElements.count)
    }

    func parseAndTraverseSimpleHTMLTextNode() throws {
        // get string from file
        let fileURL = TestFileURLs.documentationTestFilesDirectoryURL!.appendingPathComponent("simple.html")
        let htmlString = try String(contentsOf: fileURL, encoding: .utf8)

        // parse the htmlString into a tree of node objects (DOM)
        let nodeTree = try HTMLParser.parse(htmlString)

        // create a node selector path to describe what nodes to match in the nodeTree
        // this is equvalent to the selector: body > p or xpath: /html/body/p
        let nodeSelectorPath: [NodeSelector] = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div").withClassName("bibliography"),
            ElementSelector().withTagName("ul"),
            ElementSelector().withTagName("li").withId("citation-1999"),
            TextNodeSelector()
        ]

        // find the nodes that match the nodeSelectorPath
        // Notice we use the findNodes() function which can match with any node type
        let matchingNodes = HTMLTraverser.findNodes(in: nodeTree, matching: nodeSelectorPath)

        // matchingNodes will contain the matching node
        // we have to cast the Node to a TextNode to access its text property
        guard let paragraphTextNode = matchingNodes.first as? TextNode else {
            // could not find paragraph text node
            return
        }

        // will print: This is the second citation.
        print(paragraphTextNode.text)
    }

    func testParseAndTraverseSimpleHTMLChildNodeSelectorPath() throws {
        // get string from file
        let fileURL = TestFileURLs.documentationTestFilesDirectoryURL!.appendingPathComponent("simple.html")
        let htmlString = try String(contentsOf: fileURL, encoding: .utf8)

        // parse the htmlString into a tree of node objects (DOM)
        let nodeTree = try HTMLParser.parse(htmlString)

        // create a child node selector path that will match the parent node
        // only if the childNodeSelectorPath matches the element's child nodes
        let childNodeSelectorPath: [NodeSelector] = [
            ElementSelector().withTagName("div"),
            ElementSelector().withTagName("p"),
            TextNodeSelector().withText("Editor Notes")
        ]

        // create a node selector path to describe what nodes to match in the nodeTree
        // Notice the last ElementSelector will only match if the element contains
        // child nodes that match the childNodeSelectorPath
        let nodeSelectorPath: [NodeSelector] = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div").withChildNodeSelectorPath(childNodeSelectorPath),
        ]

        // find the nodes that match the nodeSelectorPath
        // Notice we use the findNodes() function which can match with any node type
        let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)

        // matchingElements should only contain the div element with the 'essay' class namee
        // will print: 1
        print(matchingElements.count)

        guard let divElement = matchingElements.first else {
            // could not find paragraph text node
            XCTFail("could not find paragraph text node")
            return
        }

        guard let firstClassName = divElement.classNames.first else {
            // divElement does not have any classnames
            XCTFail("divElement does not have any classnames")
            return
        }

        // will print: essay
        print(firstClassName)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(firstClassName, "essay")
    }

}
