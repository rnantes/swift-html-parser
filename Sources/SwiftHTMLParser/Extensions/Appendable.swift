//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-10-25.
//

import Foundation

protocol Insertable: Collection {
    init()
    mutating func append(_ newElement: Element)
    mutating func append<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence
}

protocol SetInsertable: Collection  {
    init()
    mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element)
    mutating func formUnion<S>(_ other: S) where Element == S.Element, S : Sequence
}

extension Array: Insertable {}
extension Set: SetInsertable {}

extension Optional where Wrapped: Insertable {
    mutating func appendOrInit(_ newElement: Wrapped.Iterator.Element) {
        if self == nil {
            var newArray = Wrapped.init()
            newArray.append(newElement)
            self = newArray
        } else {
            self?.append(newElement)
        }
    }

    mutating func appendOrInit<S>(contentsOf newElements: S) where Wrapped.Iterator.Element == S.Element, S : Sequence {
        if self == nil {
            var newArray = Wrapped.init()
            newArray.append(contentsOf: newElements)
            self = newArray
        } else {
            self?.append(contentsOf: newElements)
        }
    }
}

extension Optional where Wrapped: SetInsertable {
    mutating func insertOrInit(_ newElement: Wrapped.Iterator.Element) {
        if self == nil {
            var newSet = Wrapped.init()
            _ = newSet.insert(newElement)
            self = newSet
        } else {
            _ = self?.insert(newElement)
        }
    }

    mutating func formUnionOrInit<S>(_ other: S) where Wrapped.Iterator.Element == S.Element, S : Sequence {
        if self == nil {
            var newSet = Wrapped.init()
            newSet.formUnion(other)
            self = newSet
        } else {
            self?.formUnion(other)
        }
    }
}
