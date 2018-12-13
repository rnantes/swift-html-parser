//
//  HTMLTraverser.swift
//
//  Created by Reid Nantes on 2018-05-27.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

public class HTMLTraverser {

    public func findElements(in parsedElements: [Element], matchingElementSelectorPath: [ElementSelector]) -> [Element] {
        var matchingElements = [Element]()
        var selectorPathIndex = 0

        matchingElements = parsedElements
        while selectorPathIndex < matchingElementSelectorPath.count && matchingElements.count != 0 {
            var shouldReturnChildrenOfMatches = true
            // if not the last selectorElement get the childred
            if selectorPathIndex == matchingElementSelectorPath.count - 1 {
               shouldReturnChildrenOfMatches = false
            }

            matchingElements = getMatchesAtDepth(elementSelector: matchingElementSelectorPath[selectorPathIndex],
                                                 elementsAtDepth: matchingElements,
                                                 shouldReturnChildrenOfMatches: shouldReturnChildrenOfMatches)

            selectorPathIndex += 1
        }

        return matchingElements
    }

    private func getMatchesAtDepth(elementSelector: ElementSelector, elementsAtDepth: [Element], shouldReturnChildrenOfMatches: Bool) -> [Element] {
        var matchesAtDepth = [Element]()

        var elementNum = 0

        for element in elementsAtDepth {
            if compare(elementSelector: elementSelector, element: element) == true {
                if elementSelector.position == nil || elementNum == elementSelector.position {
                    if shouldReturnChildrenOfMatches == true {
                        matchesAtDepth.append(contentsOf: element.childElements)
                    } else {
                        matchesAtDepth.append(element)
                    }
                }
                elementNum += 1
            }
        }

        return matchesAtDepth
    }

    private func compare(elementSelector: ElementSelector, element: Element) -> Bool {
        if elementSelector.tagName != element.tagName {
            return false
        }

        if elementSelector.id != nil {
            if elementSelector.id != element.id {
                return false
            }
        }

        if let selectorClassNames = elementSelector.classNames {
            // if selector
            if element.classNames.count == 0 {
                return false
            }

            var foundOneMatch = false
            for selectorClassName in selectorClassNames {
                for elementClassName in element.classNames {
                    if selectorClassName == elementClassName {
                        foundOneMatch = true
                    }
                }
            }

            if foundOneMatch == false {
                    return false
            }
        }

        return true
    }

}
