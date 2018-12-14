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
    var tagName: String?
    var id: String?
    var classNames: [String]?
    var position: Int?

    // inner text
    var innerTextContains: [String]? = nil
    var innerTextCount: Int? = nil

    // inner CData
    var innerCDataContains: [String]? = nil
    var innerCDataCount: Int? = nil

    // comments
    var commentsContains: [String]? = nil
    var commentsCount: Int? = nil

    public init(tagName: String, id: String? = nil,
                classNames: [String]? = nil,
                position: Int? = nil,
                innerTextContains: [String]? = nil,
                innerTextCount: Int? = nil,
                innerCDataContains: [String]? = nil,
                innerCDataCount: Int? = nil,
                commentsContains: [String]? = nil,
                commentsCount: Int? = nil
                ) {
        self.tagName = tagName
        self.id = id
        self.classNames = classNames
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
    }
}
