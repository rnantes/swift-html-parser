//
//  CommentSelector.swift
//  
//
//  Created by Reid Nantes on 2019-10-31.
//

import Foundation

public final class CommentSelector: NodeSelector, TextStringSelectorBuilder {
    private(set) public var position = IntSelector()
    private(set) public var text = StringSelector()

    // public init
    public init() {}

    /// returns true if the Node = satisfies the selector
    public func testAgainst(_ node: Node) -> Bool {
        // return false if node is not an CommentNode
        guard let comment = node as? Comment else {
            return false
        }

        if text.testAgainst(comment.text) == false {
            return false
        }

        return true
    }
}
