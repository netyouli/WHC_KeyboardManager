//
//  NSObject+WHC_ExtensionObject.m
//  WHC_KeyboardManager(OC)
//
//  Created by WHC on 16/11/20.
//  Copyright © 2016年 WHC. All rights reserved.
//
//  Github <https://github.com/netyouli/WHC_KeyboardManager>

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSObject+WHC_Extension.h"

@implementation NSObject (WHC_Extension)

/// 获取app当前显示的控制器
///
/// - returns: app当前显示的控制器
-(UIViewController *)whc_CurrentViewController {
    UIViewController * currentViewController = nil;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (window != nil){
        currentViewController = window.rootViewController;
    }
    return [self scanCurrentController: currentViewController];
}


/// 扫描获取最前面的控制器
///
/// - parameter viewController: 要扫描的控制器
///
/// - returns: 返回最上面的控制器
- (UIViewController *)scanCurrentController:(UIViewController *)viewController {
    UIViewController * currentViewController = nil;
    if (viewController) {
        if ([viewController isKindOfClass:[UINavigationController class]] && ((UINavigationController *)viewController).topViewController != nil) {
            currentViewController = ((UINavigationController *)viewController).topViewController;
            currentViewController = [self scanCurrentController:currentViewController];
        }else if ([viewController isKindOfClass:[UITabBarController class]] && ((UITabBarController *)viewController).selectedViewController != nil) {
            currentViewController = ((UITabBarController *)viewController).selectedViewController;
            currentViewController = [self scanCurrentController:currentViewController];
        }else {
            currentViewController = viewController;
            BOOL hasPresentController = NO;
            UIViewController * presentedController = currentViewController.presentedViewController;
            while (presentedController) {
                currentViewController = presentedController;
                hasPresentController = YES;
                presentedController = currentViewController.presentedViewController;
            }
            if (hasPresentController) {
                currentViewController = [self scanCurrentController: currentViewController];
            }
        }
    }
    return currentViewController;
}

@end
