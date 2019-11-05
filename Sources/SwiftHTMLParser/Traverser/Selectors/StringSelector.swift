//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-10-31.
//

import Foundation

public final class StringSelector {
    public init() {}

    /// Matches if the target is any of the keywords
    private(set) var stringIsAny: [String]?
    /// Matches if the target contains anhy the keywords
    private(set) var stringContainsAny: [String]?
    /// Matches if the target contains all the keywords
    private(set) var stringContainsAll: [String]?

    // negatives
    /// Does not match if the target is any of the keywords
    private(set) var stringIsNotAny: [String]?
    /// Does not match if the target contains any of the keywords
    private(set) var stringDoesNotContainAny: [String]?
    /// Does not match if the target contains all of the keywords
    private(set) var stringDoesNotContainAll: [String]?
}


internal extension StringSelector {
    func withString(_ value: String) {
        self.stringIsAny.appendOrInit(value)
    }

    func whenStringIsAny(_ values: [String]) {
        self.stringIsAny.appendOrInit(contentsOf: values)
    }

    /// matches when attribute value contains the given values
    func whenStringContainsAny(_ keywords: [String]) {
        self.stringContainsAny.appendOrInit(contentsOf: keywords)
    }

    /// matches when the target value does not contains the given values
    func whenStringContainsAll(_ keywords: [String]) {
        self.stringContainsAll.appendOrInit(contentsOf: keywords)
    }

    /// Does not match when the target equals the given value
    func whenStringIsNot(_ value: String) {
        self.stringIsNotAny.appendOrInit(value)
    }

    /// Does not match if the target equals any of the given values
    func whenStringIsNotAny(_ values: [String]) {
        self.stringIsNotAny.appendOrInit(contentsOf: values)
    }

    /// Does not match if the target contains any of the given values
    func whenStringDoesNotContainAny(_ values: [String]) {
        self.stringDoesNotContainAny.appendOrInit(contentsOf:  values)
    }

    /// Does not match if the target contains all of the given values
    func whenStringDoesNotContainAll(_ values: [String]) {
        self.stringDoesNotContainAll.appendOrInit(contentsOf:  values)
    }
}

extension StringSelector {
    func testAgainst(_ string: String?) -> Bool {
        guard let string = string else {
            if stringIsAny != nil || stringContainsAny != nil || stringContainsAll != nil  {
                return false
            } else {
                return true
            }
        }
        
        if let stringIsAny = stringIsAny {
            if stringIsAny.contains(where: { string == $0 }) == false {
                return false
            }
        }

        if let stringContainsAll = stringContainsAll {
            if stringContainsAll.allSatisfy({ string.contains($0) }) == false {
                return false
            }
        }

        if let stringContainsAny = stringContainsAny {
            if stringContainsAny.contains(where: { string.contains($0) }) == false {
                return false
            }
        }

        // negatives

        // fails if string is any of the keywords
        if let stringIsNotAny = stringIsNotAny {
            if stringIsNotAny.contains(where: { string == $0 }) == true {
                return false
            }
        }

        // fails if string contains any of the keywords
        if let stringDoesNotContainsAny = stringDoesNotContainAny {
            if stringDoesNotContainsAny.contains(where: { string.contains($0) }) == true {
                return false
            }
        }

        // fails if string contains all the keywords
        if let stringDoesNotContainsAll = stringDoesNotContainAll {
            if stringDoesNotContainsAll.allSatisfy({ string.contains($0) }) == true {
                return false
            }
        }

        return true
    }
}
