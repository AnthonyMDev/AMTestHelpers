//
//  AMTestHelper.swift
//  AMTestHelpers
//
//  Created by Dominic Miller on 10/20/17.
//

import Foundation

/// A class that contains static methods for calling `prepareForUse()` on `Preparable` objects.
@objc public class AMTestHelper : NSObject {
    
    /// `init` is set to private because we don't want instances of `AMTestHelper` created.
    /// We only want users to have access to the static functions.
    private override init() {
    }
    
    /// Calls `prepareForUse()` on all types that conform to `Preparable`.
    @objc public static func prepareForTests() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        
        for index in 0 ..< typeCount {
            (types[index] as? Preparable.Type)?.prepareForUse()
        }
        
        types.deallocate(capacity: typeCount)
    }
    
}
