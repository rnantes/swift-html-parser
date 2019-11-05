//
//  IdStringSelectorBuilder.swift
//  
//
//  Created by Reid Nantes on 2019-11-02.
//

import Foundation

protocol IdStringSelectorBuilder {
    var id: StringSelector { get }
}

extension IdStringSelectorBuilder {
    /// Matches when the target equals the given id
    public func withId(_ id: String) -> Self {
        self.id.withString(id)
        return self
    }

    /// Matches when the target equals any of the given ids
    public func whenIdIsAny(_ ids: [String]) -> Self {
        self.id.whenStringIsAny(ids)
        return self
    }

    /// Matches when the target contains the given id
    public func containsId(_ keyword: String) -> Self {
        self.id.whenStringContainsAny([keyword])
        return self
    }

    /// Matches when the target contains any of the given ids
    public func whenIdContainsAny(_ keywords: [String]) -> Self {
        self.id.whenStringContainsAny(keywords)
        return self
    }

    /// Matches when the target contains all of the given ids
    public func whenIdContainsAll(_ keywords: [String]) -> Self {
        self.id.whenStringContainsAll(keywords)
        return self
    }

    // negatives
    /// Does not match when the target equals the given id
    public func whenIdIsNot(_ id: String) -> Self {
        self.id.whenStringIsNot(id)
        return self
    }

    /// Does not match if the target equals any of the given ids
    public func whenIdIsNotAny(_ ids: [String]) -> Self {
        self.id.whenStringIsNotAny(ids)
        return self
    }

    /// Does not match if the target contains the given id
    public func whenIdDoesNotContain(_ keyword: String) -> Self {
        self.id.whenStringDoesNotContainAny([keyword])
        return self
    }

    /// Does not match if the target contains any of the given ids
    public func whenIdDoesNotContainAny(_ keywords: [String]) -> Self {
        self.id.whenStringDoesNotContainAny(keywords)
        return self
    }

    /// Does not match if the target contains all of the given ids
    public func whenIdDoesNotContainAll(_ keywords: [String]) -> Self {
        self.id.whenStringDoesNotContainAll(keywords)
        return self
    }

}
