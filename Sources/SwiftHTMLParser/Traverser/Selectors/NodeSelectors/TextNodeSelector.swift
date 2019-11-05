//
//  TextNodeSelector.swift
//  
//
//  Created by Reid Nantes on 2019-10-30.
//

import Foundation

final class TextNodeSelector: NodeSelector, TextStringSelectorBuilder {
    internal var text = StringSelector()
    var position = IntSelector()


    func testAgainst(_ node: Node) -> Bool {
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
