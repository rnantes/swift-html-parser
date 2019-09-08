//
//  HTMLParser.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

public class HTMLParser {

    public init() {}

    /// Parses an html or xml string and outputs an node/element tree
    public func parse(pageSource: String, format: ParseFormat = .html, shouldHonourConditionalComments: Bool = true) throws -> [Node] {
        var rootElements = [Node]()
        let source = removeIEStatments(pageSource: pageSource)
        var currentIndex = source.startIndex

        var isEndOfFileReached = false
        while currentIndex < source.endIndex && isEndOfFileReached == false {
            let elementParser = ElementParser()
            do {
                let rootElementAndOuterNodes = try elementParser.parseNextElement(pageSource: pageSource,
                                                                                  currentIndex: currentIndex,
                                                                                  openingTag: nil,
                                                                                  depth: 0,
                                                                                  parseFormat: format)

                rootElements.append(contentsOf: rootElementAndOuterNodes.outerNodes)
                // check if an element was found
                if let element = rootElementAndOuterNodes.element {
                    // set the currentIndex to end of rootElement index
                    currentIndex = source.index(element.endIndex, offsetBy: 1)
                    rootElements.append(element)
                } else {
                    // element was not found, end of file reached without error
                    isEndOfFileReached = true
                }
            } catch {
                throw error
            }
        }

        return rootElements
    }

    // removed conditional IE statement.
    // example; <!--[if lt IE 9]>BLAH BLAH BLAH<![endif]-->
    func removeIEStatments(pageSource: String) -> String {
        //let pattern = "<!--\\[[\\s\\S]*<!\\[endif\\]-->"
        //return pageSource.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])

        return pageSource
    }
}
