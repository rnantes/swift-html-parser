//
//  ElementSelector.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-05-27.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

/// based on Xpath and selector
public protocol NodeSelector: AnyObject, PositionIntSelectorBuilder {

    /// Tests the element against the current Node
    func testAgainst(_ node: Node) -> Bool
}

//extension NodeSelector {
//
////    /// Matches when position is less than the given value
////    func whenPositionLessThan(_ position: Int) -> NodeSelector {
////
////    }
////
////    /// Matches when position is greater than the given value
////    func whenPositionGreaterThan(_ position: Int) -> NodeSelector {
////
////    }
//}
