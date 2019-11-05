//
//  CDATAParser.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-13.
//

import Foundation

struct CDATASpecialCharacters {
    // strings
    let CDATAOpening = "<![CDATA["
    let CDATAClosing = "]]>"
}

struct CDATAParser {
    fileprivate let lookaheadValidator = LookaheadValidator()
    fileprivate let specialCharacters = CDATASpecialCharacters()

    func parse(source: String, currentIndex: String.Index) throws -> CData {
        var localCurrentIndex = currentIndex
        let startIndex = currentIndex
        var textStartIndex: String.Index?

        // validate stating
        if lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                               checkFor: specialCharacters.CDATAOpening) {
            localCurrentIndex = source.index(localCurrentIndex, offsetBy: specialCharacters.CDATAOpening.count)
            textStartIndex = localCurrentIndex
        } else {
            throw ParseError.invalidCDATA
        }

        while localCurrentIndex < source.endIndex {
            if  lookaheadValidator.isValidLookahead(for: source, atIndex: localCurrentIndex,
                                                    checkFor: specialCharacters.CDATAClosing) {
                let textEndIndex = source.index(localCurrentIndex, offsetBy: -1)
                let endIndex = source.index(localCurrentIndex, offsetBy: (specialCharacters.CDATAClosing.count - 1))

                return CData.init(startIndex: startIndex,
                                    endIndex: endIndex,
                                    textStartIndex: textStartIndex!,
                                    textEndIndex: textEndIndex,
                                    text: String(source[textStartIndex!...textEndIndex]))
            }
            // increment localCurrentIndex
            localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
        }

        throw ParseError.endOfFileReachedBeforeCDATACloseFound
    }
}
