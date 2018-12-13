//
//  ElementSelector.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-05-27.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

// based on Xpath and selector


struct ElementSelector {
    var tagName: String?
    var id: String?
    var classNames: [String]?
    var position: Int?

    init(tagName: String, id: String? = nil, classNames: [String]? = nil, position: Int? = nil) {
        self.tagName = tagName
        self.id = id
        self.classNames = classNames
        self.position = position
    }
}
