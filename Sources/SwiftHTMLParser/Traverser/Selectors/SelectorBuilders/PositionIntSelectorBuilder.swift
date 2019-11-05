//
//  PositionIntSelectorBuilder.swift
//  
//
//  Created by Reid Nantes on 2019-11-03.
//

import Foundation


public protocol PositionIntSelectorBuilder {
    var position: IntSelector { get }
}

extension PositionIntSelectorBuilder {
    /// Matches when the target equals the given value
    public func atPosition(_ value: Int) -> Self {
        self.position.withValue(value)
        return self
    }

    /// Matches when the target equals any of the given values
    public func whenPositionIsAny(_ values: [Int]) -> Self {
        self.position.whenValueIsAny(values)
        return self
    }

    /// Matches when the target is less than the given value
    public func whenPositionIsLessThan(_ value: Int) -> Self {
        self.position.whenValueIsLessThan(value)
        return self
    }

    /// Matches when the target is greater than the given value
    public func whenPositionIsGreaterThan(_ value: Int) -> Self {
        self.position.whenValueIsGreaterThan(value)
        return self
    }

    /// Does not match if the target equals is the given value
    public func whenPositionIsNot(_ value: Int) -> Self {
        self.position.whenValueIsNot(value)
        return self
    }

    /// Does not match if the target equals any of the given values
    public func whenPositionIsNotAny(_ values: [Int]) -> Self {
        self.position.whenValueIsNotAny(values)
        return self
    }

}
