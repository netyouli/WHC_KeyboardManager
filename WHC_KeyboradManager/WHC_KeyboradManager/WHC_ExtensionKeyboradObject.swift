//
//  WHC_ExtensionObject.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 16/11/15.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

extension NSObject {
    
    /// 获取app当前显示的控制器
    ///
    /// - returns: 当前显示的控制器
    public func currentViewController() -> UIViewController? {
        var currentViewController: UIViewController!
        let window = UIApplication.shared.delegate?.window
        if window != nil && window! != nil {
            currentViewController = window!!.rootViewController
        }
        return scanCurrentController(currentViewController)
    }
    
    
    /// 扫描获取最前面的控制器
    ///
    /// - parameter viewController: 要扫描的控制器
    ///
    /// - returns: 返回最上面的控制器
    private func scanCurrentController(_ viewController: UIViewController?) -> UIViewController? {
        var currentViewController: UIViewController?
        if viewController != nil {
            if viewController is UINavigationController && (viewController as! UINavigationController).topViewController != nil {
                currentViewController = (viewController as! UINavigationController).topViewController
                currentViewController = scanCurrentController(currentViewController)
            }else if viewController is UITabBarController && (viewController as! UITabBarController).selectedViewController != nil {
                currentViewController = (viewController as! UITabBarController).selectedViewController
                currentViewController = scanCurrentController(currentViewController)
            }else {
                currentViewController = viewController
                var hasPresentController = false
                while let presentedController = currentViewController?.presentedViewController {
                    hasPresentController = true
                    currentViewController = presentedController
                }
                if hasPresentController {
                    currentViewController = scanCurrentController(currentViewController)
                }
            }
        }
        return currentViewController
    }
}
