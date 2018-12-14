//
//  AttributeSelector.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-14.
//

import Foundation

public struct AttributeSelector {
    var name: String
    var value: String?

    public init(name: String, value: String?) {
        self.name = name
        self.value = value
    }
}
