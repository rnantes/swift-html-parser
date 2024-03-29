import XCTest
@testable import SwiftHTMLParser
import TestFiles

final class SwiftHTMLParserTests: XCTestCase {

    func testOpenFile() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("elements-simple.html") else {
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

        XCTAssertTrue(htmlString.count > 100)
        XCTAssertTrue(htmlString.hasPrefix("<!DOCTYPE html>"))
        XCTAssertTrue(htmlString.contains("<html>"))
        XCTAssertTrue(htmlString.contains("<title>Test Simple Title</title>"))
        XCTAssertTrue(htmlString.contains("<h1>This is a Heading</h1>"))
        XCTAssertTrue(htmlString.contains("</html>"))
    }

    func testSimple() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("elements-simple.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 2)

        // find matching elements by traversing the created html object
        var nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("head"),
            ElementSelector().withTagName("title")
        ]

        var matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "Test Simple Title")

        nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("p")
        ]

        matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 3)
        XCTAssertEqual(matchingElements[1].textNodes[0].text, "This is the second paragraph.")
    }

    func testQuotes() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("elements-quotes.html") else {
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

        let matchingElements = HTMLTraverser.findElements(in: elementArray,
                                                      matching: nodeSelectorPath)


        XCTAssertEqual(matchingElements.count, 4)
        XCTAssertEqual(matchingElements[0].textNodes.first!.text, "'John \"ShotGun\" Nelson'")
        XCTAssertEqual(matchingElements[1].textNodes.first!.text, "\"John 'ShotGun' Nelson\"")
        XCTAssertEqual(matchingElements[2].textNodes.first!.text, "It's alright")
        XCTAssertEqual(matchingElements[3].textNodes.first!.text, "I love the \" (double Quote) character")
    }

    func testClosingEmptyTag() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("empty-element.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("form")
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].childElements.count, 1)
    }

    func testElementNameOnNewLine() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("element-name-on-new-line.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div")
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements.first?.tagName, "div")
        XCTAssertEqual(matchingElements.first?.attributeValue(for: "name"), "bob")
        XCTAssertEqual(matchingElements.first?.attributeValue(for: "type"), "email")
    }

    func testElementUnclosedEndTag() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("element-unclosed-end-tag.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div")
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements.first?.tagName, "div")
        XCTAssertEqual(matchingElements.first?.childElements.count,  1)
    }

    func testElementStrayEndTag() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("elemnent-stray-end-tag.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div")
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements.first?.tagName, "div")
        XCTAssertEqual(matchingElements.first?.childElements.count,  1)
    }
    
    func testElementStrayHTMLEndTag() {
        guard let fileURL = TestFileURLs.elementsTestFilesDirectoryURL?
            .appendingPathComponent("elemnent-stray-end-html-tag.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let nodeSelectorPath = [
            ElementSelector().withTagName("html"),
            ElementSelector().withTagName("body"),
            ElementSelector().withTagName("div")
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements.first?.tagName, "div")
        XCTAssertEqual(matchingElements.first?.childElements.count,  1)
    }
}
