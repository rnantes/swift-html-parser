//
//  Comment.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

public struct Comment: Node {
    public let nodeType = NodeType.comment
    public var startIndex: String.Index
    public var endIndex: String.Index

    var textStartIndex: String.Index
    var textEndIndex: String.Index

    public var text: String

    init (startIndex: String.Index, endIndex: String.Index, textStartIndex: String.Index, textEndIndex: String.Index, text: String) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.textStartIndex = textStartIndex
        self.textEndIndex = textEndIndex

        self.text = text
    }
}
