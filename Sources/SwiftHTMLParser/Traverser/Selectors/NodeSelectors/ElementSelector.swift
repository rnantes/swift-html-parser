//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-10-29.
//

import Foundation

public final class ElementSelector: NodeSelector, TagNameStringSelectorBuilder, IdStringSelectorBuilder {
    public var position = IntSelector()

    // string selector
    internal var tagName = StringSelector()
    internal var id = StringSelector()

    // className selector
    internal var classNameSelector = ClassSelector()

    // attribute selectors
    internal var attributes: [AttributeSelector]?

    // childNode selector
    internal var childNodeSelectors: [NodeSelector]?
    internal var childNodeSelectorPathsAll: [[NodeSelector]]?


    /// Selects element if it has the given attribute
    func withAttribute(_ attributeSelector: AttributeSelector) -> ElementSelector {
        self.attributes.appendOrInit(attributeSelector)
        return self
    }

    /// Selects element if it has the given id attribute value
    func withId(_ id: String) -> ElementSelector {
        self.attributes.appendOrInit(AttributeSelector.init(name: "id").withValue(id))
        return self
    }

    /// Selects element if it has a child node matching the given childNodeSelector
    func withChildNodeSelectorPath(_ childNodeSelectorPath: [NodeSelector]) -> Self {
        self.childNodeSelectorPathsAll.appendOrInit(childNodeSelectorPath)
        return self
    }

    func withChildElement(_ elementSelector: ElementSelector) -> Self {
        self.childNodeSelectors.appendOrInit(elementSelector)
        return self
    }

    func withChildTextNode(_ textNodeSelector: TextNodeSelector) -> Self {
        self.childNodeSelectors.appendOrInit(textNodeSelector)
        return self
    }

    func withChildCommentNode(_ commentNodeSelector: CommentSelector) -> Self {
        self.childNodeSelectors.appendOrInit(commentNodeSelector)
        return self
    }

    func withChildCDataNode(_ cDataSelector: CDataSelector) -> Self {
        self.childNodeSelectors.appendOrInit(cDataSelector)
        return self
    }
    
    public func testAgainst(_ node: Node) -> Bool {
        // return false if node is not an element
        guard let element = node as? Element else {
            return false
        }

        // test tagName selector 
        if self.tagName.testAgainst(element.tagName) == false {
            return false
        }

        //test classNames
        if self.classNameSelector.testAgainst(element) == false {
            return false
        }

        //test attributes (including id)
        if self.attributes?.allSatisfy({ $0.testSelector(against: element) }) == false {
            return false
        }

        // test child selectors
        if childNodeSelectors?.allSatisfy( {
            HTMLTraverser.hasMatchingNode(in: element.childNodes, matching: [$0])
        }) == false {
            return false
        }

        // test childNodeSelectorPaths
        if childNodeSelectorPathsAll?.allSatisfy( {
            HTMLTraverser.hasMatchingNode(in: element.childNodes, matching: $0)
        }) == false {
            return false
        }

        return true
    }
}
