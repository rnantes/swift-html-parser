//
//  Attribute.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

public struct Attribute: Node {
    public var nodeType = NodeType.attribute
    public var name: String
    public var value: String?

    var nameStartIndex: String.Index
    var nameEndIndex: String.Index

    var valueStartIndex: String.Index?
    var valueEndIndex: String.Index?
    var valueStartIndexWithQuotes: String.Index?
    var valueEndIndexWithQuotes: String.Index?

    public var endIndex: String.Index {
        if valueEndIndexWithQuotes != nil {
            return valueEndIndexWithQuotes!
        }

        if valueEndIndex != nil {
            return valueEndIndex!
        }

        return nameEndIndex
    }

    public var startIndex: String.Index {
        return nameStartIndex
    }

    public init(nameStartIndex: String.Index,
         nameEndIndex: String.Index,
         valueStartIndex: String.Index?,
         valueEndIndex: String.Index?,
         valueStartIndexWithQuotes: String.Index?,
         valueEndIndexWithQuotes: String.Index?,
         name: String,
         value: String?) {
        self.nameStartIndex = nameStartIndex
        self.nameEndIndex = nameEndIndex

        self.valueStartIndex = valueStartIndex
        self.valueEndIndex = valueEndIndex

        self.valueStartIndexWithQuotes = valueStartIndexWithQuotes
        self.valueEndIndexWithQuotes = valueEndIndexWithQuotes

        self.name = name
        self.value = value
    }
}
