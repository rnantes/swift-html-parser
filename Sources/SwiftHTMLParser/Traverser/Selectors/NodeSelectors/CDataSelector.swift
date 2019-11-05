//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-10-29.
//

import Foundation

final class CDataSelector: NodeSelector, TextStringSelectorBuilder {
    var position = IntSelector()
    internal var text = StringSelector()

    func testAgainst(_ node: Node) -> Bool {
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
