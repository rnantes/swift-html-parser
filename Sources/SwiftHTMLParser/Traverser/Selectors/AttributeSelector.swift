//
//  AttributeSelector.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-14.
//

import Foundation

public final class AttributeSelector: ValueStringSelectorBuilder {
    var name: String
    var value = StringSelector()

    public init(name: String) {
        self.name = name
    }


    /// returns true if the element satisfies the selector
    internal func testSelector(against element: Element) -> Bool {
        let attributeValue = element.attributeValue(for: self.name)

        if value.testAgainst(attributeValue) == false {
            return false
        }

        return true
    }

}
