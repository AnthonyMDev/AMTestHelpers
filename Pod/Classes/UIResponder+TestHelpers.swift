//
//  UIResponder+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 8/5/15.
//

import UIKit

extension UIResponder {
  public override class func initialize() {
    struct Static {
      static var becomeFirstResponderToken: dispatch_once_t = 0
      static var resignFirstResponderToken: dispatch_once_t = 0
      static var isFirstResponderToken: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.becomeFirstResponderToken) {
      let originalSelector = Selector("becomeFirstResponder")
      let swizzledSelector = Selector("AM_testBecomeFirstResponder")
      swizzleMethod(UIResponder.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
    dispatch_once(&Static.resignFirstResponderToken) {
      let originalSelector = Selector("resignFirstResponder")
      let swizzledSelector = Selector("AM_testResignFirstResponder")
      swizzleMethod(UIResponder.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
    dispatch_once(&Static.isFirstResponderToken) {
      let originalSelector = Selector("isFirstResponder")
      let swizzledSelector = Selector("AM_testIsFirstResponder")
      swizzleMethod(UIResponder.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
  }
  
  func AM_testBecomeFirstResponder() -> Bool {
    AM_testIsFirstResponderValue = true
    
    return AM_testIsFirstResponderValue
  }
  
  func AM_testResignFirstResponder() -> Bool {
    AM_testIsFirstResponderValue = false
    
    return AM_testIsFirstResponderValue
  }
  
  func AM_testIsFirstResponder() -> Bool {
    return AM_testIsFirstResponderValue
  }
  
  private struct AssociatedKeys {
    static var TestIsFirstResponderValue = "AM_testIsFirstResponderValue"
  }
  
  public var AM_testIsFirstResponderValue: Bool {
    get {
      if let associatedObject = objc_getAssociatedObject(self, &AssociatedKeys.TestIsFirstResponderValue) as? Bool {
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