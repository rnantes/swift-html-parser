//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-11-03.
//

import Foundation

public final class IntSelector {
    private(set) var anyValues: [Int]?
    private(set) var lessThanValues: [Int]?
    private(set) var greaterThanValues: [Int]?

    // negatives
    private(set) var notAnyValues: [Int]?
}

internal extension IntSelector {
    func withValue(_ value: Int) {
        anyValues.appendOrInit(value)
    }

    func whenValueIsAny(_ values: [Int]) {
        anyValues.appendOrInit(contentsOf: values)
    }

    func whenValueIsLessThan(_ value: Int) {
        lessThanValues.appendOrInit(value)
    }

    func whenValueIsGreaterThan(_ value: Int) {
        greaterThanValues.appendOrInit(value)
    }

    // negatives
    func whenValueIsNot(_ value: Int) {
        notAnyValues.appendOrInit(value)
    }

    func whenValueIsNotAny(_ values: [Int]) {
        notAnyValues.appendOrInit(contentsOf: values)
    }

    func testAgainst(_ value: Int?) -> Bool {
        guard let value = value else {
            if anyValues != nil || lessThanValues != nil || greaterThanValues != nil  {
                return false
            } else {
                return true
            }
        }

        if let anyValues = anyValues {
            if anyValues.contains(where: { value == $0 }) == false {
                return false
            }
        }

        if let lessThanValues = lessThanValues {
            if lessThanValues.allSatisfy({ value < $0 }) == false {
                return false
            }
        }

        if let greaterThanValues = greaterThanValues {
            if greaterThanValues.allSatisfy({ value > $0 }) == false {
                return false
            }
        }

        if let notAnyValues = notAnyValues {
            if notAnyValues.allSatisfy({ value != $0 }) == false {
                return false
            }
        }

        return true
    }
}

