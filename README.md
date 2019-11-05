# SwiftHTMLParser
SwiftHTMLParser is a library for parsing and traverseing HTML and XML written in Swift. It parses plaintext HTML or XML into an object tree (DOM), and allows for the easy traversal and searching of the tree's nodes, similar to an HTML Selector or XPath.

## Basic Structure
Object naming is based on the [HTML Standard](https://html.spec.whatwg.org/dev/syntax.html#syntax). There are also easy to follow introductions available from  [w3schools](https://www.w3schools.com/html/default.asp) and [w3](https://www.w3.org/TR/html53/introduction.html#a-quick-introduction-to-html).

* `Node`, a protocol: - Consists of an start and closing `Tag`. (Closing tags may be ommited in some special cases)
* `Tag`, a struct: - contains the tag's name, the opening tag contains any of the node's `Attribute`s
* `Attribute`, a struct: - consist of a name and an associated value

####  Nodes 
* `Element`, a struct: - a `Node` that may contain nested nodes.
* `TextNode`, a struct:- a `Node` that represents a block of text. 
* `Comment`, a struct: - a `Node` that represents a single or multi-line comment within an element.
* `CData`, a struct: - a `Node` that represents a CData section and its associated text.
* `DocumentTypeNode`, a struct: - a `Node` which provides metadata on how to parse the document

## Tutorial

#### Read in Plaintext HTML from a File
```swift
let fileURL = URL.init(fileURLWithPath: "/some/absolute/path/simple.html")!
```

#### Parse the HTML String Into a Tree of Node Objects (DOM)
```swift
let nodeTree = try HTMLParser.parse(htmlString)
```

#### Create a Node Selector Path Then Traverse the Node Tree to Find Matching Nodes
Element, Text, Comment, and CData Selectors are availabe
```swift
// create a node selector path to describe what nodes to match in the nodeTree
let nodeSelectorPath: [NodeSelector] = [
    ElementSelector().withTagName("html"),
    ElementSelector().withTagName("body"),
    ElementSelector().withTagName("div").withClassName("essay"),
    ElementSelector().withTagName("p").atPosition(0)
]

// find the nodes that match the nodeSelectorPath
let matchingNodes = HTMLTraverser.findNodes(in: nodeTree, matching: nodeSelectorPath)
```
 
### Examples

#### The HTML File We Will Use for The Following Examples
We will use the example file: simple.html
```HTML
<!DOCTYPE html>
<html>
    <head>
        <title>This is a Simple Example</title>
    </head>
    <body>
        <h1>This is a Heading</h1>

        <div class="essay">
            <p class="essay-paragraph opening-paragraph">This is the first paragraph.</p>
            <p class="essay-paragraph body-paragraph">This is the second paragraph.</p>
            <p class="essay-paragraph body-paragraph">This is the third paragraph.</p>
            <p class="essay-paragraph body-paragraph">This is the fourth paragraph.</p>
            <p class="essay-paragraph closing-paragraph">This is the fifth paragraph.</p>

            <div>
                <p>Editor Notes</p>
            </div>
        </div>

        <div class="bibliography">
            <ul>
                <li id="citation-1998">This is the first citation.</li>
                <li id="citation-1999">This is the second citation.</li>
                <li id="citation-2000">This is the third citation.</li>
            </ul>

            <div>
                <p>Bibliography Notes</p>
            </div>
        </div>

    </body>
</html>
```

#### Find Matching Elements
```swift
func parseAndTraverseSimpleHTML() throws {
    // get string from file
    let fileURL = URL.init(fileURLWithPath: "/some/absolute/path/simple.html")!
    let htmlString = try String(contentsOf: fileURL, encoding: .utf8)

    // parse the htmlString into a tree of node objects (DOM)
    let nodeTree = try HTMLParser.parse(htmlString)

    // create a node selector path to describe what nodes to match in the nodeTree
    let nodeSelectorPath: [NodeSelector] = [
        ElementSelector().withTagName("html"),
        ElementSelector().withTagName("body"),
        ElementSelector().withTagName("div").atPosition(0),
        ElementSelector().withTagName("p").withClassName("body-paragraph")
    ]

    // find the elements that match the nodeSelectorPath
    // notice we use the findElements() function which only matches elements
    let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)

    // matchingElements will contain the 3 matching <p> elements with the className 'body-paragraph'
    // will print: 3
    print(matchingElements.count)
}
```

#### Find a Matching Text Node
```swift
func parseAndTraverseSimpleHTMLTextNode() throws {
    // get string from file
    let fileURL = URL.init(fileURLWithPath: "/some/absolute/path/simple.html")!
    let htmlString = try String(contentsOf: fileURL, encoding: .utf8)

    // parse the htmlString into a tree of node objects (DOM)
    let nodeTree = try HTMLParser.parse(htmlString)

    // create a node selector path to describe what nodes to match in the nodeTree
    // this is equvalent to the selector: body > p or xpath: /html/body/p
    let nodeSelectorPath: [NodeSelector] = [
        ElementSelector().withTagName("html"),
        ElementSelector().withTagName("body"),
        ElementSelector().withTagName("div").withClassName("bibliography"),
        ElementSelector().withTagName("ul"),
        ElementSelector().withTagName("li").withId("citation-1999"),
        TextNodeSelector()
    ]

    // find the nodes that match the nodeSelectorPath
    // Notice we use the findNodes() function which can match with any node type
    let matchingNodes = HTMLTraverser.findNodes(in: nodeTree, matching: nodeSelectorPath)

    // matchingNodes will contain the matching generic node
    // we have to cast the Node to a TextNode to access its text property
    guard let paragraphTextNode = matchingNodes.first as? TextNode else {
        // could not find paragraph text node
        return
    }

    // will print: This is the second citation.
    print(paragraphTextNode.text)
}
```

#### Find Matching Elements Using a Child Node Selector Path
```swift
func parseAndTraverseSimpleHTMLChildNodeSelectorPath() throws {
    // get string from file
    let fileURL = URL.init(fileURLWithPath: "/some/absolute/path/simple.html")!
    let htmlString = try String(contentsOf: fileURL, encoding: .utf8)

    // parse the htmlString into a tree of node objects (DOM)
    let nodeTree = try HTMLParser.parse(htmlString)

    // create a child node selector path that will match the parent node
    // only if the childNodeSelectorPath matches the element's child nodes
    let childNodeSelectorPath: [NodeSelector] = [
        ElementSelector().withTagName("div"),
        ElementSelector().withTagName("p"),
        TextNodeSelector().withText("Editor Notes")
    ]

    // create a node selector path to describe what nodes to match in the nodeTree
    // Notice the last ElementSelector will only match if the element contains
    // child nodes that match the childNodeSelectorPath
    let nodeSelectorPath: [NodeSelector] = [
        ElementSelector().withTagName("html"),
        ElementSelector().withTagName("body"),
        ElementSelector().withTagName("div").withChildNodeSelectorPath(childNodeSelectorPath),
    ]

    // find the nodes that match the nodeSelectorPath
    // Notice we use the findNodes() function which can match with any node type
    let matchingElements = HTMLTraverser.findElements(in: nodeTree, matching: nodeSelectorPath)

    // matchingElements should only contain the div element with the 'essay' class name
    // will print: 1
    print(matchingElements.count)

    guard let divElement = matchingElements.first else {
        // could not find paragraph text node
        XCTFail("could not find paragraph text node")
        return
    }

    guard let firstClassName = divElement.classNames.first else {
        // divElement does not have any classnames
        return
    }

    // will print: essay
    print(firstClassName)
}
```


## Getting Started
SwiftHTMLParser uses [SwiftPM](https://swift.org/package-manager/) as its build tool. To depend on SwiftHTMLParser in your own project, add it to the `dependencies` clause in your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/rnantes/swift-html-parser.git", from: "1.0.0")
]
```

## Testing
Automated testing was used to validate the parsing of tags, comments, single and double quoted attributes, imbedded JavaScript, etc. Specially created sample HTML files as well as HTML from top sites were used in testing. However, all cases may not have been covered. Please open a issue on Github and provide sample HTML if you discover a bug so it can be fixed and a test case can be added


#### Run Tests Via the Command Line
`swift test`

#### Run Tests Via Docker
`docker build -t swift-html-parser . && docker run -it swift-html-parser`

