//
//  AttributeSelector.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-14.
//

import Foundation

public class AttributeSelector: ValueStringSelectorBuilder {
    private(set) public var name: String
    private(set) public var value = StringSelector()

    public init(name: String) {
        self.name = name
    }

    public func withValue(_ value: String) -> Self {
        self.value.withString(value)
        return self
    }

    /// returns true if the element satisfies the selector
    public func testSelector(against element: Element) -> Bool {
        let attributeValue = element.attributeValue(for: self.name)

        if value.testAgainst(attributeValue) == false {
            return false
        }

        return true
    }

}
