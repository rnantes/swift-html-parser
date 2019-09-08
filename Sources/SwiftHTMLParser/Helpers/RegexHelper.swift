//
//  RegexHelper.swift
//  SwiftHTMLParser
//
//  Created by Reid Nantes on 2018-08-07.
//

import Foundation

struct RegexHelper {

    func matchRanges(for regexPattern: String, inString inputString: String) -> [Range<String.Index>] {
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive]) else {
            //print("invalid regex")
            return []
        }

        let range = NSRange(inputString.startIndex..., in: inputString)
        let matches = regex.matches(in: inputString, options: [], range: range)

        var matchRanges = [Range<String.Index>]()
        for match in matches {
            matchRanges.append(Range(match.range, in: inputString)!)
        }

        return matchRanges
    }

    func matches(for regexPattern: String, inString inputString: String) -> [String] {
        let matchRanges = self.matchRanges(for: regexPattern, inString: inputString)

        var matchingStrings = [String]()
        for range in matchRanges {
            matchingStrings.append(String(inputString[range]))
        }

        return matchingStrings
    }

    func firstMatchRange(for regexPattern: String, inString inputString: String) -> Range<String.Index>? {
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive]) else {
            //print("Invalid Regex Pattern: \(regexPattern)")
            return nil
        }

        let range = NSRange(inputString.startIndex..., in: inputString)
        let firstMatch = regex.firstMatch(in: inputString, options: [], range: range)

        if let match = firstMatch {
            // first match found
            return Range(match.range, in: inputString)!
        } else {
            // no match found
            return nil
        }
    }

    func firstMatch(for regexPattern: String, inString inputString: String) -> String? {
        let firstMatchRange = self.firstMatchRange(for: regexPattern, inString: inputString)

        if let range = firstMatchRange {
            // match found
            let matchingString = String(inputString[range])
            return matchingString
        } else {
            // no match found
            return nil
        }
    }

    func replaceFirstMatch(for regexPattern: String, inString inputString: String, withString replacementString: String) -> String {
        let firstMatchRange = self.firstMatchRange(for: regexPattern, inString: inputString)

        if let range = firstMatchRange {
            // match found
            return inputString.replacingCharacters(in: range, with: replacementString)
        } else {
            // no match found
            return inputString
        }
    }

    func replaceMatches(for regexPattern: String, inString inputString: String, withString replacementString: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            return inputString
        }

        let range = NSRange(inputString.startIndex..., in: inputString)
        return regex.stringByReplacingMatches(in: inputString, options: [], range: range, withTemplate: replacementString)
    }

}
