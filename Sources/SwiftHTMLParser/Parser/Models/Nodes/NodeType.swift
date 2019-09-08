//
//  NodeType.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

public enum NodeType: Int {
    case element = 1
    case attribute = 2
    case text = 3
    case CDATASection = 4
    case comment = 8
    case documentType = 10
}
