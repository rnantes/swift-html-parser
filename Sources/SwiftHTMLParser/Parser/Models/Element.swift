//
//  ElementF.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

public struct Element: Node {
    var openingTag: Tag
    var closingTag: Tag?

    var innerTextBlocks: [TextBlock]
    var innerCData: [CData]
    var comments: [Comment]
    var nodeOrder: [NodeType]

    var childElements: [Element]

    // index information
    var depth:Int

    var startIndex: String.Index {
        get {
            return openingTag.startIndex
        }
    }
    var endIndex: String.Index {
        get {
            if closingTag != nil {
                return closingTag!.endIndex
            } else {
                return openingTag.endIndex
            }
        }
    }

    var isEmptyElement: Bool {
        get {
            return openingTag.isEmptyElementTag
        }
    }

    var isSelfClosingElement: Bool {
        get {
            return openingTag.isSelfClosing
        }
    }

    var tagName: String {
        return openingTag.tagName
    }

    var id: String? {
        return openingTag.attributes["id"]?.value
    }

    var classNames: [String] {
        return openingTag.classNames
    }

    init(openingTag: Tag, closingTag: Tag?, innerTextBlocks: [TextBlock], innerCData: [CData], comments: [Comment], nodeOrder: [NodeType], childElements: [Element], depth: Int) {
        self.depth = depth
        self.openingTag = openingTag
        self.closingTag = closingTag
        self.innerTextBlocks = innerTextBlocks
        self.innerCData = innerCData
        self.comments = comments
        self.nodeOrder = nodeOrder
        self.childElements = childElements
        self.depth = depth
    }

    func attribute(attributeName: String) -> Attribute? {
        return openingTag.attributes[attributeName]
    }

    func attributeValue(for attributeName: String) -> String? {
        return openingTag.attributes[attributeName]?.value
    }

    func containsAttribute(_ attributeName: String) -> Bool {
        if openingTag.attributes[attributeName] != nil {
            return true
        } else {
            return false
        }
    }

    func innerTextBlocksContains(text: String) -> Bool {
        for innerTextBlock in innerTextBlocks {
            if innerTextBlock.text.contains(text) {
                return true
            }
        }

        return false
    }

    func innerCDataContains(text: String) -> Bool {
        for cData in innerCData {
            if cData.text.contains(text) {
                return true
            }
        }

        return false
    }

    func commentsContains(text: String) -> Bool {
        for comment in comments {
            if comment.text.contains(text) {
                return true
            }
        }

        return false
    }
}
