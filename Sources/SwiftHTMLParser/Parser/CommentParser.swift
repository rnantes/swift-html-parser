//
//  CommentParser.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-08.
//

import Foundation

struct CommentSpecialCharacters {
    // strings
    let declarationOpening = "<!"
    let commentOpening = "<!--"
    let commentClosing = "-->"
    let declarationClosing = ">"
    let conditionalCommentOpening = "<!--[if"
    let conditionalCommentClosing = "<![endif]-->"
}

enum CommentType {
    case comment
    case declaration
}

/// Parses comments
struct CommentParser {
    fileprivate let lookaheadValidator = LookaheadValidator()
    fileprivate let SpecialCharacters = CommentSpecialCharacters()

    /// Parses a comment starting at currentIndex
    /// Example of a comment: <!-- This is a comment -->
    func parseComment(source: String, currentIndex: String.Index, commentType: CommentType) throws -> Comment {
        let startIndex = currentIndex

        // skip over html comment opening i.e <!--
        var textStartIndex = source.index(currentIndex, offsetBy: 4)
        if commentType == .declaration {
            textStartIndex = source.index(currentIndex, offsetBy: 2)
        }
        var localCurrentIndex = textStartIndex

        while localCurrentIndex < source.endIndex {
            var hasFoundClosing = false
            if commentType == .comment {
                hasFoundClosing = lookaheadValidator.isValidLookahead(for: source,
                                                                      atIndex: localCurrentIndex,
                                                                      checkFor: SpecialCharacters.commentClosing)
            } else {
                hasFoundClosing = lookaheadValidator.isValidLookahead(for: source,
                                                                      atIndex: localCurrentIndex,
                                                                      checkFor: SpecialCharacters.declarationClosing)
            }
            if hasFoundClosing {
                var endIndex = source.index(localCurrentIndex, offsetBy: 2)
                var textEndIndex = source.index(localCurrentIndex, offsetBy: -1)

                if commentType == .declaration {
                    endIndex = source.index(localCurrentIndex, offsetBy: 1)
                    textEndIndex = source.index(localCurrentIndex, offsetBy: -1)
                }

                return Comment.init(startIndex: startIndex,
                                    endIndex: endIndex,
                                    textStartIndex: textStartIndex,
                                    textEndIndex: textEndIndex,
                                    text: String(source[textStartIndex...textEndIndex]))
            }

            // increment localCurrentIndex
            localCurrentIndex = source.index(after: localCurrentIndex)
        }

        // throw error if a tag not found before end of file reached
        throw ParseError.endOfFileReachedBeforeCommentCloseFound
    }

    /// Parses a conditonal comment starting at currentIndex
    /// Example of a conditional comment :  <!--[if IE 6]> <div> <![endif]-->
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

                print(source.subscring(after: endIndex, numberOfCharacters: 10))
                return Comment.init(startIndex: startIndex,
                                    endIndex: endIndex,
                                    textStartIndex: textStartIndex,
                                    textEndIndex: textEndIndex,
                                    text: String(source[textStartIndex...textEndIndex]))
            }

            // increment localCurrentIndex
            localCurrentIndex = source.index(after: localCurrentIndex)
        }

        // throw error if a tag not found before end of file reached
        throw ParseError.endOfFileReachedBeforeCommentCloseFound
    }

}
