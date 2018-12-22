# SwiftHTMLParser
SwiftHTMLParser is a library for parsing and traversing HTML written in Swift. It parses plaintext HTML into an object, and allows for the easy traversal of the object's elements, similarly to an HTML Selector or XPath.

## Basic Structure
Object naming is based on the [HTML Standard](https://html.spec.whatwg.org/dev/syntax.html#syntax). There are also easy to follow [tutorials](https://www.w3schools.com/html/default.asp) available online.

* `Element` - contains a start and end `Tag`, inner `TextBlock`s and `Comment`s, and child `Element`s
* `Tag` - contains the tag's name and `Attribute`s
* `Attribute` - contains the attribute's name and value
* `TextBlock` - represents a block of text within an element
* `Comment` - represents a single or multi-line comment within an element
 
## Tutorial

#### The HTML File We Will Use for This Tutorial
We will use the example file: simple.html
```HTML
<!DOCTYPE>
<html>
    <head>
        <title>This is a Simple Example</title>
    </head>
    <body>
        <h1>This is a Heading</h1>
        <p>This is the first paragraph.</p>
        <p>This is the second paragraph.</p>
        <p>This is the third paragraph.</p>
    </body>
</html>
```

#### Read in Plaintext HTML from the File
```swift
let filePath = "/some/absolute/path/simple.html"
let fileURL = URL.init(fileURLWithPath: filePath)

var htmlStringResult: String? = nil
do {
    htmlStringResult = try String(contentsOf: fileURL, encoding: .utf8)
} catch {
    // Could not retrieve string from file  
    throw error
}
guard let htmlString = htmlStringResult else {
    // Could not retrieve string from file
    return 
}

// htmlString now contains the text from the file '/some/absolute/path/simple.html'
```

#### Parse the HTML String into an HTML Object
```swift
let htmlParser = HTMLParser()
let elementArray = htmlParser.parse(pageSource: htmlString)
```

#### Traverse the Parsed HTML Object to Find Elements Matching the ElementSelector Path
In this example we are looking for 2nd element with the `p` tag name within the HTML body
```swift
let elementSelectorPath = [
    ElementSelector.init(tagName: "html"),
    ElementSelector.init(tagName: "body"),
    ElementSelector.init(tagName: "p", position: 1)
]

let htmlTraverser = HTMLTraverser()
var matchingElements = traverser.getElementsMatchingSelectorPath(parsedHTML: elementArray,
                                                                 elementSelectorPath: elementSelectorPath)
                                                                 
// matchingElements.count is 1
// matchingElements.first!.text is 'This is the second paragraph.'
```

## Getting Started
SwiftHTMLParser uses [SwiftPM](https://swift.org/package-manager/) as its build tool. To depend on SwiftHTMLParser in your own project, add it to the `dependencies` clause in your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/rnantes/swift-html-parser.git", from: "1.0.0")
]
```

## Testing
Automated testing was used to validate the parsing of tags, comments, single and double quoted attributes, imbedded JavaScript, etc. Specially created sample HTML files as well as HTML from top sites were used in testing. However, all cases may not have been covered. Please open a issue on Github and provide sample HTML if you discover a bug so it can be fixed and a test case can be added.

### Running Tests
Since SwiftPM doesn't support resource bundling, the path to the HTML files included for testing must be updated on individual systems. To do this update the `projectPath` String variable in `SwiftHTMLParser/ProjectConfig.swift` to the root path of your project. For Example: 
```swift
import Foundation

struct ProjectConfig {
    let projectPath = "/Users/johnnyappleseed/Documents/swift-html-parser/SwiftHTMLParser/"
}
```
