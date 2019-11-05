//
//  HTMLTraverser.swift
//
//  Created by Reid Nantes on 2018-05-27.
//  Copyright © 2018 Reid Nantes. All rights reserved.
//

import Foundation

public struct HTMLTraverser {

    public static func hasMatchingNode(in parsedNodes: [Node], matching nodeSelctorPath: [NodeSelector]) -> Bool {
        if findNodes(in: parsedNodes, matching: nodeSelctorPath).count > 0 {
            return true
        } else {
            return false
        }
    }

    public static func findElements(in parsedNodes: [Node], matching nodeSelectorPath: [NodeSelector]) -> [Element] {
        let nodes = findNodes(in: parsedNodes, matching: nodeSelectorPath)
        return nodes.compactMap({ $0 as? Element })
    }

    public static func findNodes(in parsedNodes: [Node], matching nodeSelectorPath: [NodeSelector]) -> [Node] {
        // start with every element matching
        var matchingNodes = parsedNodes
        var selectorPathIndex = 0
        var matchedSelectors = [NodeSelector]()
        // var unmatchedSelector: NodeSelector? = nil

        while selectorPathIndex < nodeSelectorPath.count && matchingNodes.count > 0 {
            var shouldReturnChildrenOfMatches = true
            // if not the last selectorNode get the children
            if selectorPathIndex == nodeSelectorPath.count - 1 {
               shouldReturnChildrenOfMatches = false
            }

            let currentSelector = nodeSelectorPath[selectorPathIndex]
            matchingNodes = getMatchesAtDepth(nodeSelector: currentSelector,
                                              nodesAtDepth: matchingNodes,
                                              shouldReturnChildrenOfMatches: shouldReturnChildrenOfMatches)

            // if matched add currentSelector to list of matchedSelectors
            if (matchingNodes.count > 0) {
                matchedSelectors.append(currentSelector)
            } else {
                // if not matched set unmatchedSelector
                // TODO: return result or throw error with this result?
                //unmatchedSelector = currentSelector
            }

            selectorPathIndex += 1
        }

        return matchingNodes
    }

    private static func getMatchesAtDepth(nodeSelector: NodeSelector, nodesAtDepth: [Node], shouldReturnChildrenOfMatches: Bool) -> [Node] {
        var matchesAtDepth = [Node]()

        var currentPosition = 0

        for node in nodesAtDepth {
            if compare(nodeSelector: nodeSelector, node: node) == true {
                if nodeSelector.position.testAgainst(currentPosition) {
                    if shouldReturnChildrenOfMatches == true {
                        if let element = node as? Element {
                            matchesAtDepth.append(contentsOf: element.childNodes)
                        }
                    } else {
                        matchesAtDepth.append(node)
                    }
                }
                currentPosition += 1
            }
        }

        return matchesAtDepth
    }

    private static func compare(nodeSelector: NodeSelector, node: Node) -> Bool {
        if nodeSelector.testAgainst(node) == false {
            return false
        }

        return true
    }

}
