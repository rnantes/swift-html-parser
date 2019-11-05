//
//  AttributeParser.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-05.
//

import Foundation

struct AttributeParser {

    enum AttributeParserState {
        case lookingForAttributeName
        case readingAttributeName
        case readingFirstAttributeValue
        case readingAttributeValue
        case foundAttribute
    }

    enum AttributeValueParseState {
        case withinDoubleQuotes
        case withinSingleQuotes
        case notWithinQuotes
    }

    fileprivate let specificCharacters = TagSpecificCharacters()

    func parseAttributes(tagText: String, tagName: String) -> [String: Attribute] {
        var attributes = [String: Attribute]()
        
        let regexHelper = RegexHelper()
        let tagNameRegexPattern = "^(<\\s*\(tagName))"
        let rangeOfTagNameResult = regexHelper.firstMatchRange(for: tagNameRegexPattern, inString: tagText)
        guard let rangeOfTagName = rangeOfTagNameResult else {
            //print("Error: Could not find tag name in tag text")
            return attributes
        }
        var currentIndex = rangeOfTagName.upperBound

        var couldNotFindAttribute = false
        while currentIndex < tagText.endIndex && couldNotFindAttribute == false {
            do {
                let attribute = try getNextAttribute(tagText: tagText, currentIndex: currentIndex)
                attributes[attribute.name] = attribute
                // set the currentIndex to endIndex of the attribute
                currentIndex = tagText.index(attribute.endIndex, offsetBy: 1)
            } catch {
                couldNotFindAttribute = true
            }
        }

        return attributes
    }

    func getNextAttribute(tagText: String, currentIndex: String.Index) throws -> Attribute {
        var localCurrentIndex = currentIndex

        var parserState = AttributeParserState.lookingForAttributeName
        var nameStartIndex: String.Index?
        var nameEndIndex: String.Index?

        var valueParseState = AttributeValueParseState.notWithinQuotes
        var valueStartIndex: String.Index?
        var valueEndIndex: String.Index?
        var valueStartIndexWithQuotes: String.Index?
        var valueEndIndexWithQuotes: String.Index?

        while localCurrentIndex < tagText.endIndex && parserState != .foundAttribute {

            switch parserState {
            case .lookingForAttributeName:
                if tagText[localCurrentIndex].isWhitespace == false {
                    nameStartIndex = localCurrentIndex
                    parserState = .readingAttributeName
                }
            case .readingAttributeName:
                if tagText[localCurrentIndex] == specificCharacters.equalSign {
                    // attribute name ended - continue looking for value
                    nameEndIndex = tagText.index(localCurrentIndex, offsetBy: -1)
                    parserState = .readingFirstAttributeValue
                }
                if tagText[localCurrentIndex].isWhitespace {
                    // attribute name only
                    nameEndIndex = tagText.index(localCurrentIndex, offsetBy: -1)
                    parserState = .foundAttribute
                }
                if tagText[localCurrentIndex] == specificCharacters.tagClosingCharacter {
                    // end of tag - attribute name only
                    nameEndIndex = tagText.index(localCurrentIndex, offsetBy: -1)
                    parserState = .foundAttribute
                }
            case .readingFirstAttributeValue:
                if tagText[localCurrentIndex] == specificCharacters.doubleQuote {
                    // dont include quotes in valueStartIndex (only in valueStartIndexWithQuotes)
                    valueStartIndexWithQuotes = localCurrentIndex
                    valueParseState = .withinDoubleQuotes
                }
                if tagText[localCurrentIndex] == specificCharacters.singleQuote {
                    // dont include quotes in valueStartIndex (only in valueStartIndexWithQuotes)
                    valueStartIndexWithQuotes = localCurrentIndex
                    valueParseState = .withinSingleQuotes
                }
                parserState = .readingAttributeValue
            case .readingAttributeValue:
                switch valueParseState {
                case .notWithinQuotes:
                    if tagText[localCurrentIndex].isWhitespace {
                        // attribute name only
                        valueEndIndex = tagText.index(localCurrentIndex, offsetBy: -1)
                        parserState = .foundAttribute
                    }
                    if tagText[localCurrentIndex] == specificCharacters.tagClosingCharacter {
                        // end of tag - attribute name only
                        valueEndIndex = tagText.index(localCurrentIndex, offsetBy: -1)
                        parserState = .foundAttribute
                    }
                case .withinDoubleQuotes:
                    if tagText[localCurrentIndex] == specificCharacters.doubleQuote {
                        valueEndIndexWithQuotes = localCurrentIndex
                        parserState = .foundAttribute
                    }

                case .withinSingleQuotes:
                    if tagText[localCurrentIndex] == specificCharacters.singleQuote {
                        valueEndIndexWithQuotes = localCurrentIndex
                        parserState = .foundAttribute
                    }
                }
            case .foundAttribute:
                break
            }

            // increment localCurentIndex
            localCurrentIndex = tagText.index(localCurrentIndex, offsetBy: 1)
        }

        if let nameStartIndex = nameStartIndex, let nameEndIndex = nameEndIndex {
            let name = String(tagText[nameStartIndex...nameEndIndex])
            var value: String?

            var isAttributeValueAnEmptyString = false
            if let valueStartIndexWithQuotes = valueStartIndexWithQuotes, let valueEndIndexWithQuotes = valueEndIndexWithQuotes {
                // value is within qutoes
                if tagText.distance(from: valueStartIndexWithQuotes, to: valueEndIndexWithQuotes) == 1 {
                    // value is empty string - i.e ""
                    isAttributeValueAnEmptyString = true
                    valueStartIndex = valueStartIndexWithQuotes
                    valueEndIndex = valueEndIndexWithQuotes
                    value = ""
                } else {
                    // value is not empty string
                    valueStartIndex = tagText.index(valueStartIndexWithQuotes, offsetBy: 1)
                    valueEndIndex = tagText.index(valueEndIndexWithQuotes, offsetBy: -1)
                }
            }

            // set value
            if isAttributeValueAnEmptyString == false {
                if let valueStartIndex = valueStartIndex, let valueEndIndex = valueEndIndex {
                    value = String(tagText[valueStartIndex...valueEndIndex])
                }
            }

            return Attribute.init(nameStartIndex: nameStartIndex,
                                  nameEndIndex: nameEndIndex,
                                  valueStartIndex: valueStartIndex,
                                  valueEndIndex: valueEndIndex,
                                  valueStartIndexWithQuotes: valueStartIndexWithQuotes,
                                  valueEndIndexWithQuotes: valueEndIndexWithQuotes,
                                  name: name,
                                  value: value)
        }

        throw ParseError.attributeNotFound
    }
}
