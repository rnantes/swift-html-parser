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

    public var innerTextBlocks: [TextBlock]
    public var innerCData: [CData]
    public var comments: [Comment]
    public var nodeOrder: [NodeType]

    public var childElements: [Element]

    // index information
    public var depth:Int

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

     public var isEmptyElement: Bool {
        get {
            return openingTag.isEmptyElementTag
        }
    }

    public var isSelfClosingElement: Bool {
        get {
            return openingTag.isSelfClosing
        }
    }

    public var tagName: String {
        return openingTag.tagName
    }

    public var id: String? {
        return openingTag.attributes["id"]?.value
    }

    public var classNames: [String] {
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

    public func attribute(attributeName: String) -> Attribute? {
        return openingTag.attributes[attributeName]
    }

    public func attributeValue(for attributeName: String) -> String? {
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
