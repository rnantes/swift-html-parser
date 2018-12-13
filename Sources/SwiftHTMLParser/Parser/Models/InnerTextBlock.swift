//
//  InnerText.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

struct TextBlock: Node {
    var startIndex: String.Index
    var endIndex: String.Index
    var text: String

    init (startIndex: String.Index, endIndex: String.Index, text: String) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.text = text
    }
}
