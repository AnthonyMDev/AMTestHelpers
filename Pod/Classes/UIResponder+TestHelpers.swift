//
//  UIResponder+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 8/5/15.
//

import UIKit

import JRSwizzle

extension UIResponder {
  public override class func initialize() {
    struct Static {
      static var becomeFirstResponderToken: dispatch_once_t = 0
      static var resignFirstResponderToken: dispatch_once_t = 0
      static var isFirstResponderToken: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.becomeFirstResponderToken) {
        let originalSelector = #selector(UIResponder.becomeFirstResponder)
        let swizzledSelector = #selector(UIResponder.AM_testBecomeFirstResponder)
      do { try UIResponder.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
      }
    }
    
    dispatch_once(&Static.resignFirstResponderToken) {
        let originalSelector = #selector(UIResponder.resignFirstResponder)
        let swizzledSelector = #selector(UIResponder.AM_testResignFirstResponder)
      do { try UIResponder.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
      }
    }
    
    dispatch_once(&Static.isFirstResponderToken) {
        let originalSelector = #selector(UIResponder.isFirstResponder)
        let swizzledSelector = #selector(UIResponder.AM_testIsFirstResponder)
        
      do { try UIResponder.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
      }
    }
    
  }
  
  func AM_testBecomeFirstResponder() -> Bool {
    AM_testIsFirstResponderValue = true
    self.AM_testBecomeFirstResponder()
    
    return AM_testIsFirstResponderValue
  }
    
  func AM_testResignFirstResponder() -> Bool {
    AM_testIsFirstResponderValue = false
    self.AM_testResignFirstResponder()
    
    return AM_testIsFirstResponderValue
  }
  
  func AM_testIsFirstResponder() -> Bool {
    return AM_testIsFirstResponderValue
  }
  
  private struct AssociatedKeys {
    static var TestIsFirstResponderValue = "AM_testIsFirstResponderValue"
  }
  
  private var AM_testIsFirstResponderValue: Bool {
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

extension UIView {
    public override class func initialize() {
        struct Static {
            static var windowIfNilToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.windowIfNilToken) {
            let originalSelector = Selector("window")
            let swizzledSelector = #selector(UIView.AM_windowIfNil)
            do { try UIView.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
                debugPrint(error)
            }
        }
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
    
    private struct AssociatedKeys {
        static var ShouldHaveMockWindow = "AM_testShouldHaveMockWindow"
    }
    
    private var shouldHaveMockWindow: Bool {
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

extension UITextField {
  public override class func initialize() {
    struct Static {
      static var becomeFirstResponderToken: dispatch_once_t = 0
      static var resignFirstResponderToken: dispatch_once_t = 0
    }

    dispatch_once(&Static.becomeFirstResponderToken) {
      let originalSelector = #selector(UITextField.becomeFirstResponder)
      let swizzledSelector = #selector(UITextField.AM_testBypassBecomeFirstResponder)
      do { try UITextField.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
      }
    }

    dispatch_once(&Static.resignFirstResponderToken) {
      let originalSelector = #selector(UITextField.resignFirstResponder)
      let swizzledSelector = #selector(UITextField.AM_testBypassResignFirstResponder)
      do { try UITextField.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
      }
    }

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

extension UITextView {
    public override class func initialize() {
        struct Static {
            static var becomeFirstResponderToken: dispatch_once_t = 0
            static var resignFirstResponderToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.becomeFirstResponderToken) {
            let originalSelector = #selector(UITextView.becomeFirstResponder)
            let swizzledSelector = #selector(UITextView.AM_testBypassBecomeFirstResponder)
            do { try UITextView.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
                debugPrint(error)
            }
        }
        
        dispatch_once(&Static.resignFirstResponderToken) {
            let originalSelector = #selector(UITextView.resignFirstResponder)
            let swizzledSelector = #selector(UITextView.AM_testBypassResignFirstResponder)
            do { try UITextView.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
                debugPrint(error)
            }
        }
        
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

