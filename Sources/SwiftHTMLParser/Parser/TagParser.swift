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

enum TagOpeningType {
    case element
    case CDATA
    case declaration
    case comment
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
    let declarationOpening = "<!"
    let commentOpening = "<!--"
    let commentClosing = "-->"
    let conditionalCommentOpening = "<!--[if"
    let conditionalCommentClosing = "<![endif]-->"
    let CDATAOpening = "<![CDATA["
    let CDATAClosing = "]]>"

    // array

}

struct TagParser {
    fileprivate let commentParser = CommentParser()
    fileprivate let cdataParser = CDATAParser()
    fileprivate let lookaheadValidator = LookaheadValidator()
    fileprivate let specificCharacters = TagSpecificCharacters()
    fileprivate let isPoorlyFormattedCommentsAllowed: Bool = true

    func getNextTag(source: String, currentIndex: String.Index) throws -> (childNodes: [Node], tag: Tag?) {
        var isTagOpened = false
        var localCurrentIndex = currentIndex
        var tagStartIndex: String.Index?

        var childNodes = [Node]()
        var parseState = TagParserState.notWithinQuotesOrComment

        // iterate through string indices until tag is found or end of string
        while source.encompassesIndex(localCurrentIndex) {

            if isTagOpened == false {
                if parseState == .notWithinQuotesOrComment {
                    if let tagOpeningType = resolveTagOpeningType(source: source, index:
                        localCurrentIndex) {

                        // set inner text block
                        if (currentIndex != localCurrentIndex) {
                            var textBlockStartIndex = currentIndex

                            // changed
                            if let lastChildNode = childNodes.last {
                                textBlockStartIndex = source.index(lastChildNode.endIndex, offsetBy: 1)
                            }

                            let textBlockEndIndex = source.index(localCurrentIndex, offsetBy: -1)

                            // if tags or comments are right beside each other dont add text block i.e </tag><!--- a comment -->
                            if textBlockStartIndex <= textBlockEndIndex {
                                let textBlockText = String(source[textBlockStartIndex...textBlockEndIndex])
                                if (textBlockText.isEmptyOrWhitespace() == false) {
                                    let innerTextBlock = TextNode.init(startIndex: textBlockStartIndex,
                                                                       endIndex: textBlockEndIndex,
                                                                       text: textBlockText)
                                    childNodes.append(innerTextBlock)
                                }
                            }
                        }

                        switch tagOpeningType {
                        case .element:
                            isTagOpened = true
                            tagStartIndex = localCurrentIndex
                        case .comment:
                            do {
                                let comment = try commentParser.parseComment(source: source,
                                                                             currentIndex: localCurrentIndex,
                                                                             commentType: .comment)
                                localCurrentIndex = comment.endIndex
                                childNodes.append(comment)
                            } catch {
                                throw ParseError.endOfFileReachedBeforeCommentCloseFound
                            }
                        case .declaration:
                            do {
                                let comment = try commentParser.parseComment(source: source,
                                                                             currentIndex: localCurrentIndex,
                                                                             commentType: .declaration)
                                localCurrentIndex = comment.endIndex
                                childNodes.append(comment)
                            } catch {
                                throw ParseError.endOfFileReachedBeforeCommentCloseFound
                            }
                        case .CDATA:
                            // is CDATA
                            do {
                                let cdata = try cdataParser.parse(source: source, currentIndex: localCurrentIndex)
                                localCurrentIndex = cdata.endIndex
                                childNodes.append(cdata)
                            } catch {
                                throw ParseError.endOfFileReachedBeforeCommentCloseFound
                            }
                        }
                    }
                }
            } else {
                switch parseState {
                case .notWithinQuotesOrComment:
                    if source[localCurrentIndex] == specificCharacters.tagClosingCharacter {
                        // tag is closed
                        do {
                            let tag = try foundTag(source: source, tagStartIndex: tagStartIndex!, tagEndIndex: localCurrentIndex)
                            return (childNodes, tag)
                        } catch {
                            throw error
                        }
                    }
                    if source[localCurrentIndex] == specificCharacters.doubleQuote {
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

//            if source.encompassesIndex(localCurrentIndex) {
//                print("localCurrentIndex: \(localCurrentIndex)")
//                print(source[localCurrentIndex])
//            }
        }

        // a tag not found before end of file reached
        return (childNodes, nil)
    }

    func resolveTagOpeningType(source: String, index: String.Index) -> TagOpeningType? {
        if source[index] == specificCharacters.tagOpeningCharacter {
            if lookaheadValidator.isValidLookahead(for: source, atIndex: index, checkFor: specificCharacters.declarationOpening) {
                // check if comment opening
                if lookaheadValidator.isValidLookahead(for: source, atIndex: index, checkFor: specificCharacters.commentOpening) {
                    return TagOpeningType.comment
                } else if lookaheadValidator.isValidLookahead(for: source, atIndex: index, checkFor: specificCharacters.CDATAOpening) {
                    return TagOpeningType.CDATA
                }
                return TagOpeningType.declaration
            }
            return TagOpeningType.element
        }
        return nil
    }

    /// produces a `tag` from the found tag text, parsing attributes etc
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
                if tagText[currentIndex] != TagSpecificCharacters().tagOpeningCharacter && tagText[currentIndex].isWhitespace == false {
                    isFirstCharacterFound = true
                    // add char to tag
                    startTagNameIndex = currentIndex
                }
            } else {
                if tagText[currentIndex] == ">" || tagText[currentIndex].isWhitespace {
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
