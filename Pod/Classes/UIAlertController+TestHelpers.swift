//
//  UIAlertController+TestHelpers.swift
//
//  Created by Anthony Miller on 12/21/16.
//  Copyright (c) 2016 App-Order, LLC. All rights reserved.
//

import Foundation
import UIKit

fileprivate let swizzleUIAlertActionInitializer: () = {
    let originalSelector = #selector(UIAlertAction.init(title:style:handler:))
    let swizzledSelector = #selector(UIAlertAction.init(AM_title:style:handler:))
    
    do { try UIAlertAction.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

extension UIAlertAction {
    
    open override class func initialize() {
        swizzleUIAlertActionInitializer
    }
    
    fileprivate struct AssociatedKeys {
        static var Handler = "AM_handler"
    }
    
    fileprivate var AM_handler: ((UIAlertAction) -> Swift.Void)? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.Handler) as? UIAlertActionHandler)?.closure
        }
        set {
            let actionHandler = UIAlertActionHandler(closure: newValue)
            objc_setAssociatedObject(self, &AssociatedKeys.Handler, actionHandler, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init(AM_title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        self.init(title: AM_title, style: style, handler: handler)
        self.AM_handler = handler
    }
    
    /// Executes the handler that the receiver was initialized with.
    public func executeHandler() {
        AM_handler?(self)
    }
}

private class UIAlertActionHandler: NSObject {
    
    let closure: ((UIAlertAction) -> Swift.Void)?
    
    init(closure: ((UIAlertAction) -> Swift.Void)?) {
        self.closure = closure
    }
    
}

extension UIAlertController {
    
    /// Executes the first action in the receiver's `actions` array with the given title.
    ///
    /// - Parameter title: The title of the action that should be executed.
    public func executeAction(withTitle title: String) {
        for action in actions {
            if action.title == title {
                action.executeHandler()
                return
            }
        }
    }
    
}
