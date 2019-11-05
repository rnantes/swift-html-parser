//
//  Node.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

public protocol Node {
    var nodeType: NodeType { get }
    var startIndex: String.Index { get }
    var endIndex: String.Index { get }
}
