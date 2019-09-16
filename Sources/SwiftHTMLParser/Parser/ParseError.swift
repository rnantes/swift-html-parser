//
//  ParseError.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-05.
//

import Foundation

enum ParseError: Error {
    case tagNotFound
    case tagNameNotFound
    case invalidTag
    case openingTagNotFound
    case canNotFindClosingTagWithoutAnyOpenedTags
    case closingTagNotFound(String)
    case attributeNotFound
    case closingTagNameDoesNotMatchOpeningTagName(erroredTag: Tag)
    case endOfFileReachedBeforeClosingTagFound
    case endOfFileReachedBeforeScriptClosingTagFound
    case endOfFileReachedBeforeCommentCloseFound
    case endOfFileReachedBeforeCDATACloseFound
    case invalidCDATA
}
