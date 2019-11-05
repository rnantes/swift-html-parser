//
//  TextNode.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

public struct TextNode: Node {
    public let nodeType = NodeType.text
    public var startIndex: String.Index
    public var endIndex: String.Index
    public var text: String

    init (startIndex: String.Index, endIndex: String.Index, text: String) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
