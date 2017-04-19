//
//  UINavigationController+TestHelpers.m
//  Pods
//
//  Created by Anthony Miller on 4/19/17.
//
//

#import <objc/runtime.h>

#import <JRSwizzle/JRSwizzle.h>

@interface UINavigationController (TestHelpers)
@property (nonatomic, strong) NSArray* AM_testViewControllers;
@property (readonly, nonatomic, nullable) UIViewController* AM_testTopViewController;
@end

@implementation UINavigationController (TestHelpers)
@dynamic AM_testViewControllers;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
 
        NSError *error;
        [self jr_swizzleMethod:@selector(pushViewController:animated:)
                    withMethod:@selector(AM_testPushViewController:animated:)
                         error:&error];
        
        [self jr_swizzleMethod:@selector(popViewControllerAnimated:)
                    withMethod:@selector(AM_testPopViewControllerAnimated:)
                         error:&error];

        [self jr_swizzleMethod:@selector(popToViewController:animated:)
                    withMethod:@selector(AM_testPopToViewController:animated:)
                         error:&error];
        
        [self jr_swizzleMethod:@selector(popToRootViewControllerAnimated:)
                    withMethod:@selector(AM_testPopToRootViewControllerAnimated:)
                         error:&error];
        
        [self jr_swizzleMethod:@selector(viewControllers)
                    withMethod:@selector(AM_testViewControllers)
                         error:&error];
        
        [self jr_swizzleMethod:@selector(setViewControllers:)
                    withMethod:@selector(setAM_testViewControllers:)
                         error:&error];
        
        [self jr_swizzleMethod:@selector(topViewController)
                    withMethod:@selector(AM_testTopViewController)
                         error:&error];
        
        if (error != nil) {
            NSLog(@"%@", error);
        }
    });
}

- (void)AM_testPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewControllers = [self.viewControllers arrayByAddingObject:viewController];
    [self addChildViewController:viewController];
    self.viewControllers = viewControllers;
}

- (nullable UIViewController *)AM_testPopViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedVC = self.viewControllers.lastObject;
    [poppedVC removeFromParentViewController];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [viewControllers removeLastObject];
    self.viewControllers = viewControllers;
    
    return poppedVC;
}

- (nullable NSArray<UIViewController *> *)AM_testPopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray *VCs = [NSMutableArray arrayWithArray:self.viewControllers];
    
    BOOL foundVC = false;
    NSMutableArray *poppedVCs = [NSMutableArray array];
    
    while (!foundVC) {
        UIViewController *VC = VCs.lastObject;
        if (VC == viewController) {
            foundVC = true;
            
        } else {
            [VCs removeLastObject];
            [VC removeFromParentViewController];
            [poppedVCs addObject:VC];
        }
    }
    
    self.viewControllers = VCs;
    return poppedVCs;
}

- (nullable NSArray<UIViewController *> *)AM_testPopToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count <= 1) { return nil; }

    UIViewController *rootVC = self.viewControllers.firstObject;
    
    NSMutableArray *oldVCs = [NSMutableArray arrayWithArray:self.viewControllers];
    [oldVCs removeObjectAtIndex:0];
    
    self.viewControllers = @[rootVC];
    
    for (UIViewController *VC in oldVCs) {
        [VC removeFromParentViewController];
    }
    
    return [NSArray arrayWithArray:oldVCs];
}

- (id)AM_testViewControllers {
    UIViewController *rootVC = self.AM_testViewControllers.firstObject;
    NSArray *VCs = (NSArray *)objc_getAssociatedObject(self, @selector(AM_testViewControllers));
    
    if (VCs != nil) {
        if (rootVC != nil && VCs.firstObject != rootVC) {
            NSMutableArray *mutableVCs = [NSMutableArray arrayWithArray:VCs];
            [mutableVCs insertObject:rootVC atIndex:0];
            return mutableVCs;
            
        } else {
            return VCs;
        }
    }
    
    if (rootVC != nil) {
        objc_setAssociatedObject(self, @selector(AM_testViewControllers), @[rootVC], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return @[rootVC];
        
    } else {
        objc_setAssociatedObject(self, @selector(AM_testViewControllers), @[], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return @[];
    }
}

- (void)setAM_testViewControllers:(NSArray<UIViewController *> *)newValue {
        for (UIViewController *viewController in self.viewControllers) {
            [viewController removeFromParentViewController];
        }
        for (UIViewController *viewController in newValue) {
            [self addChildViewController:viewController];
        }
        objc_setAssociatedObject(self,
                                 @selector(AM_testViewControllers),
                                 newValue,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable UIViewController*)AM_testTopViewController {
    return self.viewControllers.lastObject;
}

@end
