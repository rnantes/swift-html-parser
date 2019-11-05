//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-10-29.
//

import Foundation

public final class CDataSelector: NodeSelector, TextStringSelectorBuilder {
    private(set) public var position = IntSelector()
    private(set) public var text = StringSelector()

    // public init
    public init() {}

    public func testAgainst(_ node: Node) -> Bool {
        // return false if node is not an element
        guard let cdata = node as? CData else {
            return false
        }

        if text.testAgainst(cdata.text) == false {
            return false
        }

        return true
    }

    
}
