//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-11-02.
//

import Foundation

protocol IdStringSelectorBuilder {
    var id: StringSelector { get set }

    /// Matches when the target equals the given id
    func withId(_ id: String) -> Self

    /// Matches when the target equals any of the given ids
    func whenIdIsAny(_ ids: [String]) -> Self

    /// Matches when the target contains the given id
    func containsId(_ keyword: String) -> Self

    /// Matches when the target contains any of the given ids
    func whenIdContainsAny(_ keywords: [String]) -> Self

    /// Matches when the target contains all of the given ids
    func whenIdContainsAll(_ keywords: [String]) -> Self

    // negatives
    /// Does not match when the target equals the given id
    func whenIdIsNot(_ id: String) -> Self

    /// Does not match if the target equals any of the given ids
    func whenIdIsNotAny(_ ids: [String]) -> Self

    /// Does not match if the target contains the given id
    func whenIdDoesNotContain(_ keyword: String) -> Self

    /// Does not match if the target contains any of the given ids
    func whenIdDoesNotContainAny(_ keywords: [String]) -> Self

    /// Does not match if the target contains all of the given ids
    func whenIdDoesNotContainAll(_ keywords: [String]) -> Self
}

extension IdStringSelectorBuilder {
    func withId(_ id: String) -> Self {
        self.id.withString(id)
        return self
    }

    func whenIdIsAny(_ ids: [String]) -> Self {
        self.id.whenStringIsAny(ids)
        return self
    }

    func containsId(_ keyword: String) -> Self {
        self.id.whenStringContainsAny([keyword])
        return self
    }

    func whenIdContainsAny(_ keywords: [String]) -> Self {
        self.id.whenStringContainsAny(keywords)
        return self
    }

    func whenIdContainsAll(_ keywords: [String]) -> Self {
        self.id.whenStringContainsAll(keywords)
        return self
    }

    func whenIdIsNot(_ id: String) -> Self {
        self.id.whenStringIsNot(id)
        return self
    }

    func whenIdIsNotAny(_ ids: [String]) -> Self {
        self.id.whenStringIsNotAny(ids)
        return self
    }

    func whenIdDoesNotContain(_ keyword: String) -> Self {
        self.id.whenStringDoesNotContainAny([keyword])
        return self
    }

    func whenIdDoesNotContainAny(_ keywords: [String]) -> Self {
        self.id.whenStringDoesNotContainAny(keywords)
        return self
    }

    func whenIdDoesNotContainAll(_ keywords: [String]) -> Self {
        self.id.whenStringDoesNotContainAll(keywords)
        return self
    }

}
