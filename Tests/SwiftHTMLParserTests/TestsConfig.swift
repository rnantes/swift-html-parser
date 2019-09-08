//
//  File.swift
//  
//
//  Created by Reid Nantes on 2019-08-17.
//

import Foundation

struct TestsConfig {
    static var testsDirectoryURL: URL? {
        get {
            let filePath = #file
            var url = URL.init(fileURLWithPath: filePath, isDirectory: false)
            url.deleteLastPathComponent()
            return url
        }
    }

    static let testFilesDirectoryURL: URL? = Self.testsDirectoryURL?.appendingPathComponent("TestFiles")

    static let attributesTestFilesDirectoryURL: URL? = Self.testFilesDirectoryURL?.appendingPathComponent("Attributes")
    static let commentsTestFilesDirectoryURL: URL? = Self.testFilesDirectoryURL?.appendingPathComponent("Comments")
    static let elementsTestFilesDirectoryURL: URL? = Self.testFilesDirectoryURL?.appendingPathComponent("Elements")
    static let javascriptTestFilesDirectoryURL: URL? = Self.testFilesDirectoryURL?.appendingPathComponent("Javascript")
    static let performanceTestFilesDirectoryURL: URL? = Self.testFilesDirectoryURL?.appendingPathComponent("Performance")
    static let realWorldTestFilesDirectoryURL: URL? = Self.testFilesDirectoryURL?.appendingPathComponent("RealWorld")
    static let svgTestFilesDirectoryURL: URL? = Self.testFilesDirectoryURL?.appendingPathComponent("SVG")
}


