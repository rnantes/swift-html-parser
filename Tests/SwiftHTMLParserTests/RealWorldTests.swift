//
//  RealWorldTests.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-11.
//

import XCTest
@testable import SwiftHTMLParser
import TestFiles

final class RealWorldTests: XCTestCase {
    func testGoogleHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
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

        // create object from raw html file
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 2)
    }

    func testWikipediaHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("wikipedia-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testESPNHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("espn-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testAppleHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("apple-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testAmazonHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("amazon-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testCNNHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("cnn-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testDigitalOceanHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("digitalocean-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testMediumHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("medium-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testYoutubeTrending() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("youtube-trending.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testRedditHomePage() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("reddit-home-page.html") else {
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

        XCTAssertEqual(elementArray.count, 2)
    }

    func testWeatherForcast() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("weather-forcast.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 4)
    }

    func testWeatherHourly() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("weather-hourly.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 4)
    }

    func testWeatherForcastXML() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("weather-forcast.xml") else {
                XCTFail("Could not get url to test file")
                return
        }

        // get html string from file
        var xmlStringResult: String? = nil
        do {
            xmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not open file at: \(fileURL.path)")
        }
        guard let xmlString = xmlStringResult else {
            XCTFail("Could not open file at: \(fileURL.path)")
            return
        }

        // create object from raw html file
        guard let nodeArray = try? XMLParser.parse(xmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 2)

        // find matching elements by traversing the created html object
        let childElementSelector = ElementSelector().withTagName("category")
            .withAttribute(AttributeSelector(name: "term").withValue("Current Conditions"))

        let nodeSelectorPath: [NodeSelector] = [
            ElementSelector().withTagName("feed"),
            ElementSelector().withTagName("entry").withChildElement(childElementSelector)
        ]

        let matchingElements = HTMLTraverser.findElements(in: nodeArray, matching: nodeSelectorPath)

        XCTAssertEqual(matchingElements.count, 1)
    }

    func testWeatherRadarHTML() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("weather-radar.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 4)
    }

    func testWeatherRadar2HTML() {
        guard let fileURL = TestFileURLs.realWorldTestFilesDirectoryURL?
            .appendingPathComponent("weather-radar-2.html") else {
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
        guard let nodeArray = try? HTMLParser.parse(htmlString) else {
            XCTFail("Could not parse HTML")
            return
        }

        XCTAssertEqual(nodeArray.count, 4)
    }
}


