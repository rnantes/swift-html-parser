//
//  Tag.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

// a closing or opening tag
public struct Tag {
    let startIndex: String.Index
    let endIndex: String.Index

    fileprivate var _isEmptyElementTag: Bool = false
    var isEmptyElementTag: Bool {
        return _isEmptyElementTag
    }
    fileprivate var _isClosingTag: Bool = false
    var isClosingTag: Bool {
        return _isClosingTag
    }
    fileprivate var _isSelfClosing: Bool = false
    var isSelfClosing: Bool {
        return _isSelfClosing
    }

    fileprivate var classNamesCache = [String]()
    var classNames: [String] {
        guard let classAttribute = attributes["class"] else {
            return []
        }

        guard let classAttributeValue = classAttribute.value else {
            return []
        }

        return getClassNames(classAttributeValue: classAttributeValue)
    }

    let tagText: String

    let tagName: String
    let attributes: [String: Attribute]

    public init(startIndex: String.Index, endIndex: String.Index, tagText: String, tagName: String) {
        self.startIndex = startIndex
        self.endIndex = endIndex

        self.tagText = tagText
        self.tagName = tagName

        let attributeParser = AttributeParser()
        self.attributes = attributeParser.parseAttributes(tagText: tagText, tagName: tagName)

        self._isSelfClosing = checkIsSelfClosing(tagText: tagText)
        self._isEmptyElementTag = checkIsEmptyElementTag(tagName: tagName)
        self._isClosingTag = checkIsClosingTag()
    }

    // checks if empty element
    // HTML elements with no content are called empty elements. Empty elements do not have an end tag (ex: <br>)
    func checkIsEmptyElementTag(tagName: String) -> Bool {
        let tagNameWithoutSlash = tagName.replacingOccurrences(of: "/", with: "")

        // check if known empty element
        if emptyElementTagNames.contains(tagNameWithoutSlash) {
            return true
        }

        // check if DOCTYPE
        if tagName.caseInsensitiveCompare("!DOCTYPE") == ComparisonResult.orderedSame {
            return true
        }

        return false
    }

    // check if tag is self closing, ending with />
    // ex: i.e <link href="/assets/css/myStyleSheet.css" rel=stylesheet />
    func checkIsSelfClosing(tagText: String) -> Bool {
        let lastCharacter = tagText[tagText.index(tagText.endIndex, offsetBy: -1)]
        let secondLastCharacter = tagText[tagText.index(tagText.endIndex, offsetBy: -2)]

        if lastCharacter == ">" && secondLastCharacter  == "/" {
            return true
        } else {
            return false
        }
    }

    func checkIsClosingTag() -> Bool {
        if tagText.prefix(2) == "</" {
            return true
        }

        if tagText == "<![endif]-->" {
            return true
        }

        return false
    }

    func getDescription() -> String {
        var description = ""
        description = description + "tagText: \(tagText)\n"
        description = description + "tagText.count: \(tagText.count)\n"
        description = description + "tag.startIndex: \(startIndex.utf16Offset(in: tagText))\n"
        description = description + "tag.endIndex: \(endIndex.utf16Offset(in: tagText))\n"

        return description
    }

    func getClassNames(classAttributeValue: String) -> [String] {
        // (?=\s*) -> 0 or more whitespaces, but dont capture
        // [\w\d]+ -> 1 or more non-whitespace characters
        let classNameRegexPattern = "(?=\\s*)[^\\n\\r\\s]+(?=\\s*)"

        let regexHelper = RegexHelper()
        return regexHelper.matches(for: classNameRegexPattern, inString: classAttributeValue)
    }

}
