//
//  TestHelper.swift
//  
//
//  Created by Reid Nantes on 2019-10-25.
//

import Foundation
import SwiftHTMLParser


struct TestHelper {
    static func openFileAndParseHTML(fileURL: URL) throws -> [Node] {
        // get html string from file
        let htmlString = try String(contentsOf: fileURL, encoding: .utf8)

        // create object from raw html file
        let nodeTree = try HTMLParser.parse(htmlString)

        return nodeTree
    }
}
