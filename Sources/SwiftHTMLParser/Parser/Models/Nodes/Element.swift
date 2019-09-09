//
//  ElementF.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

public struct Element: Node {
    public let nodeType = NodeType.element
    var openingTag: Tag
    var closingTag: Tag?

    public var childNodes: [Node]

    // index information
    public var depth: Int

    public var startIndex: String.Index {
        get {
            return openingTag.startIndex
        }
    }
    public var endIndex: String.Index {
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

    public let commentNodes: [Comment]
//    lazy var commentNodes: [Comment] = {
//        return childNodes.filter({ $0.nodeType == NodeType.comment }) as! [Comment]
//    }()

    public let textNodes: [TextNode]
//    lazy var textNodes: [TextNode] = {
//        return childNodes.filter({ $0.nodeType == NodeType.text }) as! [TextNode]
//    }()

    public let CDATASections: [CData]
//    lazy var CDATASections: [CData] = {
//        return childNodes.filter({ $0.nodeType == NodeType.CDATASection }) as! [CData]
//    }()

    public let childElements: [Element]
//    lazy var childElements: [Element] = {
//        return childNodes.filter({ $0.nodeType == NodeType.element }) as! [Element]
//    }()

    init(openingTag: Tag, closingTag: Tag?, childNodes: [Node], depth: Int) {
        self.depth = depth
        self.openingTag = openingTag
        self.closingTag = closingTag
        self.childNodes = childNodes
        self.depth = depth

        self.textNodes = childNodes.filter({ $0.nodeType == NodeType.text }) as! [TextNode]
        self.CDATASections = childNodes.filter({ $0.nodeType == NodeType.CDATASection }) as! [CData]
        self.commentNodes = childNodes.filter({ $0.nodeType == NodeType.comment }) as! [Comment]
        self.childElements = childNodes.filter({ $0.nodeType == NodeType.element }) as! [Element]
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
        for textNode in textNodes {
            if textNode.text.contains(text) {
                return true
            }
        }

        return false
    }

    func innerCDataContains(text: String) -> Bool {
        for cData in CDATASections {
            if cData.text.contains(text) {
                return true
            }
        }

        return false
    }

    func commentsContains(text: String) -> Bool {
        for comment in commentNodes {
            if comment.text.contains(text) {
                return true
            }
        }

        return false
    }
}
