//
//  Comment.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

struct Comment: Node  {
    var startIndex: String.Index
    var endIndex: String.Index

    var textStartIndex: String.Index
    var textEndIndex: String.Index

    var text: String

    init (startIndex: String.Index, endIndex: String.Index, textStartIndex: String.Index, textEndIndex: String.Index, text: String) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.textStartIndex = textStartIndex
        self.textEndIndex = textEndIndex

        self.text = text
    }
}