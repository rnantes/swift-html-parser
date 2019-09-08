import XCTest
@testable import SwiftHTMLParser

final class SwiftHTMLParserTests: XCTestCase {

    func testOpenFile() {
        guard let fileURL = TestsConfig.elementsTestFilesDirectoryURL?
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
        guard let fileURL = TestsConfig.elementsTestFilesDirectoryURL?
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

        print(htmlString)

        // create object from raw html file
        let htmlParser = HTMLParser()
        guard let nodeArray = try? htmlParser.parse(pageSource: htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 2)

        // find matching elements by traversing the created html object
        var elementSelectorPath: [ElementSelector] = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "head"),
            ElementSelector.init(tagName: "title")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: nodeArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].textNodes[0].text, "Test Simple Title")

        elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "p")
        ]

        matchingElements = traverser.findElements(in: nodeArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 3)
        XCTAssertEqual(matchingElements[1].textNodes[0].text, "This is the second paragraph.")
    }

    func testQuotes() {
        guard let fileURL = TestsConfig.elementsTestFilesDirectoryURL?
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
        let matchingElements = traverser.findElements(in: elementArray,
                                                      matchingElementSelectorPath: elementSelectorPath)


        XCTAssertEqual(matchingElements.count, 4)
        XCTAssertEqual(matchingElements[0].textNodes.first!.text, "'John \"ShotGun\" Nelson'")
        XCTAssertEqual(matchingElements[1].textNodes.first!.text, "\"John 'ShotGun' Nelson\"")
        XCTAssertEqual(matchingElements[2].textNodes.first!.text, "It's alright")
        XCTAssertEqual(matchingElements[3].textNodes.first!.text, "I love the \" (double Quote) character")
    }

    func testClosingEmptyTag() {
        guard let fileURL = TestsConfig.elementsTestFilesDirectoryURL?
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
        let htmlParser = HTMLParser()
        guard let nodeArray = try? htmlParser.parse(pageSource: htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        // find matching elements by traversing the created html object
        let elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "form")
        ]

        let traverser = HTMLTraverser()
        let matchingElements = traverser.findElements(in: nodeArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].childElements.count, 1)
    }

    static var allTests = [
        ("testOpenFile", testOpenFile),
        ("testSimple", testSimple),
        ("testQuotes", testQuotes),
        ("testClosingEmptyTag", testClosingEmptyTag)
    ]
}
