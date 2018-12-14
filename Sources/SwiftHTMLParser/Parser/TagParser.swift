//
//  TagParser.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-04.
//

import Foundation

enum TagParserState {
    case notWithinQuotesOrComment
    case withinDoubleQuotes
    case withinSingleQuotes
}

struct TagSpecificCharacters {
    // characters
    let tagOpeningCharacter: Character = "<"
    let tagClosingCharacter: Character = ">"
    let doubleQuote: Character = "\"" // i.e "
    let singleQuote: Character  = "'" // i.e '
    let space: Character = " "
    let equalSign: Character = "="

    // strings
    let commentOpening = "<!--"
    let commentClosing = "-->"
    let conditionalCommentOpening = "<!--[if"
    let conditionalCommentClosing = "<![endif]-->"
}

struct TagParser {
    fileprivate let commentParser = CommentParser()
    fileprivate let lookaheadValidator = LookaheadValidator()
    fileprivate let specificCharacters = TagSpecificCharacters()

    func getNextTag(source: String, currentIndex: String.Index) throws -> (innerTextBlocks: [TextBlock], comments: [Comment], nodeOrder: [NodeType], tag: Tag?) {
        var isTagOpened = false
        var localCurrentIndex = currentIndex
        var tagStartIndex: String.Index? = nil

        var nodeOrder = [NodeType]()
        var comments = [Comment]()
        var innerTextBlocks = [TextBlock]()

        var parseState = TagParserState.notWithinQuotesOrComment

        // iterate through indices before end of string
        while isAtEndOfString(index: localCurrentIndex, endIndex: source.endIndex) == false {
            if isTagOpened == false {
                switch parseState {
                case .notWithinQuotesOrComment:
                    if source[localCurrentIndex] == specificCharacters.tagOpeningCharacter {
                        // found tag or comment opening

                        // set inner text block
                        if (currentIndex != localCurrentIndex) {
                            var textBlockStartIndex = currentIndex
                            if let lastComment = comments.last {
                                textBlockStartIndex = source.index(lastComment.endIndex, offsetBy: 1)
                            }
                            let textBlockEndIndex = source.index(localCurrentIndex, offsetBy: -1)

                            // if tags or comments are right beside each other dont add text block i.e </tag><!--- a comment -->
                            if textBlockStartIndex <= textBlockEndIndex {
                                let textBlockText = String(source[textBlockStartIndex...textBlockEndIndex])
                                let innerTextBlock = TextBlock.init(startIndex: textBlockStartIndex,
                                                                    endIndex: textBlockEndIndex,
                                                                    text: textBlockText)
                                innerTextBlocks.append(innerTextBlock)
                                nodeOrder.append(.text)
                            }
                        }

                        // check if it is a comment
                        if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                               checkFor: specificCharacters.commentOpening){
                            // is a comment
                            if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex, checkFor: specificCharacters.conditionalCommentOpening) {
                                // is conditional comment
                                // do nothing
                            }


                            do {
                                let comment = try commentParser.parseComment(source: source, currentIndex: localCurrentIndex)
                                localCurrentIndex = comment.endIndex
                                nodeOrder.append(.comment)
                                comments.append(comment)
                            } catch {
                                throw ParseError.endOfFileReachedBeforeCommentCloseFound
                            }
                        } else {
                            // tag is opened
                            isTagOpened = true
                            tagStartIndex = localCurrentIndex
                        }
                    }
                default:
                    // do nothing
                    break;
                }
            } else {
                switch parseState {
                case .notWithinQuotesOrComment:
                    if source[localCurrentIndex] == specificCharacters.tagClosingCharacter {
                        // tag is closed
                        do {
                            let tag = try foundTag(source: source, tagStartIndex: tagStartIndex!, tagEndIndex: localCurrentIndex)
                            if tag.isClosingTag == false {
                                nodeOrder.append(.element)
                            }
                            return (innerTextBlocks, comments, nodeOrder, tag)
                        } catch {
                            throw error
                        }
                    }
                    if source[localCurrentIndex] == specificCharacters.doubleQuote  {
                        parseState = .withinDoubleQuotes
                    } else if source[localCurrentIndex] == specificCharacters.singleQuote {
                        parseState = .withinSingleQuotes
                    }
                case .withinDoubleQuotes:
                    if source[localCurrentIndex] == specificCharacters.doubleQuote {
                        parseState = .notWithinQuotesOrComment
                    }
                case .withinSingleQuotes:
                    if source[localCurrentIndex] == specificCharacters.singleQuote {
                        parseState = .notWithinQuotesOrComment
                    }
                }
            }

            // increment localCurrentIndex
            localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
        }

        // a tag not found before end of file reached
        return (innerTextBlocks, comments, nodeOrder, nil)
    }

    func isAtEndOfString(index: String.Index, endIndex: String.Index) -> Bool {
        if (index < endIndex) {
            return false
        }

        return true
    }

    func foundTag(source: String, tagStartIndex: String.Index, tagEndIndex: String.Index) throws -> Tag {
        // create tagText string from indexes
        let tagText = String(source[tagStartIndex...tagEndIndex])

        // get tagName from tagText
        let tagNameResult: String?
        do {
            tagNameResult = try parseTagName(tagText: tagText)
        } catch {
            throw ParseError.tagNameNotFound
        }
        guard let tagName = tagNameResult else {
            throw ParseError.tagNameNotFound
        }

        // create the tag
        return Tag.init(startIndex: tagStartIndex, endIndex: tagEndIndex, tagText: tagText, tagName: tagName)
    }

    func parseTagName(tagText: String) throws -> String {
        var currentIndex = tagText.startIndex
        let endIndex = tagText.endIndex

        var startTagNameIndex: String.Index?

        var isFirstCharacterFound = false
        while currentIndex < endIndex {

            if isFirstCharacterFound == false {
                // keep going until you find the first char (ignore < and whitespace)
                if tagText[currentIndex] != "<" && tagText[currentIndex] != " " {
                    isFirstCharacterFound = true
                    // add char to tag
                    startTagNameIndex = currentIndex
                }
            } else {
                if tagText[currentIndex] == ">" || tagText[currentIndex] == " " {
                    // dont include last > or whitespace in tagName
                    let endTagNameIndex = tagText.index(currentIndex, offsetBy: -1)
                    let tagName = String(tagText[startTagNameIndex!...endTagNameIndex])
                    return tagName.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }

            currentIndex = tagText.index(currentIndex, offsetBy: 1)
        }
        

        throw ParseError.tagNameNotFound
    }

}
