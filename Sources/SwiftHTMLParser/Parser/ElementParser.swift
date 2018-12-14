//
//  Element.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

class ElementParser {

    fileprivate var localCurrentIndex = String.Index.init(encodedOffset: 0)
    fileprivate var childElements = [Element]()

    fileprivate var innerTextBlocks = [TextBlock]()
    fileprivate var innerCData = [CData]()
    fileprivate var comments = [Comment]()
    fileprivate var nodeOrder = [NodeType]()

    fileprivate var outerTextBlocks = [TextBlock]()
    fileprivate var outerCData = [CData]()
    fileprivate var outerComments = [Comment]()
    fileprivate var outerNodeOrder = [NodeType]()


    // iterate through string to find opening and closing tags
    func parseNextElement(pageSource: String, currentIndex: String.Index, openingTag: Tag?, depth: Int, parseFormat: ParseFormat) throws -> Element? {
        self.localCurrentIndex = currentIndex
        self.childElements = []
        var localOpeningTag = openingTag

        if openingTag == nil {
            // get opening tag - set
            let tagParser = TagParser()
            do {
                let result = try tagParser.getNextTag(source: pageSource, currentIndex: localCurrentIndex)
                self.outerTextBlocks = result.innerTextBlocks
                self.outerCData = result.innerCData
                self.outerComments = result.comments
                self.outerNodeOrder = result.nodeOrder
                localOpeningTag = result.tag
            } catch {
                throw error
            }

            if let finalOpeningTag = localOpeningTag {
                printOpeningTag(tag: finalOpeningTag, depth: depth)

                // update current index to the character after the last tag character
                localCurrentIndex = pageSource.index(finalOpeningTag.endIndex, offsetBy: 1)

                // check if script opening tag
                if finalOpeningTag.tagName.lowercased() == "script" {
                    let scriptParser = ScriptParser()
                    do {
                        let scriptParseResult = try scriptParser.parseScript(source: pageSource, currentIndex: currentIndex)
                        return Element.init(openingTag: finalOpeningTag,
                                            closingTag: scriptParseResult.closingScriptTag,
                                            innerTextBlocks: [scriptParseResult.innerTextBlock],
                                            innerCData: [],
                                            comments: [],
                                            nodeOrder: [],
                                            childElements: [],
                                            depth: depth)
                    } catch {
                        throw error
                    }
                }

                // check if emptyElement
                if finalOpeningTag.isEmptyElementTag || (parseFormat == .xml && finalOpeningTag.tagName == "?xml"){
                    return Element.init(openingTag: finalOpeningTag,
                                        closingTag: nil,
                                        innerTextBlocks: [],
                                        innerCData: [],
                                        comments: [],
                                        nodeOrder: [],
                                        childElements: [],
                                        depth: depth)
                }
            } else {
                return nil
            }
        }

        guard let finalOpeningTag = localOpeningTag else {
            throw ParseError.tagNotFound
        }

        var localParseFormat = parseFormat
        if finalOpeningTag.tagName.lowercased() == "svg" {
            localParseFormat = .svg
        }

        do {
            let localClosingTag = try findClosingTag(pageSource: pageSource,
                                                     openingTag: finalOpeningTag,
                                                     depth: depth,
                                                     parseFormat:localParseFormat)

            return Element.init(openingTag: finalOpeningTag,
                                closingTag: localClosingTag,
                                innerTextBlocks: innerTextBlocks,
                                innerCData: innerCData,
                                comments: comments,
                                nodeOrder: nodeOrder,
                                childElements: childElements,
                                depth: depth)
        } catch {
            throw error
        }
    }

    func findClosingTag(pageSource: String, openingTag: Tag, depth: Int, parseFormat: ParseFormat) throws -> Tag {
        let tagParser = TagParser()

        // get child elements until closing tag is found (or end of file reached)
        while localCurrentIndex < pageSource.endIndex {
            var nextTagResult: Tag? = nil
            do {
                let result = try tagParser.getNextTag(source: pageSource, currentIndex: localCurrentIndex)
                self.innerTextBlocks.append(contentsOf: result.innerTextBlocks)
                self.innerCData.append(contentsOf: result.innerCData)
                self.comments.append(contentsOf: result.comments)
                self.nodeOrder.append(contentsOf: result.nodeOrder)
                nextTagResult = result.tag
            } catch {
                throw error
            }
            guard let nextTag = nextTagResult else {
                throw ParseError.closingTagNotFound
            }

            // update current index to the character after the last tag character
            localCurrentIndex = pageSource.index(nextTag.endIndex, offsetBy: 1)


            if nextTag.isClosingTag {
                if "/\(openingTag.tagName)" != nextTag.tagName {
                    // if nextTag is a closing tag of a empty element ignore it ex <input type="text"></input
                    // otherwise throw an error
                    if (nextTag.isEmptyElementTag == false) {
                        throw ParseError.closingTagNameDoesNotMatchOpeningTagName
                    }
                } else {
                    // matching closing tag found
                    printClosingTag(tag: nextTag, depth: depth)
                    return nextTag
                }
            } else if nextTag.isEmptyElementTag || (parseFormat == .svg || parseFormat == .xml && nextTag.isSelfClosing) {
                // empty element - add to child elements of parent and start looking for next tag
                let childElement = Element.init(openingTag: nextTag,
                                                closingTag: nil,
                                                innerTextBlocks: [],
                                                innerCData: [],
                                                comments: [],
                                                nodeOrder: [],
                                                childElements: [],
                                                depth: depth + 1)
                childElements.append(childElement)
                localCurrentIndex = pageSource.index(childElement.endIndex, offsetBy: 1)
                printOpeningTag(tag: nextTag, depth: depth + 1)
            } else if  nextTag.tagName.lowercased() == "script" {
                printOpeningTag(tag: nextTag, depth: depth + 1)
                // is script tag
                let scriptParser = ScriptParser()
                do {
                    let scriptParseResult = try scriptParser.parseScript(source: pageSource, currentIndex: localCurrentIndex)
                    let scriptElement = Element.init(openingTag: nextTag,
                                                     closingTag: scriptParseResult.closingScriptTag,
                                                     innerTextBlocks: [scriptParseResult.innerTextBlock],
                                                     innerCData: [],
                                                     comments: [],
                                                     nodeOrder: [],
                                                     childElements: [],
                                                     depth: depth)
                    childElements.append(scriptElement)
                    localCurrentIndex = pageSource.index(scriptElement.endIndex, offsetBy: 1)

                    printClosingTag(tag: scriptParseResult.closingScriptTag, depth: depth + 1)
                } catch {
                    throw error
                }
            } else {
                printOpeningTag(tag: nextTag, depth: depth + 1)
                // nextTag is not a closing tag - add child element
                let elementParser = ElementParser()
                do {
                    let childElement = try elementParser.parseNextElement(pageSource: pageSource,
                                                                          currentIndex: localCurrentIndex,
                                                                          openingTag: nextTag,
                                                                          depth: depth + 1,
                                                                          parseFormat: parseFormat)
                    if let element = childElement {
                        childElements.append(element)
                        localCurrentIndex = pageSource.index(element.endIndex, offsetBy: 1)
                    } else {
                        throw ParseError.endOfFileReachedBeforeClosingTagFound
                    }
                } catch {
                    throw error
                }
            }
        }

        // closing tag not found - throw error
        throw ParseError.closingTagNotFound
    }


    func printOpeningTag(tag: Tag, depth: Int) {
        // indent based on depth
        let indent = "  "

        var i = 0
        while i < depth {
            print(indent, terminator: "")
            i += 1
        }

        var idString = ""
        if let id = tag.attributes["id"] {
            if let idValue = id.value {
                idString = " id=\"\(idValue)\""
            }

        }

        if tag.isEmptyElementTag {
            print("<\(tag.tagName)\(idString) EE\\>")
        } else {
            print("<\(tag.tagName)\(idString)>")
        }
    }

    func printClosingTag(tag: Tag, depth: Int) {
        // indent based on depth
        let indent = "  "

        var i = 0
        while i < depth {
            print(indent, terminator: "")
            i += 1
        }

        print("<\(tag.tagName)>")
    }

}
