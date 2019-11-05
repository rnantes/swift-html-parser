//
//  ValueStringSelectorBuilder.swift
//
//
//  Created by Reid Nantes on 2019-10-31.
//

import Foundation

public protocol ValueStringSelectorBuilder {
    var value: StringSelector { get }
}

public extension ValueStringSelectorBuilder {
    /// Matches when the target equals the given value
    func withValue(_ value: String) -> Self {
        self.value.withString(value)
        return self
    }

    /// Matches when the target equals any of the given values
    func whenValueIsAny(_ values: [String]) -> Self {
        self.value.whenStringIsAny(values)
        return self
    }

    /// Matches when the target contains the given value
    func containingValue(_ value: String) -> Self {
        self.value.whenStringContainsAny([value])
        return self
    }

    /// Matches when the target contains any of the given values
    func whenValueContainsAny(_ keywords: [String]) -> Self {
        self.value.whenStringContainsAny(keywords)
        return self
    }

    /// Matches when the target contains all of the given values
    func whenValueContainsAll(_ keywords: [String]) -> Self {
        self.value.whenStringContainsAll(keywords)
        return self
    }

    // negatives
    /// Does not match when the target equals the given value
    func whenValueIsNot(_ value: String) -> Self {
        self.value.whenStringIsNot(value)
        return self
    }

    /// Does not match if the target equals any of the given values
    func whenValueIsNotAny(_ values: [String]) -> Self {
        self.value.whenStringIsNotAny(values)
        return self
    }

    /// Does not match if the target contains the given value
    func whenValueDoesNotContain(_ keyword: String) -> Self {
        self.value.whenStringDoesNotContainAny([keyword])
        return self
    }

    /// Does not match if the target contains any of the given values
    func whenValueDoesNotContainAny(_ keywords: [String]) -> Self {
        self.value.whenStringDoesNotContainAny(keywords)
        return self
    }

    /// Does not match if the target contains all of the given values
    func whenValueDoesNotContainAll(_ keywords: [String]) -> Self {
        self.value.whenStringDoesNotContainAll(keywords)
        return self
    }
}
