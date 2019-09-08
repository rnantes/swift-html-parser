//
//  ElementSelector.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-05-27.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

// based on Xpath and selector
public struct ElementSelector {
    var nodeTypes: [NodeType]?
    var tagName: String?
    var id: String?
    var classNames: [String]?
    var attributes: [AttributeSelector]?
    var position: Int?

    // inner text
    var innerTextContains: [String]?
    var innerTextCount: Int?

    // inner CData
    var innerCDataContains: [String]?
    var innerCDataCount: Int?

    // comments
    var commentsContains: [String]?
    var commentsCount: Int?

    // childElementsSelectors
    var childElementSelectors: [ElementSelector]?

    public init(tagName: String, id: String? = nil,
                nodeTypes: [NodeType]? = nil,
                classNames: [String]? = nil,
                attributes: [AttributeSelector]? = nil,
                position: Int? = nil,
                innerTextContains: [String]? = nil,
                innerTextCount: Int? = nil,
                innerCDataContains: [String]? = nil,
                innerCDataCount: Int? = nil,
                commentsContains: [String]? = nil,
                commentsCount: Int? = nil,
                childElementSelectors: [ElementSelector]? = nil
                ) {
        self.nodeTypes = nodeTypes
        self.tagName = tagName
        self.id = id
        self.classNames = classNames
        self.attributes = attributes
        self.position = position

        // inner text
        self.innerTextContains = innerTextContains
        self.innerTextCount = innerTextCount

        // inner CData
        self.innerCDataContains = innerCDataContains
        self.innerCDataCount = innerCDataCount

        // comments
        self.commentsContains = commentsContains
        self.commentsCount = commentsCount

        // childElementsSelectors
        self.childElementSelectors = childElementSelectors
    }
}
