//
//  LookAheadValidator.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-12-09.
//

import Foundation

struct LookaheadValidator {

    func isValidLookahead(for source: String, atIndex currentIndex: String.Index, checkFor stringToCheckFor: String) -> Bool {
        var localCurrentIndex = currentIndex
        var stringToCheckForCurrentIndex = stringToCheckFor.startIndex

        while stringToCheckForCurrentIndex < stringToCheckFor.endIndex {
            // check localCurrentIndex hasn't gone past soure endIndex
            if (localCurrentIndex > source.endIndex) {
                return false
            }

            // compare characters 
            if source[localCurrentIndex] != stringToCheckFor[stringToCheckForCurrentIndex] {
                // found a character in source that did not match lookahead
                return false
            }

            // increment localCurrentIndex and stringToCheckForCurrentIndex (go to next character in string)
            localCurrentIndex = source.index(localCurrentIndex, offsetBy: 1)
            stringToCheckForCurrentIndex = stringToCheckFor.index(stringToCheckForCurrentIndex, offsetBy: 1)
        }

        return true
    }
}
