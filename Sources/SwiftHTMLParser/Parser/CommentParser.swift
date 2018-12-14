//
//  CommentParser.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

struct CommentSpecialCharacters {
    // strings
    let commentOpening = "<!--"
    let commentClosing = "-->"
    let conditionalCommentOpening = "<!--[if"
    let conditionalCommentClosing = "<![endif]-->"
}

struct CommentParser {
    fileprivate let lookaheadValidator = LookaheadValidator()
    fileprivate let SpecialCharacters = CommentSpecialCharacters()

    func parseComment(source: String, currentIndex: String.Index) throws -> Comment {
        let startIndex = currentIndex
        // skip over html comment opening i.e <!--
        let textStartIndex = source.index(currentIndex, offsetBy: 4)
        var localCurrentIndex = textStartIndex
        
        while localCurrentIndex < source.endIndex {
            if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,  checkFor: SpecialCharacters.commentClosing) {
                let endIndex = source.index(localCurrentIndex, offsetBy: 2)
                let textEndIndex = source.index(localCurrentIndex, offsetBy: -1)

                return Comment.init(startIndex: startIndex,
                                    endIndex: endIndex,
                                    textStartIndex: textStartIndex,
                                    textEndIndex: textEndIndex,
                                    text: String(source[textStartIndex...textEndIndex]))
            }

            // increment localCurrentIndex
            localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
        }

        // throw error if a tag not found before end of file reached
        throw ParseError.endOfFileReachedBeforeCommentCloseFound
    }

    func parseConditionalComment(source: String, currentIndex: String.Index) throws -> Comment {
        let startIndex = currentIndex
        // skip over html comment opening i.e <!--
        let textStartIndex = source.index(currentIndex, offsetBy: 4)
        var localCurrentIndex = textStartIndex

        while localCurrentIndex < source.endIndex {
            if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                   checkFor: SpecialCharacters.conditionalCommentClosing) {
                let endIndex = source.index(localCurrentIndex, offsetBy: 11)
                let textEndIndex = source.index(localCurrentIndex, offsetBy: -1)

                return Comment.init(startIndex: startIndex,
                                    endIndex: endIndex,
                                    textStartIndex: textStartIndex,
                                    textEndIndex: textEndIndex,
                                    text: String(source[textStartIndex...textEndIndex]))
            }

            // increment localCurrentIndex
            localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
        }

        // throw error if a tag not found before end of file reached
        throw ParseError.endOfFileReachedBeforeCommentCloseFound
    }
    
}
