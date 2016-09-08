//
//  UINavigationController+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 10/30/15.
//

import UIKit

import JRSwizzle

/*
 * MARK: Swizzle UINavigationController
 */

fileprivate let swizzleUINavigationControllerPushViewController: () = {
    let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))
    let swizzledSelector = #selector(UINavigationController.AM_testPushViewController(_:animated:))
    
    do { try UINavigationController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

fileprivate let swizzleUINavigationControllerPopViewController: () = {
    let originalSelector = #selector(UINavigationController.popViewController(animated:))
    let swizzledSelector = #selector(UINavigationController.AM_testPopViewControllerAnimated(_:))
    
    do { try UINavigationController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

fileprivate let swizzleUINavigationControllerPopToViewController: () = {
    let originalSelector = #selector(UINavigationController.popToViewController(_:animated:))
    let swizzledSelector = #selector(UINavigationController.AM_testPopToViewController(_:animated:))
    
    do { try UINavigationController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

fileprivate let swizzleUINavigationControllerPopToRootViewController: () = {
    let originalSelector = #selector(UINavigationController.popToRootViewController(animated:))
    let swizzledSelector = #selector(UINavigationController.AM_testPopToRootViewControllerAnimated(_:))
    
    do { try UINavigationController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) } catch {
        debugPrint(error)
    }
}()

extension UINavigationController {
  open override class func initialize() {
    swizzleUINavigationControllerPushViewController
    swizzleUINavigationControllerPopViewController
    swizzleUINavigationControllerPopToViewController
    swizzleUINavigationControllerPopToRootViewController
  }
  
  func AM_testPushViewController(_ viewController: UIViewController, animated: Bool) {
    if let VCs = self.AM_testViewControllers {
      let newVCs = VCs + [viewController]
      self.AM_testViewControllers = newVCs
      
    } else {
      self.AM_testViewControllers = [viewController]
    }
    self.addChildViewController(viewController)
  }
    
  func AM_testPopViewControllerAnimated(_ animated: Bool) -> UIViewController? {
    if var VCs = self.AM_testViewControllers {
      let poppedVC = VCs.removeLast()
      poppedVC.removeFromParentViewController()
      
      self.AM_testViewControllers = VCs
      return poppedVC
    }
    
    return nil
  }
  
  func AM_testPopToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
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
  
  func AM_testPopToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
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
  
  fileprivate struct AssociatedKeys {
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
      
      if let rootVC = viewControllers.first , VCs.first != rootVC {
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
