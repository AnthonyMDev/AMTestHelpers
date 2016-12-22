# AMTestHelpers

[![Version](https://img.shields.io/cocoapods/v/AMTestHelpers.svg?style=flat)](http://cocoapods.org/pods/AMTestHelpers)
[![License](https://img.shields.io/cocoapods/l/AMTestHelpers.svg?style=flat)](http://cocoapods.org/pods/AMTestHelpers)
[![Platform](https://img.shields.io/cocoapods/p/AMTestHelpers.svg?style=flat)](http://cocoapods.org/pods/AMTestHelpers)

## Installation

AMTestHelpers is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your test target in your Podfile:

```ruby
pod "AMTestHelpers"
```

## Usage

Once `AMTestHelpers` is included in your test target, all calls to the following methods will be stubbed out through the built in method swizzling.

* `UIViewController`
  * `presentViewController: animated: completion:`
  * `dismissViewControllerAnimated: completion:`
* `UIResponder`
  * `becomeFirstResponder`
  * `resignFirstResponder`
  * `isFirstResponder`

### UIViewController

When `presentViewController: animated: completion:` is called, the property `AM_testPresentedViewController` will be set to the view controller that should be presented and the completion block will then be called sychronously.

When `dismissViewController: animated: completion:` is called, the property `AM_testPresentedViewController` will be set to `nil`and the completion block will then be called sychronously.

Example:

```
func test_nextButtonIsPressed_presentsNextViewController() {
  // when
  viewControllerBeingTested.nextButtonIsPressed()

  // then
  XCTAssert(viewControllerBeingTested.AM_testPresentedViewController is NextViewController)
}
```

### UIResponder

When `becomeFirstResponder` is called, the property `AM_isFirstResponder` will be set to `true`. When `resignFirstResponder` is called, it will be set to `false`. `isFirstResponder` will return the value of `AM_isFirstResponder`.

### UIAlertController

This library adds an `executeHandler()` function to `UIAlertAction` and an `executeAction(withTitle:)` function to `UIAlertController` that can be used in your unit tests to programtically call the handler for an action on a `UIAlertController`.

## Author

Anthony Miller, AnthonyMDev@gmail.com

## License

AMTestHelpers is available under the MIT license. See the LICENSE file for more info.
