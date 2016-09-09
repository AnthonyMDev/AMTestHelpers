//
//  UIViewController+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 8/5/15.
//

import UIKit

import JRSwizzle

/*
 * MARK: Swizzle UIViewController
 */

fileprivate let swizzleUIViewControllerPresentViewController: () = {
    let originalSelector = #selector(UIViewController.present(_:animated:completion:))
    let swizzledSelector = #selector(UIViewController.AM_testPresentViewController(_:animated:completion:))
    
    do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
    catch { debugPrint(error) }
}()

fileprivate let swizzleUIViewControllerDismissViewController: () = {
    let originalSelector = #selector(UIViewController.dismiss(animated:completion:))
    let swizzledSelector = #selector(UIViewController.AM_testDismissViewControllerAnimated(_:completion:))
    
    do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
    catch { debugPrint(error) }
}()

fileprivate let swizzleUIViewControllerPresentedViewController: () = {
    let originalSelector = #selector(getter: UIViewController.presentedViewController)
    let swizzledSelector = #selector(UIViewController.AM_testGetPresentedViewController)
    
    do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
    catch { debugPrint(error) }
}()

fileprivate let swizzleUIViewControllerPresentingViewController: () = {
    let originalSelector = #selector(getter: UIViewController.presentingViewController)
    let swizzledSelector = #selector(UIViewController.AM_testGetPresentingViewController)
    
    do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
    catch { debugPrint(error) }
}()

extension UIViewController {
    open override class func initialize() {
        swizzleUIViewControllerPresentViewController
        swizzleUIViewControllerDismissViewController
        swizzleUIViewControllerPresentedViewController
        swizzleUIViewControllerPresentingViewController
    }
    
    func AM_testPresentViewController(_ viewControllerToPresent: UIViewController,
                                      animated flag: Bool,
                                      completion: (() -> Void)?) {
        
        viewControllerToPresent.AM_testPresentingViewController = self
        self.AM_testPresentedViewController = viewControllerToPresent
        completion?()
    }
    
    func AM_testDismissViewControllerAnimated(_ flag: Bool, completion: (() -> Void)?) {
        self.AM_testPresentedViewController?.AM_testPresentingViewController = nil
        self.AM_testPresentedViewController = nil
        completion?()
    }
    
    func AM_testGetPresentedViewController() -> UIViewController? {
        return AM_testPresentedViewController
    }
    
    func AM_testGetPresentingViewController() -> UIViewController? {
        return AM_testPresentingViewController
    }
    
    // MARK: Associated Objects
    
    fileprivate struct AssociatedKeys {
        static var TestPresentedViewController = "AM_testPresentedViewController"
        static var TestPresentingViewController = "AM_testPresentingViewController"
    }
    
    var AM_testPresentedViewController: UIViewController? {
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
    
    var AM_testPresentingViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.TestPresentingViewController) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.TestPresentingViewController,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
