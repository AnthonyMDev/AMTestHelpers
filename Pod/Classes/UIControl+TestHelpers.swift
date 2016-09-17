//
//  UIControl+TestHelpers.swift
//  Pods
//
//  Created by Jett Farmer on 9/16/16.
//
//

import Foundation

/// Due to a limitation in using `sendActionsForControlEvents`
/// on unit-tests for any control besides `UIButton`, we are swizzling to manually invoke
/// the pair target+action.
fileprivate let swizzleUIControlSendAction: () = {
    let originalSelector = #selector(UIControl.sendAction(_:to:for:))
    let swizzledSelector = #selector(UIControl.AM_sendAction(_:to:for:))
    
    do { try UIControl.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

extension UIControl {
    
    open override class func initialize() {
        swizzleUIControlSendAction
    }
    
    // MARK: - Method Swizzling
    
    func AM_sendAction(_ action: Selector, to target: AnyObject?, for event: UIEvent?) {
        _ = target?.perform(action, with: self)
    }
}
