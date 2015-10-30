//
//  UIViewController+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 8/5/15.
//  Copyright (c) 2015 App-Order. All rights reserved.
//

import UIKit

extension UIViewController {
  public override class func initialize() {
    struct Static {
      static var presentToken: dispatch_once_t = 0
      static var dismissToken: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.presentToken) {
      let originalSelector = Selector("presentViewController:animated:completion:")
      let swizzledSelector = Selector("AM_testPresentViewController:animated:completion:")
      
      swizzleMethod(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
    dispatch_once(&Static.dismissToken) {
      let originalSelector = Selector("dismissViewControllerAnimated:completion:")
      let swizzledSelector = Selector("AM_testDismissViewControllerAnimated:completion:")
      
      swizzleMethod(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
  }
  
  func AM_testPresentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
    self.AM_testPresentedViewController = viewControllerToPresent
    completion?()
  }
  
  func AM_testDismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
    self.AM_testPresentedViewController = nil
    completion?()
  }
  
  private struct AssociatedKeys {
    static var TestPresentedViewController = "AM_testPresentedViewController"
  }
  
  public var AM_testPresentedViewController: UIViewController? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.TestPresentedViewController) as? UIViewController
    }
    set {
      objc_setAssociatedObject(self,
        &AssociatedKeys.TestPresentedViewController,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
}