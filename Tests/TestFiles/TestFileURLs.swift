//
//  Created by Reid Nantes on 2019-08-17.
//

import Foundation


public struct TestFileURLs {
    static public let testFilesResourceDirectoryURL: URL? = Bundle.module.resourceURL
    
    // mock
    static public let testFilesMockDirectoryURL: URL? = Self.testFilesResourceDirectoryURL?.appendingPathComponent("Mock")

    static public let attributesTestFilesDirectoryURL: URL? = Self.testFilesMockDirectoryURL?.appendingPathComponent("Attributes")
    static public let commentsTestFilesDirectoryURL: URL? = Self.testFilesMockDirectoryURL?.appendingPathComponent("Comments")
    static public let documentationTestFilesDirectoryURL: URL? = Self.testFilesMockDirectoryURL?.appendingPathComponent("Documentation")
    static public let elementsTestFilesDirectoryURL: URL? = Self.testFilesMockDirectoryURL?.appendingPathComponent("Elements")
    static public let javascriptTestFilesDirectoryURL: URL? = Self.testFilesMockDirectoryURL?.appendingPathComponent("Javascript")
    static public let performanceTestFilesDirectoryURL: URL? = Self.testFilesMockDirectoryURL?.appendingPathComponent("Performance")
    static public let svgTestFilesDirectoryURL: URL? = Self.testFilesMockDirectoryURL?.appendingPathComponent("SVG")
    
    // real world
    static public let realWorldTestFilesDirectoryURL: URL? = Self.testFilesResourceDirectoryURL?.appendingPathComponent("RealWorld")
}


