//
//  Element.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

final class ElementParser {

    fileprivate var localCurrentIndex: String.Index = String.Index.init(utf16Offset: 0, in: "")
    fileprivate var childNodes = [Node]()
    fileprivate var outerNodes = [Node]()

    fileprivate var openedTags = [Tag]()

    init(openedTags: [Tag]) {
        self.openedTags = openedTags
    }

    /// Iterate through the string to find opening and closing tags
    func parseNextElement(pageSource: String, currentIndex: String.Index, depth: Int, parseFormat: ParseFormat) throws -> (element: Element?, outerNodes: [Node]) {
        self.localCurrentIndex = currentIndex

        // get opening tag
        var localOpeningTag: Tag? = nil
        if openedTags.count == 0 {
            do {
                let result = try TagParser().getNextTag(source: pageSource, currentIndex: localCurrentIndex)
                self.outerNodes = result.childNodes
                localOpeningTag = result.tag
            } catch {
                throw error
            }

            if let openingTag = localOpeningTag {
                openedTags.append(openingTag)
                if ProjectConfig.shouldPrintTags {
                    printOpeningTag(tag: openingTag, depth: depth)
                }
            }
        } else {
            localOpeningTag = openedTags.last
        }

        // check if opening tag is actually a closing tag, this would be invalid
        guard let finalOpeningTag = localOpeningTag else {
            return (nil, outerNodes)
        }

        if finalOpeningTag.isClosingTag {
            print("FAIL: Opening tag is a closing tag")
        }

        // update current index to the character after the last tag character
        localCurrentIndex = pageSource.index(finalOpeningTag.endIndex, offsetBy: 1)

        // check if script opening tag
        if finalOpeningTag.tagName.lowercased() == "script" {
            let scriptParser = ScriptParser()
            do {
                let scriptParseResult = try scriptParser.parseScript(source: pageSource, currentIndex: currentIndex)
                return (Element.init(openingTag: finalOpeningTag,
                                    closingTag: scriptParseResult.closingScriptTag,
                                    childNodes: [scriptParseResult.innerTextBlock],
                                    depth: depth), outerNodes)
            } catch {
                throw error
            }
        }

        // check if emptyElement
        if finalOpeningTag.isEmptyElementTag || (parseFormat == .xml && finalOpeningTag.tagName == "?xml") {
            return (Element.init(openingTag: finalOpeningTag,
                                closingTag: nil,
                                childNodes: [],
                                depth: depth), outerNodes)
        }

        var localParseFormat = parseFormat
        if finalOpeningTag.tagName.lowercased() == "svg" {
            localParseFormat = .svg
        }

        var closingTag: Tag? = nil
        while closingTag == nil {
            do {
                closingTag = try findClosingTag(pageSource: pageSource,
                                                     depth: depth,
                                                     parseFormat: localParseFormat)
            } catch ParseError.closingTagNameDoesNotMatchOpeningTagName(let erroredTag) {
                if ProjectConfig.shouldPrintWarnings {
                    print("WARNING: Closing tag name does not match opening tag name: '\(erroredTag.tagName)'. ignoring")
                }
            } catch {
                throw error
            }
        }

        return (Element.init(openingTag: finalOpeningTag,
                            closingTag: closingTag,
                            childNodes: childNodes,
                            depth: depth), outerNodes)
    }

    func findClosingTag(pageSource: String, depth: Int, parseFormat: ParseFormat) throws -> Tag {
        let tagParser = TagParser()

        // get child elements until closing tag is found (or end of file reached)
        while localCurrentIndex < pageSource.endIndex {
            guard let openingTag = openedTags.last else {
                throw ParseError.canNotFindClosingTagWithoutAnyOpenedTags
            }

            var nextTagResult: Tag?
            do {
                let result = try tagParser.getNextTag(source: pageSource, currentIndex: localCurrentIndex)
                self.childNodes.append(contentsOf: result.childNodes)
                nextTagResult = result.tag
            } catch {
                throw error
            }
            guard let nextTag = nextTagResult else {
                throw ParseError.closingTagNotFound("Could not find closing tag for opening tag: \(openingTag.tagName)")
            }

            // update current index to the character after the last tag character
            localCurrentIndex = pageSource.index(nextTag.endIndex, offsetBy: 1)

            if nextTag.isEmptyElementTag || ((parseFormat == .svg || parseFormat == .xml) && nextTag.isSelfClosing) {
                // check for invalid closing tag on empty an element
                // For example <input></input>
                if nextTag.isEmptyElementTag && nextTag.checkIsClosingTag() {
                    localCurrentIndex = pageSource.index(nextTag.endIndex, offsetBy: 1)
                } else {
                    // empty element - add to child elements of parent and start looking for next tag
                    let childElement = Element.init(openingTag: nextTag,
                                                    closingTag: nil,
                                                    childNodes: [],
                                                    depth: depth + 1)
                    childNodes.append(childElement)
                    localCurrentIndex = pageSource.index(childElement.endIndex, offsetBy: 1)
                }

                if ProjectConfig.shouldPrintTags {
                    printOpeningTag(tag: nextTag, depth: depth + 1)
                }
            } else if nextTag.isClosingTag {
                if "/\(openingTag.tagName)" != nextTag.tagName {
                    // if nextTag is a closing tag of a empty element ignore it ex <input type="text"></input
                    // otherwise throw an error
                    if nextTag.isEmptyElementTag == false {
                        if nextTag.isClosingTag {
                            if hasMatchingOpenedTagName(nextTag.tagName) {
                                // add missing tag
                                let missingTag = Tag.init(startIndex: pageSource.index(before: nextTag.startIndex),
                                                          endIndex: pageSource.index(before: nextTag.startIndex),
                                                          tagText: openingTag.tagText,
                                                          tagName: openingTag.tagName)
                                return missingTag
                            } else {
                                // other - throw error
                                localCurrentIndex = pageSource.index(nextTag.endIndex, offsetBy: 1)
                                throw ParseError.closingTagNameDoesNotMatchOpeningTagName(erroredTag: nextTag)
                            }
                        } else {
                            // ignore
                            return try findClosingTag(pageSource: pageSource,
                                                      depth: depth,
                                                      parseFormat: parseFormat)
                        }
                    }
                } else {
                    // matching closing tag found
                    if ProjectConfig.shouldPrintTags {
                        printClosingTag(tag: nextTag, depth: depth)
                    }

                    openedTags.removeLast()
                    return nextTag
                }
            } else if nextTag.tagName.lowercased() == "script" {
                if ProjectConfig.shouldPrintTags {
                    printOpeningTag(tag: nextTag, depth: depth + 1)
                }

                // is script tag
                let scriptParser = ScriptParser()
                do {
                    let scriptParseResult = try scriptParser.parseScript(source: pageSource, currentIndex: localCurrentIndex)
                    let scriptElement = Element.init(openingTag: nextTag,
                                                     closingTag: scriptParseResult.closingScriptTag,
                                                     childNodes: [scriptParseResult.innerTextBlock],
                                                     depth: depth)
                    childNodes.append(scriptElement)
                    localCurrentIndex = pageSource.index(scriptElement.endIndex, offsetBy: 1)

                    if ProjectConfig.shouldPrintTags {
                        printClosingTag(tag: scriptParseResult.closingScriptTag, depth: depth + 1)
                    }
                } catch {
                    throw error
                }
            } else {
                // nextTag is an opening tag - add child element
                if ProjectConfig.shouldPrintTags {
                    printOpeningTag(tag: nextTag, depth: depth + 1)
                }

                do {
                    openedTags.append(nextTag)
                    let childElement = try ElementParser(openedTags: openedTags).parseNextElement(pageSource: pageSource,
                                                                                                  currentIndex: localCurrentIndex,
                                                                                                  depth: depth + 1,
                                                                                                  parseFormat: parseFormat)

                    guard let element = childElement.element else {
                        throw ParseError.endOfFileReachedBeforeClosingTagFound
                    }
                    openedTags.removeLast()
                    childNodes.append(contentsOf: childElement.outerNodes)
                    childNodes.append(element)
                    localCurrentIndex = pageSource.index(element.endIndex, offsetBy: 1)
                } catch {
                    throw error
                }
            }
        }

        // closing tag not found - throw error
        throw ParseError.closingTagNotFound("Could not find a closing tag. openedTags: \(openedTags)")
    }

    func hasMatchingOpenedTagName(_ tagName: String) -> Bool {
        let closingTagName = tagName.replacingOccurrences(of: "/", with: "")

        for openedTag in openedTags.reversed() {
            if openedTag.tagName == closingTagName {
                return true
            }
        }

        return false
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
