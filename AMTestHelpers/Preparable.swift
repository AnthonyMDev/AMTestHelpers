//
//  Preparable.swift
//  AMTestHelpers
//
//  Created by Dominic Miller on 10/20/17.
//

import Foundation

/// Provides a simple entry point for any class that you would like to imbue with behaviour similar to objc `initialize()`.
protocol Preparable: class {
    
    /// Called in XCTestCase's suite level `setUp()` method before tests begin to run.
    /// Implement this function to perform class-specific behavior before the class's use.
    static func prepareForUse()
}
