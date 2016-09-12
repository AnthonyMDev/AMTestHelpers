func swizzleMethod(_ onClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
  let originalMethod = class_getInstanceMethod(onClass, originalSelector)
  let swizzledMethod = class_getInstanceMethod(onClass, swizzledSelector)
  
  let didAddMethod = class_addMethod(onClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
  
  if didAddMethod {
    class_replaceMethod(onClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }
  
}
