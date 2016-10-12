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

fileprivate let swizzleUINavigationControllerViewControllersProperty: () = {
    let originalGetter = #selector(getter: UINavigationController.viewControllers)
    let swizzledGetter = #selector(getter: UINavigationController.AM_testViewControllers)
    
    do { try UINavigationController.self.jr_swizzleMethod(originalGetter, withMethod: swizzledGetter) } catch {
        debugPrint(error)
    }
    
    let originalSetter = #selector(setter: UINavigationController.viewControllers)
    let swizzledSetter = #selector(setter: UINavigationController.AM_testViewControllers)
    
    do { try UINavigationController.self.jr_swizzleMethod(originalSetter, withMethod: swizzledSetter) } catch {
        debugPrint(error)
    }
    
}()

fileprivate let swizzleUINavigationControllerTopViewController: () = {
    let originalSelector = #selector(getter: UINavigationController.topViewController)
    let swizzledSelector = #selector(getter: UINavigationController.AM_testTopViewController)
    
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
        swizzleUINavigationControllerViewControllersProperty
        swizzleUINavigationControllerTopViewController
    }
    
    func AM_testPushViewController(_ viewController: UIViewController, animated: Bool) {
        var viewControllers = self.viewControllers
        viewControllers.append(viewController)
        self.addChildViewController(viewController)
        self.viewControllers = viewControllers
    }
    
    func AM_testPopViewControllerAnimated(_ animated: Bool) -> UIViewController? {
        let poppedVC = self.viewControllers.last
        poppedVC?.removeFromParentViewController()
        
        self.viewControllers = Array(self.viewControllers.dropLast())
        return poppedVC
    }
    
    func AM_testPopToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        var VCs = self.viewControllers
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
        
        self.viewControllers = VCs
        return poppedVCs
    }
    
    func AM_testPopToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        guard let rootVC = self.viewControllers.first,
            self.viewControllers.count > 1 else { return nil }
        
        let oldVCs = self.viewControllers.dropFirst()
        self.viewControllers = [rootVC]
        
        for VC in oldVCs {
            VC.removeFromParentViewController()
        }
        
        return Array(oldVCs)
    }
    
    fileprivate struct AssociatedKeys {
        static var TestViewControllers = "AM_testViewControllers"
    }
    
    var AM_testViewControllers: [UIViewController] {
        get {
            guard let VCs = objc_getAssociatedObject(self,
                                                     &AssociatedKeys.TestViewControllers) as? [UIViewController] else {
                                                        
                                                        if let rootVC = AM_testViewControllers.first {
                                                            objc_setAssociatedObject(self,
                                                                                     &AssociatedKeys.TestViewControllers,
                                                                                     [rootVC],
                                                                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                                                            
                                                            return [rootVC]
                                                        } else {
                                                            objc_setAssociatedObject(self,
                                                                                     &AssociatedKeys.TestViewControllers,
                                                                                     [],
                                                                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                                                            return []
                                                        }
            }
            
            if let rootVC = AM_testViewControllers.first, VCs.first != rootVC {
                return [rootVC] + VCs
            }
            
            return VCs
        }
        set {
            for viewControllers in self.viewControllers {
                viewControllers.removeFromParentViewController()
            }
            for viewController in newValue {
                self.addChildViewController(viewController)
            }
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.TestViewControllers,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var AM_testTopViewController: UIViewController? {
        get {
            return self.viewControllers.last
        }
    }
    
}
