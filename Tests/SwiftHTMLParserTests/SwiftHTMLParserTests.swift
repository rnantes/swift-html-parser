import XCTest
@testable import SwiftHTMLParser

final class SwiftHTMLParserTests: XCTestCase {

    func testOpenFile() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Elements/elements-simple.html"
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

        XCTAssertEqual(htmlString.count, 253)
    }

    func testSimple() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Elements/elements-simple.html"
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

        XCTAssertEqual(elementArray.count, 2)

        // find matching elements by traversing the created html object
        var elementSelectorPath: [ElementSelector] = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "head"),
            ElementSelector.init(tagName: "title")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray,
                                                                         matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
        XCTAssertEqual(matchingElements[0].innerTextBlocks[0].text, "Test Simple Title")

        elementSelectorPath = [
            ElementSelector.init(tagName: "html"),
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "p")
        ]

        matchingElements = traverser.findElements(in: elementArray,
                                                                         matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements.count, 3)
        XCTAssertEqual(matchingElements[1].innerTextBlocks[0].text, "This is the second paragraph.")
    }

    func testQuotes() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Elements/elements-quotes.html"
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
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "p")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray,
                                                      matchingElementSelectorPath: elementSelectorPath)


        XCTAssertEqual(matchingElements.count, 4)
        XCTAssertEqual(matchingElements[0].innerTextBlocks.first!.text, "'John \"ShotGun\" Nelson'")
        XCTAssertEqual(matchingElements[1].innerTextBlocks.first!.text, "\"John 'ShotGun' Nelson\"")
        XCTAssertEqual(matchingElements[2].innerTextBlocks.first!.text, "It's alright")
        XCTAssertEqual(matchingElements[3].innerTextBlocks.first!.text, "I love the \" (double Quote) character")
    }

    func testClosingEmptyTag() {
        let relativePath = "/Tests/SwiftHTMLParserTests/TestFiles/Elements/empty-element.html"
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
            ElementSelector.init(tagName: "body"),
            ElementSelector.init(tagName: "form")
        ]

        let traverser = HTMLTraverser()
        var matchingElements = traverser.findElements(in: elementArray, matchingElementSelectorPath: elementSelectorPath)

        XCTAssertEqual(matchingElements[0].childElements.count, 1)
    }



    static var allTests = [
        ("testOpenFile", testOpenFile),
        ("testSimple", testSimple),
        ("testQuotes", testQuotes),
        ("testClosingEmptyTag", testClosingEmptyTag)
    ]
}
