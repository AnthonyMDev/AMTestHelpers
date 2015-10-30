//
//  UINavigationController+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 10/30/15.
//

import UIKit

extension UINavigationController {
  public override class func initialize() {
    struct Static {
      static var pushToken: dispatch_once_t = 0
      static var popToken: dispatch_once_t = 0
      static var popToVCToken: dispatch_once_t = 0
      static var popToRootToken: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.pushToken) {
      let originalSelector = Selector("pushViewController:animated:")
      let swizzledSelector = Selector("AM_testPushViewController:animated:")
      
      swizzleMethod(UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
    dispatch_once(&Static.popToken) {
      let originalSelector = Selector("popViewControllerAnimated:")
      let swizzledSelector = Selector("AM_testPopViewControllerAnimated:")
      
      swizzleMethod(UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
    dispatch_once(&Static.popToVCToken) {
      let originalSelector = Selector("popToViewController:animated:")
      let swizzledSelector = Selector("AM_testPopToViewController:animated:")
      
      swizzleMethod(UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
    dispatch_once(&Static.popToVCToken) {
      let originalSelector = Selector("popToRootViewControllerAnimated:")
      let swizzledSelector = Selector("AM_testPopToRootViewControllerAnimated:")
      
      swizzleMethod(UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }
    
  }
  
  func AM_testPushViewController(viewController: UIViewController, animated: Bool) {
    if let VCs = self.AM_testViewControllers {
      let newVCs = VCs + [viewController]
      self.AM_testViewControllers = newVCs
      
    } else {
      self.AM_testViewControllers = [viewController]
    }
    self.addChildViewController(viewController)
  }
    
  func AM_testPopViewControllerAnimated(animated: Bool) -> UIViewController? {
    if var VCs = self.AM_testViewControllers {
      let poppedVC = VCs.removeLast()
      poppedVC.removeFromParentViewController()
      
      self.AM_testViewControllers = VCs
      return poppedVC
    }
    
    return nil
  }
  
  func AM_testPopToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    if var VCs = self.AM_testViewControllers {
      var foundVC = false
      var poppedVCs: [UIViewController] = []
      
      while !foundVC {
        let VC = VCs.last
        if VC === viewController {
          foundVC = true
          
        } else {
          let poppedVC = VCs.removeLast()
          poppedVC.removeFromParentViewController()
          poppedVCs.append(poppedVC)
        }
      }
      
      self.AM_testViewControllers = VCs
      return poppedVCs
    }
    
    return nil
  }
  
  func AM_testPopToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
    if var VCs = self.AM_testViewControllers {
      if VCs.first === viewControllers.first {
        VCs.removeFirst()
      }
      self.AM_testViewControllers = nil
      for VC in VCs {
        VC.removeFromParentViewController()
      }
      return VCs
    }
    
    return nil
  }
  
  private struct AssociatedKeys {
    static var TestViewControllers = "AM_testViewControllers"
  }
  
  public var AM_testViewControllers: [UIViewController]? {
    get {
      guard let VCs = objc_getAssociatedObject(self, &AssociatedKeys.TestViewControllers) as? [UIViewController] else {
        if let rootVC = viewControllers.first {
          return [rootVC]
        } else {
          return nil
        }
      }
      
      if let rootVC = viewControllers.first where VCs.first != rootVC {
        return [rootVC] + VCs
      }
      
      return VCs
    }
    set {
      objc_setAssociatedObject(self,
        &AssociatedKeys.TestViewControllers,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  public var AM_testTopViewController: UIViewController? {
    get {
      return AM_testViewControllers?.last
    }
  }
  
}