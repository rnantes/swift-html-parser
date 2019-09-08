//
//  ScriptParser.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-09.
//

import Foundation

struct ScriptParser {

    enum ScriptParseState {
        case notWithinQuotesOrComment
        case withinDoubleQuotes
        case withinSingleQuotes
        case withinMultiLineComment
        case withinSingleLineComment
    }

    struct ScriptSpecificCharacters {
        let scriptEndTag = "</script>"

        // strings
        let multiLineCommentOpening = "/*"
        let multiLineCommentClosing = "*/"
        let SingleLineCommentOpening = "//"

        let escapedBackslash = "\\\\"  // i.e \\
        let escapedDoubleQuote = "\\\"" // i.e \"
        let escapedSingleQuote = "\\'" // i.e \'

        // characters
        let doubleQuote: Character = "\"" // i.e "
        let singleQuote: Character  = "'" // i.e '
        let newline: Character = "\n"
    }

    fileprivate let lookaheadValidator = LookaheadValidator()

    // not intended to fully parse javascript, rather save it to inner text
    func parseScript(source: String, currentIndex: String.Index) throws -> (innerTextBlock: TextNode, closingScriptTag: Tag) {
        var localCurrentIndex = currentIndex
        var parseState = ScriptParseState.notWithinQuotesOrComment
        //var isTagOpened = false

        //var tagStartIndex: String.Index? = nil
        let specificCharacters = ScriptSpecificCharacters()

        while localCurrentIndex < source.endIndex {
            switch parseState {
            case .notWithinQuotesOrComment:
                if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex, checkFor: specificCharacters.scriptEndTag) {
                    let tagStartIndex = localCurrentIndex
                    let tagEndIndex = source.index(localCurrentIndex, offsetBy: 8)

                    // create tagText string from indexes
                    let tagText = String(source[tagStartIndex...tagEndIndex])
                    let tagName = "/script"

                    //define innerTextBlock
                    let textBlockStartIndex = currentIndex
                    let textBlockEndIndex = source.index(tagStartIndex, offsetBy: -1)
                    var textBlockString = ""
                    // create string if text block is not an empty string - i.e <script></script>
                    if (source.distance(from: textBlockStartIndex, to: textBlockEndIndex) > 0) {
                        textBlockString = String(source[textBlockStartIndex...textBlockEndIndex])
                    }

                    let innerTextBlock = TextNode.init(startIndex: textBlockStartIndex,
                                                        endIndex: textBlockEndIndex,
                                                        text: textBlockString)

                    let tag = Tag.init(startIndex: tagStartIndex, endIndex: tagEndIndex, tagText: tagText, tagName: tagName)
                    return (innerTextBlock, tag)
                }
                // look for quotes and comments
                if  source[localCurrentIndex] == specificCharacters.doubleQuote {
                    parseState = .withinDoubleQuotes
                } else if  source[localCurrentIndex] == specificCharacters.singleQuote {
                    parseState = .withinSingleQuotes
                } else if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                              checkFor: specificCharacters.multiLineCommentOpening) {
                    parseState = .withinMultiLineComment
                } else if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                              checkFor: specificCharacters.SingleLineCommentOpening) {
                    parseState = .withinSingleLineComment
                }
            case .withinDoubleQuotes:
                if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                       checkFor: specificCharacters.escapedBackslash) {
                    // is escaped backslash
                    localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
                } else if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                              checkFor: specificCharacters.escapedDoubleQuote) {
                    // is double quote escape character - increment localCurrentIndex past it
                    localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
                } else if source[localCurrentIndex] == specificCharacters.doubleQuote {
                    parseState = .notWithinQuotesOrComment
                }
            case .withinSingleQuotes:
                if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                       checkFor: specificCharacters.escapedBackslash) {
                    // is escaped backslash
                    localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
                } else if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                              checkFor: specificCharacters.escapedSingleQuote) {
                    // is single quoute escape character - increment localCurrentIndex past it
                    localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
                } else if source[localCurrentIndex] == specificCharacters.singleQuote {
                    parseState = .notWithinQuotesOrComment
                }
            case .withinMultiLineComment:
                if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                       checkFor: specificCharacters.multiLineCommentClosing) {
                    parseState = .notWithinQuotesOrComment
                }
            case .withinSingleLineComment:
                if source[localCurrentIndex] == specificCharacters.newline {
                    parseState = .notWithinQuotesOrComment
                }
            }

            //print(localCurrentIndex.encodedOffset)

//            if localCurrentIndex.encodedOffset % 100 == 0 {
//                print(localCurrentIndex.encodedOffset)
//            }

            // increment localCurrentIndex (go to next character in string)
            localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
        }

        // throw error if a tag not found before end of file reached
        throw ParseError.endOfFileReachedBeforeScriptClosingTagFound
    }

    func checkIfScriptClosingTag() {

    }
}
