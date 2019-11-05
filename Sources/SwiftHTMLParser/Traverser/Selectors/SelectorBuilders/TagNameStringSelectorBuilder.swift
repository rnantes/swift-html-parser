//
//  TagNameSelectorBuilder.swift
//  
//
//  Created by Reid Nantes on 2019-11-02.
//

import Foundation

public protocol TagNameStringSelectorBuilder {
    var tagName: StringSelector { get }
}

public extension TagNameStringSelectorBuilder {
    /// Matches when the target equals the given value
    func withTagName(_ value: String) -> Self {
        self.tagName.withString(value)
        return self
    }

    /// Matches when the target equals any of the given values
    func whenTagNameIsAny(_ values: [String]) -> Self {
        self.tagName.whenStringIsAny(values)
        return self
    }

    /// Matches when the target contains the given value
    func containingTagName(_ value: String) -> Self {
        self.tagName.whenStringContainsAny([value])
        return self
    }

    /// Matches when the target contains any of the given values
    func whenTagNameContainsAny(_ keywords: [String]) -> Self {
        self.tagName.whenStringContainsAny(keywords)
        return self
    }

    /// Matches when the target contains all of the given values
    func whenTagNameContainsAll(_ keywords: [String]) -> Self {
        self.tagName.whenStringContainsAll(keywords)
        return self
    }

    // negatives
    /// Does not match when the target equals the given value
    func whenTagNameIsNot(_ value: String) -> Self {
        self.tagName.whenStringIsNot(value)
        return self
    }

    /// Does not match if the target equals any of the given values
    func whenTagNameIsNotAny(_ values: [String]) -> Self {
        self.tagName.whenStringIsNotAny(values)
        return self
    }

    /// Does not match if the target contains the given value
    func whenTagNameDoesNotContain(_ keyword: String) -> Self {
        self.tagName.whenStringDoesNotContainAny([keyword])
        return self
    }

    /// Does not match if the target contains any of the given values
    func whenTagNameDoesNotContainAny(_ keywords: [String]) -> Self {
        self.tagName.whenStringDoesNotContainAny(keywords)
        return self
    }

    /// Does not match if the target contains all of the given values
    func whenTagNameDoesNotContainAll(_ keywords: [String]) -> Self {
        self.tagName.whenStringDoesNotContainAll(keywords)
        return self
    }
}
