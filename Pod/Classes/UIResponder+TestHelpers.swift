//
//  UIResponder+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 8/5/15.
//

import UIKit

import JRSwizzle

/*
 * MARK: Swizzle UIResponder
 */

fileprivate let swizzleUIResponderBecomeFirstResponder: () = {
    let originalSelector = #selector(UIResponder.becomeFirstResponder)
    let swizzledSelector = #selector(UIResponder.AM_testBecomeFirstResponder)
    do { try UIResponder.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

fileprivate let swizzleUIResponderResignFirstResponder: () = {
    let originalSelector = #selector(UIResponder.resignFirstResponder)
    let swizzledSelector = #selector(UIResponder.AM_testResignFirstResponder)
    do { try UIResponder.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

fileprivate let swizzleUIResponderIsFirstResponder: () = {
    let originalSelector = #selector(getter: UIResponder.isFirstResponder)
    let swizzledSelector = #selector(UIResponder.AM_testIsFirstResponder)
    
    do { try UIResponder.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

extension UIResponder {
    open override class func initialize() {
        swizzleUIResponderBecomeFirstResponder
        swizzleUIResponderResignFirstResponder
        swizzleUIResponderIsFirstResponder
    }
    
    func AM_testBecomeFirstResponder() -> Bool {
        AM_testIsFirstResponderValue = true
        _ = self.AM_testBecomeFirstResponder()
        
        return AM_testIsFirstResponderValue
    }
    
    func AM_testResignFirstResponder() -> Bool {
        AM_testIsFirstResponderValue = false
        _ = self.AM_testResignFirstResponder()
        
        return AM_testIsFirstResponderValue
    }
    
    func AM_testIsFirstResponder() -> Bool {
        return AM_testIsFirstResponderValue
    }
    
    fileprivate struct AssociatedKeys {
        static var TestIsFirstResponderValue = "AM_testIsFirstResponderValue"
    }
    
    fileprivate var AM_testIsFirstResponderValue: Bool {
        get {
            if let associatedObject = objc_getAssociatedObject(self,
                                                               &AssociatedKeys.TestIsFirstResponderValue) as? Bool {
                
                return associatedObject
                
            }
            return false
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.TestIsFirstResponderValue,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

/*
 * MARK: Swizzle UIView
 */

fileprivate let swizzleUIViewWindow: () = {
    let originalSelector = #selector(getter: UIApplicationDelegate.window)
    let swizzledSelector = #selector(UIView.AM_windowIfNil)
    do { try UIView.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

extension UIView {
    open override class func initialize() {
        swizzleUIViewWindow
    }
    
    func AM_windowIfNil() -> UIWindow? {
        if let window = AM_windowIfNil() {
            return window
        }
        if shouldHaveMockWindow {
            return UIWindow()
        }
        
        return nil
    }
    
    fileprivate struct AssociatedKeys {
        static var ShouldHaveMockWindow = "AM_testShouldHaveMockWindow"
    }
    
    fileprivate var shouldHaveMockWindow: Bool {
        get {
            if let associatedObject = objc_getAssociatedObject(self, &AssociatedKeys.ShouldHaveMockWindow) as? Bool {
                return associatedObject
                
            }
            return false
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.ShouldHaveMockWindow,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

/*
 * MARK: Swizzle UITextField
 */

fileprivate let swizzleUITextFieldBecomeFirstResponder: () = {
    let originalSelector = #selector(UITextField.becomeFirstResponder)
    let swizzledSelector = #selector(UITextField.AM_testBypassBecomeFirstResponder)
    do { try UITextField.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

fileprivate let swizzleUITextFieldResignFirstResponder: () = {
    let originalSelector = #selector(UITextField.resignFirstResponder)
    let swizzledSelector = #selector(UITextField.AM_testBypassResignFirstResponder)
    do { try UITextField.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

extension UITextField {
    open override class func initialize() {
        swizzleUITextFieldBecomeFirstResponder
        swizzleUITextFieldResignFirstResponder
    }
    
    func AM_testBypassBecomeFirstResponder() -> Bool {
        shouldHaveMockWindow = true
        defer { shouldHaveMockWindow = false }
        return self.AM_testBypassBecomeFirstResponder()
        
    }
    
    func AM_testBypassResignFirstResponder() -> Bool {
        shouldHaveMockWindow = true
        defer { shouldHaveMockWindow = false }
        return self.AM_testBypassResignFirstResponder()
    }
    
}

/*
 * MARK: Swizzle UITextView
 */

fileprivate let swizzleUITextViewBecomeFirstResponder: () = {
    let originalSelector = #selector(UITextView.becomeFirstResponder)
    let swizzledSelector = #selector(UITextView.AM_testBypassBecomeFirstResponder)
    do { try UITextView.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

fileprivate let swizzleUITextViewResignFirstResponder: () = {
    let originalSelector = #selector(UITextView.resignFirstResponder)
    let swizzledSelector = #selector(UITextView.AM_testBypassResignFirstResponder)
    do { try UITextView.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

extension UITextView {
    open override class func initialize() {
        swizzleUITextViewBecomeFirstResponder
        swizzleUITextViewResignFirstResponder
    }
    
    func AM_testBypassBecomeFirstResponder() -> Bool {
        shouldHaveMockWindow = true
        defer { shouldHaveMockWindow = false }
        return self.AM_testBypassBecomeFirstResponder()
        
    }
    
    func AM_testBypassResignFirstResponder() -> Bool {
        shouldHaveMockWindow = true
        defer { shouldHaveMockWindow = false }
        return self.AM_testBypassResignFirstResponder()
    }
    
}
