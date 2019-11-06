//
//  TextStringSelectorBuilder.swift
//  
//
//  Created by Reid Nantes on 2019-10-31.
//

import Foundation

public protocol TextStringSelectorBuilder {
    var text: StringSelector { get }
}

public extension TextStringSelectorBuilder {
    /// Matches when the target equals the given value
    func withText(_ value: String) -> Self {
        self.text.withString(value)
        return self
    }

    /// Matches when the target equals any of the given values
    func whenTextIsAny(_ values: [String]) -> Self {
        self.text.whenStringIsAny(values)
        return self
    }

    /// Matches when the target contains the given value
    func containingText(_ value: String) -> Self {
        self.text.whenStringContainsAny([value])
        return self
    }

    /// Matches when the target contains any of the given values
    func whenTextContainsAny(_ keywords: [String]) -> Self {
        self.text.whenStringContainsAny(keywords)
        return self
    }

    /// Matches when the target contains all of the given values
    func whenTextContainsAll(_ keywords: [String]) -> Self {
        self.text.whenStringContainsAll(keywords)
        return self
    }

    // negatives
    /// Does not match when the target equals the given value
    func whenTextIsNot(_ value: String) -> Self {
        self.text.whenStringIsNot(value)
        return self
    }

    /// Does not match if the target equals any of the given values
    func whenTextIsNotAny(_ values: [String]) -> Self {
        self.text.whenStringIsNotAny(values)
        return self
    }

    /// Does not match if the target contains the given value
    func whenTextDoesNotContain(_ keyword: String) -> Self {
        self.text.whenStringDoesNotContainAny([keyword])
        return self
    }

    /// Does not match if the target contains any of the given values
    func whenTextDoesNotContainAny(_ keywords: [String]) -> Self {
        self.text.whenStringDoesNotContainAny(keywords)
        return self
    }

    /// Does not match if the target contains all of the given values
    func whenTextDoesNotContainAll(_ keywords: [String]) -> Self {
        self.text.whenStringDoesNotContainAll(keywords)
        return self
    }
}
