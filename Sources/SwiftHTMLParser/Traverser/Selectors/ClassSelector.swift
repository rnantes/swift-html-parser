//
//  ClassSelector.swift
//  
//
//  Created by Reid Nantes on 2019-10-22.
//

import Foundation

extension ElementSelector {
    /// Matches if the target matches the given className
    public func withClassName(_ className: String) -> Self {
        self.classNameSelector.hasClassNameAny.appendOrInit(className)
        return self
    }

    /// Matches if the target matches any of the given classNames
    public func withClassNamesAny(_ classNames: [String]) -> Self {
        self.classNameSelector.hasClassNameAny.appendOrInit(contentsOf: classNames)
        return self
    }

    /// Matches if the target matches all of the given classNames
    public func withClassNamesAll(_ classNames: [String]) -> Self {
        self.classNameSelector.hasClassNamesAll.appendOrInit(contentsOf: classNames)
        return self
    }

    /// Matches if the target has the exact of the given classNames.
    public func withClassNamesExact(_ classNames: [String]) -> Self {
        self.classNameSelector.hasClassNamesExact.appendOrInit(contentsOf: classNames)
        return self
    }

    // negatives
    /// Does not match if the node has the className
    public func withoutClassName(_ className : String) -> Self {
        self.classNameSelector.doesNotHaveClassNameAny.appendOrInit(className)
        return self
    }

    /// Does not match if any of the given classNames are present
    public func withoutClassNameAny(_ classNames : [String]) -> Self {
        self.classNameSelector.doesNotHaveClassNameAny.appendOrInit(contentsOf: classNames)
        return self
    }

    /// Does not match if all of the given classNames are present
    public func withoutClassNameAll(_ classNames : [String]) -> Self {
        self.classNameSelector.doesNotHaveClassNamesAll.appendOrInit(contentsOf: classNames)
        return self
    }

    /// Does not match if the element has the exact classNames
    public func withoutClassNameExact(_ classNames : [String]) -> Self {
        self.classNameSelector.doesNotHaveClassNamesExact.appendOrInit(contentsOf: classNames)
        return self
    }

}

internal final class ClassSelector {
    var hasClassNameAny: [String]?
    var hasClassNamesAll: [String]?
    var hasClassNamesExact: [String]?

    // negatives
    // does not match if any of the given classNames are present
    var doesNotHaveClassNameAny: [String]?
    // does not match if all of the given classNames are present
    var doesNotHaveClassNamesAll: [String]?
    // does not match if the element has the exact classNames
    var doesNotHaveClassNamesExact: [String]?


    /// returns true if the element satisfies the selector
    internal func testAgainst(_ element: Element) -> Bool {
        let classNamesSet = Set(element.classNames)

        if let hasClassNameAny = hasClassNameAny {
            if hasClassNameAny.contains(where: { classNamesSet.contains($0) }) == false {
                return false
            }
        }

        if let hasClassNamesAll = hasClassNamesAll {
            if hasClassNamesAll.allSatisfy({ classNamesSet.contains($0) }) == false {
                return false
            }
        }

        if let hasClassNamesExact = hasClassNamesExact {
            if hasClassNamesExact.allSatisfy({ classNamesSet.contains($0) }) == false || hasClassNamesExact.count != classNamesSet.count {
                return false
            }
        }

        if let doesNotHaveClassNameAny = doesNotHaveClassNameAny {
            if doesNotHaveClassNameAny.contains(where: { classNamesSet.contains($0) }) == true {
                return false
            }
        }

        if let doesNotHaveClassNamesAll = doesNotHaveClassNamesAll {
            if doesNotHaveClassNamesAll.allSatisfy({ classNamesSet.contains($0) }) == true {
                return false
            }
        }

        if let doesNotHaveClassNamesExact = doesNotHaveClassNamesExact {
            if doesNotHaveClassNamesExact.allSatisfy({ classNamesSet.contains($0) }) == true && doesNotHaveClassNamesExact.count == classNamesSet.count {
                return false
            }
        }

        return true
    }
}
