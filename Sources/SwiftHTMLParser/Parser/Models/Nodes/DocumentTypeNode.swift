//
//  DocumentTypeNode.swift
//  
//
//  Created by Reid Nantes on 2019-09-07.
//

import Foundation

struct DocumentTypeNode: Node {
    public let nodeType = NodeType.documentType
    public var startIndex: String.Index
    public var endIndex: String.Index
    public var name: String
}
