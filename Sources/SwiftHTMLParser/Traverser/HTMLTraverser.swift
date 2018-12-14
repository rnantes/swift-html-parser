//
//  HTMLTraverser.swift
//
//  Created by Reid Nantes on 2018-05-27.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

public class HTMLTraverser {

    public init() {}

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

        // innerTextBlocks contains
        if let innerTextContains = elementSelector.innerTextContains {
            for containsText in innerTextContains {
                if element.innerTextBlocksContains(text: containsText) == false {
                    return false
                }
            }
        }

        if let selectorCount = elementSelector.innerTextCount {
            if element.innerTextBlocks.count != selectorCount {
                return false
            }
        }

        // innerCData
        if let innerCDataContains = elementSelector.innerCDataContains {
            for containsText in innerCDataContains {
                if element.innerCDataContains(text: containsText) == false {
                    return false
                }
            }
        }

        if let selectorCount = elementSelector.innerCDataCount {
            if element.innerCData.count != selectorCount {
                return false
            }
        }

        // comments
        if let commentsContains = elementSelector.commentsContains {
            for containsText in commentsContains {
                if element.commentsContains(text: containsText) == false {
                    return false
                }
            }
        }

        if let selectorCount = elementSelector.commentsCount {
            if element.comments.count != selectorCount {
                return false
            }
        }

        // childElementSelectors
        // checks if one of the element's direct children matches the selector 
        if let childElementSelectors = elementSelector.childElementSelectors {
            for childElementSelector in childElementSelectors {
                let htmlTraverser = HTMLTraverser()
                let matchingElements = htmlTraverser.findElements(in: [element], matchingElementSelectorPath: [childElementSelector])
                if matchingElements.count == 0 {
                    return false
                }
            }
        }

        return true
    }

}
