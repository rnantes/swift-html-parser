//
//  Element.swift
//  HTMLParser
//
//  Created by Reid Nantes on 2018-02-13.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

class ElementParser {

    fileprivate var localCurrentIndex: String.Index = String.Index.init(utf16Offset: 0, in: "")
    fileprivate var childNodes = [Node]()
    fileprivate var outerNodes = [Node]()

    /// Iterate through the string to find opening and closing tags
    func parseNextElement(pageSource: String, currentIndex: String.Index, openingTag: Tag?, depth: Int, parseFormat: ParseFormat) throws -> (element: Element?, outerNodes: [Node]) {
        self.localCurrentIndex = currentIndex
        var localOpeningTag = openingTag

        if openingTag == nil {
            // get opening tag - set
            let tagParser = TagParser()
            do {
                let result = try tagParser.getNextTag(source: pageSource, currentIndex: localCurrentIndex)
                self.outerNodes = result.childNodes
                localOpeningTag = result.tag
            } catch {
                throw error
            }

            if let finalOpeningTag = localOpeningTag {
                if ProjectConfig.shouldPrintTags {
                    printOpeningTag(tag: finalOpeningTag, depth: depth)
                }

                if finalOpeningTag.attributes["id"]?.value == "animation-frame-99" {
                    print("found")
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
            } else {
                return (nil, outerNodes)
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
                                                         parseFormat: localParseFormat)

                return (Element.init(openingTag: finalOpeningTag,
                                    closingTag: localClosingTag,
                                    childNodes: childNodes,
                                    depth: depth), outerNodes)
            } catch ParseError.closingTagNameDoesNotMatchOpeningTagName(let erroredTag) {
                if ProjectConfig.shouldPrintWarnings {
                    print("WARNING: Closing tag name does not match opening tag name. Adding missing cloing Tag.")
                }

                let missingTag = Tag.init(startIndex: pageSource.index(before: erroredTag.startIndex),
                                          endIndex: pageSource.index(before: erroredTag.startIndex),
                                          tagText: finalOpeningTag.tagText,
                                          tagName: finalOpeningTag.tagName)
                return (Element.init(openingTag: finalOpeningTag,
                                    closingTag: missingTag,
                                    childNodes: childNodes,
                                    depth: depth), outerNodes)
            } catch {
                throw error
            }
    }

    func findClosingTag(pageSource: String, openingTag: Tag, depth: Int, parseFormat: ParseFormat) throws -> Tag {
        let tagParser = TagParser()

        // get child elements until closing tag is found (or end of file reached)
        while localCurrentIndex < pageSource.endIndex {
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
                        // ignore
                        localCurrentIndex = pageSource.index(nextTag.endIndex, offsetBy: 1)
                        throw ParseError.closingTagNameDoesNotMatchOpeningTagName(erroredTag: nextTag)
                    }
                } else {
                    // matching closing tag found
                    if ProjectConfig.shouldPrintTags {
                        printClosingTag(tag: nextTag, depth: depth)
                    }
                    return nextTag
                }
            } else if  nextTag.tagName.lowercased() == "script" {
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
                // nextTag is not a closing tag - add child element

                if ProjectConfig.shouldPrintTags {
                    printOpeningTag(tag: nextTag, depth: depth + 1)
                }

                let elementParser = ElementParser()
                do {
                    let childElement = try elementParser.parseNextElement(pageSource: pageSource,
                                                                          currentIndex: localCurrentIndex,
                                                                          openingTag: nextTag,
                                                                          depth: depth + 1,
                                                                          parseFormat: parseFormat)
                    if let element = childElement.element {
                        childNodes.append(contentsOf: childElement.outerNodes)
                        childNodes.append(element)
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
        throw ParseError.closingTagNotFound("Could not find closing tag for opening tag: \(openingTag.tagName)")
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
