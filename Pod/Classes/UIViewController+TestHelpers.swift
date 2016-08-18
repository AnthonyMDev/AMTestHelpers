//
//  UIViewController+TestHelpers.swift
//  AMTestHelpers
//
//  Created by Anthony Miller on 8/5/15.
//

import UIKit

import JRSwizzle

extension UIViewController {
    public override class func initialize() {
        struct Static {
            static var presentToken: dispatch_once_t = 0
            static var dismissToken: dispatch_once_t = 0
            static var presentedViewControllerToken: dispatch_once_t = 0
            static var presentingViewControllerToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.presentToken) {
            let originalSelector = Selector("presentViewController:animated:completion:")
            let swizzledSelector = Selector("AM_testPresentViewController:animated:completion:")
            
            do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
            catch { debugPrint(error) }
        }
        
        dispatch_once(&Static.dismissToken) {
            let originalSelector = Selector("dismissViewControllerAnimated:completion:")
            let swizzledSelector = Selector("AM_testDismissViewControllerAnimated:completion:")
            
            do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
            catch { debugPrint(error) }
        }
        
        dispatch_once(&Static.presentedViewControllerToken) {
            let originalSelector = Selector("presentedViewController")
            let swizzledSelector = Selector("AM_testGetPresentedViewController")
            
            do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
            catch { debugPrint(error) }
        }
        
        dispatch_once(&Static.presentingViewControllerToken) {
            let originalSelector = Selector("presentingViewController")
            let swizzledSelector = Selector("AM_testGetPresentingViewController")
            
            do { try UIViewController.self.jr_swizzleMethod(originalSelector, withMethod: swizzledSelector) }
            catch { debugPrint(error) }
        }
        
    }
    
    func AM_testPresentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        viewControllerToPresent.AM_testPresentingViewController = self
        self.AM_testPresentedViewController = viewControllerToPresent
        completion?()
    }
    
    func AM_testDismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
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
    
    private struct AssociatedKeys {
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
