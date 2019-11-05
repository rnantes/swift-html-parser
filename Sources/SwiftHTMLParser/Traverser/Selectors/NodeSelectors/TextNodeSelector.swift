//
//  TextNodeSelector.swift
//  
//
//  Created by Reid Nantes on 2019-10-30.
//

import Foundation

public final class TextNodeSelector: NodeSelector, TextStringSelectorBuilder {
    private(set) public var text = StringSelector()
    private(set) public var position = IntSelector()

    // public init
    public init() {}

    public func testAgainst(_ node: Node) -> Bool {
        // return false if node is not an TextNode
        guard let textNode = node as? TextNode else {
            return false
        }

        if text.testAgainst(textNode.text) == false {
            return false
        }

        return true
    }


}
