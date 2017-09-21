//
//  WHC_AutoLayout.swift
//  WHC_Layout
//
//  Created by WHC on 16/7/4.
//  Copyright © 2016年 吴海超. All rights reserved.
//
//  Github <https://github.com/netyouli/WHC_Layout>

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

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif


#if os(iOS) || os(tvOS)
    public typealias WHC_LayoutRelation = NSLayoutRelation
    public typealias WHC_LayoutAttribute = NSLayoutAttribute
    public typealias WHC_VIEW = UIView
    public typealias WHC_COLOR = UIColor
    public typealias WHC_LayoutPriority = UILayoutPriority
#else
    public typealias WHC_LayoutRelation = NSLayoutConstraint.Relation
    public typealias WHC_LayoutAttribute = NSLayoutConstraint.Attribute
    public typealias WHC_VIEW = NSView
    public typealias WHC_COLOR = NSColor
    public typealias WHC_LayoutPriority = NSLayoutConstraint.Priority
#endif

extension WHC_VIEW {
    
    fileprivate struct WHC_LayoutAssociatedObjectKey {
        
        static var kAttributeLeft           = "WHCLayoutAttributeLeft"
        static var kAttributeLeftL          = "WHCLayoutAttributeLeftL"
        static var kAttributeLeftG          = "WHCLayoutAttributeLeftG"
        static var kAttributeRight          = "WHCLayoutAttributeRight"
        static var kAttributeRightL         = "WHCLayoutAttributeRightL"
        static var kAttributeRightG         = "WHCLayoutAttributeRightG"
        static var kAttributeTop            = "WHCLayoutAttributeTop"
        static var kAttributeTopG           = "WHCLayoutAttributeTopG"
        static var kAttributeTopL           = "WHCLayoutAttributeTopL"
        static var kAttributeBottom         = "WHCLayoutAttributeBottom"
        static var kAttributeBottomG        = "WHCLayoutAttributeBottomG"
        static var kAttributeBottomL        = "WHCLayoutAttributeBottomL"
        static var kAttributeLeading        = "WHCLayoutAttributeLeading"
        static var kAttributeLeadingG       = "WHCLayoutAttributeLeadingG"
        static var kAttributeLeadingL       = "WHCLayoutAttributeLeadingL"
        static var kAttributeTrailing       = "WHCLayoutAttributeTrailing"
        static var kAttributeTrailingG      = "WHCLayoutAttributeTrailingG"
        static var kAttributeTrailingL      = "WHCLayoutAttributeTrailingL"
        static var kAttributeWidth          = "WHCLayoutAttributeWidth"
        static var kAttributeWidthG         = "WHCLayoutAttributeWidthG"
        static var kAttributeWidthL         = "WHCLayoutAttributeWidthL"
        static var kAttributeHeight         = "WHCLayoutAttributeHeight"
        static var kAttributeHeightG        = "WHCLayoutAttributeHeightG"
        static var kAttributeHeightL        = "WHCLayoutAttributeHeightL"
        static var kAttributeCenterX        = "WHCLayoutAttributeCenterX"
        static var kAttributeCenterXG       = "WHCLayoutAttributeCenterXG"
        static var kAttributeCenterXL       = "WHCLayoutAttributeCenterXL"
        static var kAttributeCenterY        = "WHCLayoutAttributeCenterY"
        static var kAttributeCenterYG       = "WHCLayoutAttributeCenterYG"
        static var kAttributeCenterYL       = "WHCLayoutAttributeCenterYL"
        static var kAttributeLastBaselineG  = "WHCLayoutAttributeLastBaselineG"
        static var kAttributeLastBaselineL  = "WHCLayoutAttributeLastBaselineL"
        static var kAttributeLastBaseline   = "WHCLayoutAttributeLastBaseline"
        static var kAttributeFirstBaseline  = "WHCLayoutAttributeFirstBaseline"
        static var kAttributeFirstBaselineL = "WHCLayoutAttributeFirstBaselineL"
        static var kAttributeFirstBaselineG = "WHCLayoutAttributeFirstBaselineG"
        
        static var kCurrentConstraints     = "kCurrentConstraints"
    }
    
    /// 当前添加的约束对象
    fileprivate var currentConstraint: NSLayoutConstraint! {
        set {
            objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kCurrentConstraints, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let value = objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kCurrentConstraints)
            if value != nil {
                return value as! NSLayoutConstraint
            }
            return nil
        }
    }
    
    //MARK: - 移除约束 -
    
    /// 获取约束对象视图
    ///
    /// - Parameter constraint: 约束对象
    /// - Returns: 返回约束对象视图
    private func whc_MainViewConstraint(_ constraint: NSLayoutConstraint!) -> WHC_VIEW! {
        var view: WHC_VIEW!
        if constraint != nil {
            if constraint.secondAttribute == .notAnAttribute ||
                constraint.secondItem == nil {
                view = constraint.firstItem as! WHC_VIEW
            }else {
                let firstItem = constraint.firstItem as! WHC_VIEW
                let secondItem = constraint.secondItem as! WHC_VIEW
                if firstItem.superview === secondItem.superview {
                    view = firstItem.superview
                }else {
                    view = secondItem
                }
            }
        }
        return view
    }
    
    
    /// 通用移除视图约束
    ///
    /// - Parameters:
    ///   - attribute: 约束属性
    ///   - mainView: 主视图
    private func whc_CommonRemoveConstraint(_ attribute: WHC_LayoutAttribute, mainView: WHC_VIEW!, to: WHC_VIEW!) {
        var constraint: NSLayoutConstraint!
        var view: WHC_VIEW!
        switch (attribute) {
        case .firstBaseline:
            constraint = self.firstBaselineConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setFirstBaselineConstraint(nil)
            }
            constraint = self.firstBaselineLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setFirstBaselineLessConstraint(nil)
            }
            constraint = self.firstBaselineGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setFirstBaselineGreaterConstraint(nil)
            }
        case .lastBaseline:
            constraint = self.lastBaselineConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLastBaselineConstraint(nil)
            }
            constraint = self.lastBaselineLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLastBaselineLessConstraint(nil)
            }
            constraint = self.lastBaselineGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLastBaselineGreaterConstraint(nil)
            }
        case .centerY:
            constraint = self.centerYConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setCenterYConstraint(nil)
            }
            constraint = self.centerYLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setCenterYLessConstraint(nil)
            }
            constraint = self.centerYGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setCenterYGreaterConstraint(nil)
            }
        case .centerX:
            constraint = self.centerXConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setCenterXConstraint(nil)
            }
            constraint = self.centerXLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setCenterXLessConstraint(nil)
            }
            constraint = self.centerXGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setCenterXGreaterConstraint(nil)
            }
        case .trailing:
            constraint = self.trailingConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setTrailingConstraint(nil)
            }
            constraint = self.trailingLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setTrailingLessConstraint(nil)
            }
            constraint = self.trailingGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setTrailingGreaterConstraint(nil)
            }
        case .leading:
            constraint = self.leadingConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLeadingConstraint(nil)
            }
            constraint = self.leadingLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLeadingLessConstraint(nil)
            }
            constraint = self.leadingGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLeadingGreaterConstraint(nil)
            }
        case .bottom:
            constraint = self.bottomConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setBottomConstraint(nil)
            }
            constraint = self.bottomLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setBottomLessConstraint(nil)
            }
            constraint = self.bottomGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setBottomGreaterConstraint(nil)
            }
        case .top:
            constraint = self.topConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setTopConstraint(nil)
            }
            constraint = self.topLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setTopLessConstraint(nil)
            }
            constraint = self.topGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setTopGreaterConstraint(nil)
            }
        case .right:
            constraint = self.rightConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setRightConstraint(nil)
            }
            constraint = self.rightLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setRightLessConstraint(nil)
            }
            constraint = self.rightGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setRightGreaterConstraint(nil)
            }
        case .left:
            constraint = self.leftConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLeftConstraint(nil)
            }
            constraint = self.leftLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLeftLessConstraint(nil)
            }
            constraint = self.leftGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setLeftGreaterConstraint(nil)
            }
        case .width:
            constraint = self.widthConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setWidthConstraint(nil)
            }
            constraint = self.widthLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setWidthLessConstraint(nil)
            }
            constraint = self.widthGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setWidthGreaterConstraint(nil)
            }
        case .height:
            constraint = self.heightConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setHeightConstraint(nil)
            }
            constraint = self.heightLessConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setHeightLessConstraint(nil)
            }
            constraint = self.heightGreaterConstraint()
            if constraint != nil {
                view = self.whc_MainViewConstraint(constraint)
                view?.removeConstraint(constraint)
                self.setHeightGreaterConstraint(nil)
            }
        default:
            break;
        }
        if mainView != nil {
            let constraints = mainView.constraints
            for constraint in constraints {
                if let linkView = (to != nil ? to : mainView) {
                    if (constraint.firstItem === self && constraint.firstAttribute == attribute && (constraint.secondItem === linkView || constraint.secondItem == nil)) || (constraint.firstItem === linkView && constraint.secondItem === self && constraint.secondAttribute == attribute) {
                        mainView.removeConstraint(constraint)
                    }
                }
            }
        }
    }
    
    
    /// 遍历视图约束并删除指定约束约束
    ///
    /// - Parameters:
    ///   - attr: 约束属性
    ///   - view: 约束视图
    ///   - removeSelf: 是否删除自身约束
    private func whc_SwitchRemoveAttr(_ attr: WHC_LayoutAttribute, view: WHC_VIEW!, to: WHC_VIEW!,  removeSelf: Bool) {
        #if os(iOS) || os(tvOS)
            switch (attr) {
            case .leftMargin,
                 .rightMargin,
                 .topMargin,
                 .bottomMargin,
                 .leadingMargin,
                 .trailingMargin,
                 .centerXWithinMargins,
                 .centerYWithinMargins,
                 
                 .firstBaseline,
                 .lastBaseline,
                 .centerY,
                 .centerX,
                 .trailing,
                 .leading,
                 .bottom,
                 .top,
                 .right,
                 .left:
                self.whc_CommonRemoveConstraint(attr, mainView: view, to: to)
            case .width,
                 .height:
                if removeSelf {
                    self.whc_CommonRemoveConstraint(attr, mainView: self, to: to)
                }
                self.whc_CommonRemoveConstraint(attr, mainView: view, to: to)
            default:
                break;
            }
        #else
            switch (attr) {
            case .firstBaseline,
                 .lastBaseline,
                 .centerY,
                 .centerX,
                 .trailing,
                 .leading,
                 .bottom,
                 .top,
                 .right,
                 .left:
                self.whc_CommonRemoveConstraint(attr, mainView: view, to: to)
            case .width,
                 .height:
                if removeSelf {
                    self.whc_CommonRemoveConstraint(attr, mainView: self, to: to)
                }
                self.whc_CommonRemoveConstraint(attr, mainView: view, to: to)
            default:
                break;
            }
            
        #endif
        
    }
    
    
    /// 重置视图约束（删除自身与其他视图关联的约束）
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_ResetConstraints() -> WHC_VIEW {
        func getMainView(_ constraint: NSLayoutConstraint!) -> WHC_VIEW! {
            var view: WHC_VIEW!
            if constraint != nil &&
                constraint.secondAttribute != .notAnAttribute &&
                constraint.secondItem != nil {
                let firstItem = constraint.firstItem as! WHC_VIEW
                let secondItem = constraint.secondItem as! WHC_VIEW
                if firstItem.superview === secondItem.superview {
                    view = firstItem.superview
                }else {
                    view = secondItem
                }
            }
            return view
        }
        var constraint = self.firstBaselineConstraint()
        var mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setFirstBaselineConstraint(nil)
        }
        
        constraint = self.firstBaselineLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setFirstBaselineLessConstraint(nil)
        }
        
        constraint = self.firstBaselineGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setFirstBaselineGreaterConstraint(nil)
        }
        
        constraint = self.lastBaselineConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLastBaselineConstraint(nil)
        }
        
        constraint = self.lastBaselineLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLastBaselineLessConstraint(nil)
        }
        
        constraint = self.lastBaselineGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLastBaselineGreaterConstraint(nil)
        }
        
        constraint = self.centerYConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setCenterYConstraint(nil)
        }
        
        constraint = self.centerYLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setCenterYLessConstraint(nil)
        }
        
        constraint = self.centerYGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setCenterYGreaterConstraint(nil)
        }
        
        constraint = self.centerXConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setCenterXConstraint(nil)
        }
        
        constraint = self.centerXLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setCenterXLessConstraint(nil)
        }
        
        constraint = self.centerXGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setCenterXGreaterConstraint(nil)
        }
        
        constraint = self.trailingConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setTrailingConstraint(nil)
        }
        
        constraint = self.trailingLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setTrailingLessConstraint(nil)
        }
        
        constraint = self.trailingGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setTrailingGreaterConstraint(nil)
        }
        
        constraint = self.leadingConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLeadingConstraint(nil)
        }
        
        constraint = self.leadingLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLeadingLessConstraint(nil)
        }
        
        constraint = self.leadingGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLeadingGreaterConstraint(nil)
        }
        
        constraint = self.bottomConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setBottomConstraint(nil)
        }
        
        constraint = self.bottomLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setBottomLessConstraint(nil)
        }
        
        constraint = self.bottomGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setBottomGreaterConstraint(nil)
        }
        
        constraint = self.topConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setTopConstraint(nil)
        }
        
        constraint = self.topLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setTopLessConstraint(nil)
        }
        
        constraint = self.topGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setTopGreaterConstraint(nil)
        }
        
        constraint = self.rightConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setRightConstraint(nil)
        }
        
        constraint = self.rightLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setRightLessConstraint(nil)
        }
        
        constraint = self.rightGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setRightGreaterConstraint(nil)
        }
        
        constraint = self.leftConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLeftConstraint(nil)
        }
        
        constraint = self.leftLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLeftLessConstraint(nil)
        }
        
        constraint = self.leftGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setLeftGreaterConstraint(nil)
        }
        
        constraint = self.widthConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setWidthConstraint(nil)
        }
        
        constraint = self.widthLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setWidthLessConstraint(nil)
        }
        
        constraint = self.widthGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setWidthGreaterConstraint(nil)
        }
        
        constraint = self.heightConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setHeightConstraint(nil)
        }
        
        constraint = self.heightLessConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setHeightLessConstraint(nil)
        }
        
        constraint = self.heightGreaterConstraint()
        mainView = getMainView(constraint)
        if mainView != nil {
            mainView!.removeConstraint(constraint!)
            self.setHeightGreaterConstraint(nil)
        }
        return self
    }
    
    
    /// 清除自身与其他视图关联的所有约束
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_ClearConstraints() -> WHC_VIEW {
        autoreleasepool {
            var constraints = self.constraints
            for constraint in constraints {
                if constraint.firstItem === self &&
                    constraint.secondAttribute == .notAnAttribute {
                    self.removeConstraint(constraint)
                }
            }
            let superView = self.superview
            if superView != nil {
                constraints = superView!.constraints
                for constraint in constraints {
                    if constraint.firstItem === self ||
                        constraint.secondItem === self {
                        superView!.removeConstraint(constraint)
                    }
                }
            }
        }
        self.whc_ResetConstraints()
        return self
    }
    
    
    /// 移除与指定视图指定的相关约束集合
    ///
    /// - Parameters:
    ///   - view: 指定视图
    ///   - attrs: 约束属性集合
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RemoveFrom(_ view: WHC_VIEW!, attrs:WHC_LayoutAttribute ...) -> WHC_VIEW {
        for attr in attrs {
            if attr != .notAnAttribute {
                self.whc_SwitchRemoveAttr(attr, view: view, to: nil ,removeSelf: false)
            }
        }
        return self
    }
    
    
    /// 移除与指定关联视图的约束
    ///
    /// - Parameters:
    ///   - view: 关联的视图
    ///   - attrs: 要移除的集合
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RemoveTo(_ view: WHC_VIEW!, attrs:WHC_LayoutAttribute ...) -> WHC_VIEW {
        for attr in attrs {
            if attr != .notAnAttribute {
                self.whc_SwitchRemoveAttr(attr, view: self.superview, to: view ,removeSelf: false)
            }
        }
        return self
    }
    
    /// 移除与自身或者父视图指定的相关约束集合
    ///
    /// - Parameter attrs: 约束属性集合
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RemoveAttrs(_ attrs: WHC_LayoutAttribute ...) -> WHC_VIEW {
        for attr in attrs {
            if attr != .notAnAttribute {
                self.whc_SwitchRemoveAttr(attr, view: self.superview, to: nil, removeSelf: true)
            }
        }
        return self
    }
    
    //MARK: - 设置当前约束优先级 -
    
    
    /// 修改视图约束优先级
    ///
    /// - Parameter priority: 约束优先级
    /// - Returns: 返回当前视图
    @discardableResult
    private func whc_HandleConstraints(priority: WHC_LayoutPriority) -> WHC_VIEW {
        let constraints = self.currentConstraint
        if constraints != nil && constraints!.priority != priority {
            #if os(iOS) || os(tvOS)
                let priorityRequired = UILayoutPriority.required
            #else
                let priorityRequired = NSLayoutConstraint.Priority.required
            #endif
            if constraints!.priority == priorityRequired {
                if constraints!.secondItem == nil ||
                    constraints!.secondAttribute == .notAnAttribute {
                    self.removeConstraint(constraints!)
                    constraints!.priority = priority
                    self.addConstraint(constraints!)
                }else {
                    if self.superview != nil {
                        self.superview!.removeConstraint(constraints!)
                        constraints!.priority = priority
                        self.superview!.addConstraint(constraints!)
                    }
                }
            }else if constraints != nil {
                constraints!.priority = priority
            }
        }
        return self
    }
    
    private func whc_HandleConstraintsRelation(_ relation: WHC_LayoutRelation) -> WHC_VIEW {
        if let constraints = self.currentConstraint, constraints.relation != relation {
            let tmpConstraints = NSLayoutConstraint(item: constraints.firstItem ?? 0, attribute: constraints.firstAttribute, relatedBy: relation, toItem: constraints.secondItem, attribute: constraints.secondAttribute, multiplier: constraints.multiplier, constant: constraints.constant)
            if (constraints.secondItem == nil ||
                constraints.secondAttribute == .notAnAttribute) {
                self.removeConstraint(constraints)
                self.setCacheConstraint(nil, attribute: constraints.firstAttribute, relation: constraints.relation)
                self.addConstraint(tmpConstraints)
                self.setCacheConstraint(tmpConstraints, attribute: tmpConstraints.firstAttribute, relation: tmpConstraints.relation)
                self.currentConstraint = tmpConstraints
            }else {
                if self.superview != nil {
                    self.superview?.removeConstraint(constraints)
                    self.setCacheConstraint(nil, attribute: constraints.firstAttribute, relation: constraints.relation)
                    self.superview?.addConstraint(tmpConstraints)
                    self.setCacheConstraint(tmpConstraints, attribute: tmpConstraints.firstAttribute, relation: tmpConstraints.relation)
                    self.currentConstraint = tmpConstraints
                }
            }
        }
        return self
    }
    
    
    /// 设置当前约束小于等于
    ///
    /// - Returns: 当前视图
    @discardableResult
    public func whc_LessOrEqual() -> WHC_VIEW {
        return whc_HandleConstraintsRelation(.lessThanOrEqual)
    }
    
    /// 设置当前约束大于等于
    ///
    /// - Returns: 当前视图
    @discardableResult
    public func whc_GreaterOrEqual() -> WHC_VIEW {
        return whc_HandleConstraintsRelation(.greaterThanOrEqual)
    }
    
    /// 设置当前约束的低优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityLow() -> WHC_VIEW {
        #if os(iOS) || os(tvOS)
            return whc_HandleConstraints(priority: .defaultLow)
        #else
            return whc_HandleConstraints(priority: .defaultLow)
        #endif
    }
    
    /// 设置当前约束的高优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityHigh() -> WHC_VIEW {
        #if os(iOS) || os(tvOS)
            return whc_HandleConstraints(priority: .defaultHigh)
        #else
            return whc_HandleConstraints(priority: .defaultHigh)
        #endif
    }
    
    
    /// 设置当前约束的默认优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityRequired() -> WHC_VIEW {
        #if os(iOS) || os(tvOS)
            return whc_HandleConstraints(priority: .required)
        #else
            return whc_HandleConstraints(priority: .required)
        #endif
    }
    
    /// 设置当前约束的合适优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityFitting() -> WHC_VIEW {
        #if os(iOS) || os(tvOS)
            return whc_HandleConstraints(priority: .fittingSizeLevel)
        #else
            return whc_HandleConstraints(priority: .fittingSizeCompression)
        #endif
    }
    
    /// 设置当前约束的优先级
    ///
    /// - Parameter value: 优先级大小(0-1000)
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Priority(_ value: CGFloat) -> WHC_VIEW {
        return whc_HandleConstraints(priority: WHC_LayoutPriority(Float(value)))
    }
    
    //MARK: -自动布局公开接口api-
    
    /// 设置左边距(默认相对父视图)
    ///
    /// - Parameter space: 左边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Left(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .left, constant: space)
    }
    
    /// 设置左边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 左边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Left(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.right
        if toView.superview == nil {
            toAttribute = .left
        }else if toView.superview !== self.superview {
            toAttribute = .left
        }
        return self.constraintWithItem(self, attribute: .left, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置左边距相等指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeftEqual(_ view: WHC_VIEW) -> WHC_VIEW {
        return self.whc_LeftEqual(view, offset: 0)
    }
    
    /// 设置左边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeftEqual(_ view: WHC_VIEW, offset: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.left
        return self.constraintWithItem(self, attribute: .left, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
    }
    
    /// 设置右边距(默认相对父视图)
    ///
    /// - Parameter space: 右边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Right(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .right, constant: 0 - space)
    }
    
    /// 设置右边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 右边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Right(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.left
        if toView.superview == nil {
            toAttribute = .right
        }else if toView.superview !== self.superview {
            toAttribute = .right
        }
        return self.constraintWithItem(self, attribute: .right, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置右边距相等指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RightEqual(_ view: WHC_VIEW) -> WHC_VIEW {
        return self.whc_RightEqual(view, offset: 0)
    }
    
    /// 设置右边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RightEqual(_ view: WHC_VIEW, offset: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.right
        return self.constraintWithItem(self, attribute: .right, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
    }
    
    /// 设置左边距(默认相对父视图)
    ///
    /// - Parameter space: 左边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Leading(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .leading, constant: space)
    }
    
    /// 设置左边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 左边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Leading(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.trailing
        if toView.superview == nil {
            toAttribute = .leading
        }else if toView.superview !== self.superview {
            toAttribute = .leading
        }
        return self.constraintWithItem(self, attribute: .leading, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置左边距相等指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeadingEqual(_ view: WHC_VIEW) -> WHC_VIEW {
        return self.whc_LeadingEqual(view, offset: 0)
    }
    
    /// 设置左边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeadingEqual(_ view: WHC_VIEW, offset: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.leading
        return self.constraintWithItem(self, attribute: .leading, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
    }
    
    /// 设置右间距(默认相对父视图)
    ///
    /// - Parameter space: 右边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Trailing(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .trailing, constant: 0.0 - space)
    }
    
    /// 设置右间距与指定视图
    ///
    /// - Parameters:
    ///   - space: 右边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Trailing(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.leading
        if toView.superview == nil {
            toAttribute = .trailing
        }else if toView.superview !== self.superview {
            toAttribute = .trailing
        }
        return self.constraintWithItem(self, attribute: .trailing, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置右对齐相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TrailingEqual(_ view: WHC_VIEW) -> WHC_VIEW {
        return self.whc_TrailingEqual(view, offset: 0)
    }
    
    /// 设置右对齐相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TrailingEqual(_ view: WHC_VIEW, offset: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.trailing
        return self.constraintWithItem(self, attribute: .trailing, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
    }
    
    /// 设置顶边距(默认相对父视图)
    ///
    /// - Parameter space: 顶边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Top(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .top, constant: space)
    }
    
    /// 设置顶边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 顶边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Top(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.bottom
        if toView.superview == nil {
            toAttribute = .top
        }else if toView.superview !== self.superview {
            toAttribute = .top
        }
        return self.constraintWithItem(self, attribute: .top, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置顶边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TopEqual(_ view: WHC_VIEW) -> WHC_VIEW {
        return self.whc_TopEqual(view, offset: 0)
    }
    
    /// 设置顶边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TopEqual(_ view: WHC_VIEW, offset: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.top
        return self.constraintWithItem(self, attribute: .top, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
    }
    
    /// 设置底边距(默认相对父视图)
    ///
    /// - Parameter space: 底边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Bottom(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .bottom, constant: 0 - space)
    }
    
    /// 设置底边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 底边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Bottom(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.top
        return self.constraintWithItem(self, attribute: .bottom, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置底边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_BottomEqual(_ view: WHC_VIEW) -> WHC_VIEW {
        return self.whc_BottomEqual(view, offset: 0)
    }
    
    /// 设置底边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_BottomEqual(_ view: WHC_VIEW, offset: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.bottom
        return self.constraintWithItem(self, attribute: .bottom, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
    }
    
    
    /// 设置宽度
    ///
    /// - Parameter width: 宽度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Width(_ width: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.notAnAttribute
        return self.constraintWithItem(self, attribute: .width, related: .equal, toItem: nil, toAttribute: &toAttribute, multiplier: 0, constant: width)
    }
    
    /// 设置宽度相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_WidthEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .width, constant: 0)
    }
    
    /// 设置宽度按比例相等与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_WidthEqual(_ view: WHC_VIEW!, ratio: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .width, multiplier: ratio, constant: 0)
    }
    
    /// 设置自动宽度
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_WidthAuto() -> WHC_VIEW {
        #if os(iOS) || os(tvOS)
            if let label = self as? UILabel {
                if label.numberOfLines == 0 {
                    label.numberOfLines = 1
                }
            }else if let stackView = self as? WHC_StackView {
                stackView.whc_AutoWidth = true
            }
        #endif
        if widthConstraint() != nil ||
            widthLessConstraint() != nil {
            return whc_Width(0).whc_GreaterOrEqual()
        }
        var toAttribute = WHC_LayoutAttribute.notAnAttribute
        return self.constraintWithItem(self, attribute: .width, related: .greaterThanOrEqual, toItem: nil, toAttribute: &toAttribute, multiplier: 1, constant: 0)
    }
    
    /// 设置视图自身高度与宽度的比
    ///
    /// - Parameter ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_HeightWidthRatio(_ ratio: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.width
        return self.constraintWithItem(self, attribute: .height, related: .equal, toItem: self, toAttribute: &toAttribute, multiplier: ratio, constant: 0)
    }
    
    /// 设置高度
    ///
    /// - Parameter height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Height(_ height: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(nil, attribute: .height, constant: height)
    }
    
    /// 设置高度相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_HeightEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .height, constant: 0)
    }
    
    
    /// 设置高度按比例相等与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_HeightEqual(_ view: WHC_VIEW!, ratio: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .height, multiplier: ratio, constant: 0)
    }
    
    /// 设置自动高度
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_HeightAuto() -> WHC_VIEW {
        #if os(iOS) || os(tvOS)
            if let label = self as? UILabel {
                if label.numberOfLines != 0 {
                    label.numberOfLines = 0
                }
            }else if let stackView = self as? WHC_StackView {
                stackView.whc_AutoHeight = true
            }
        #endif
        if heightConstraint() != nil ||
            heightLessConstraint() != nil {
            return whc_Height(0).whc_GreaterOrEqual()
        }
        var toAttribute = WHC_LayoutAttribute.notAnAttribute
        return self.constraintWithItem(self, attribute: .height, related: .greaterThanOrEqual, toItem: nil, toAttribute: &toAttribute, multiplier: 1, constant: 0)
    }
    
    /// 设置视图自身宽度与高度的比
    ///
    /// - Parameter ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_WidthHeightRatio(_ ratio: CGFloat) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.height
        return self.constraintWithItem(self, attribute: .width, related: .equal, toItem: self, toAttribute: &toAttribute, multiplier: ratio, constant: 0)
    }
    
    /// 设置中心x(默认相对父视图)
    ///
    /// - Parameter x: 中心x偏移量（0与父视图中心x重合）
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterX(_ x: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .centerX, constant: x)
    }
    
    /// 设置中心x相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterXEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .centerX, constant: 0)
    }
    
    /// 设置中心x相等并偏移x与指定视图
    ///
    /// - Parameters:
    ///   - x: x偏移量（0与指定视图重合）
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterX(_ x: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        return self.constraintWithItem(toView, attribute: .centerX, constant: x)
    }
    
    /// 设置中心y偏移(默认相对父视图)
    ///
    /// - Parameter y: 中心y坐标偏移量（0与父视图重合）
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterY(_ y: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .centerY, constant: y)
    }
    
    /// 设置中心y相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterYEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .centerY, constant: 0)
    }
    
    /// 设置中心y相等并偏移x与指定视图
    ///
    /// - Parameters:
    ///   - y: y偏移量（0与指定视图中心y重合）
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterY(_ y: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        return self.constraintWithItem(toView, attribute: .centerY, constant: y)
    }
    
    /// 设置顶部基线边距(默认相对父视图,相当于y)
    ///
    /// - Parameter space: 顶部基线边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLine(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .firstBaseline, constant: 0 - space)
    }
    
    /// 设置顶部基线边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 间距
    ///   - toView: 指定视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLine(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.lastBaseline
        if toView.superview == nil {
            toAttribute = .firstBaseline
        }else if toView.superview !== self.superview {
            toAttribute = .firstBaseline
        }
        return self.constraintWithItem(self, attribute: .firstBaseline, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置顶部基线边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLineEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_FirstBaseLineEqual(view, offset: 0)
    }
    
    /// 设置顶部基线边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLineEqual(_ view: WHC_VIEW!, offset: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .firstBaseline, constant: offset)
    }
    
    /// 设置底部基线边距(默认相对父视图)
    ///
    /// - Parameter space: 间隙
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLine(_ space: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(self.superview, attribute: .lastBaseline, constant: 0 - space)
    }
    
    /// 设置底部基线边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 间距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLine(_ space: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        var toAttribute = WHC_LayoutAttribute.firstBaseline
        if toView.superview == nil {
            toAttribute = .lastBaseline
        }else if toView.superview !== self.superview {
            toAttribute = .lastBaseline
        }
        return self.constraintWithItem(self, attribute: .lastBaseline, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置底部基线边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLineEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_LastBaseLineEqual(view, offset: 0)
    }
    
    /// 设置底部基线边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLineEqual(_ view: WHC_VIEW!, offset: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(view, attribute: .lastBaseline, constant: 0.0 - offset)
    }
    
    /// 设置中心偏移(默认相对父视图)x,y = 0 与父视图中心重合
    ///
    /// - Parameters:
    ///   - x: 中心x偏移量
    ///   - y: 中心y偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Center(_ x: CGFloat, y: CGFloat) -> WHC_VIEW {
        return self.whc_CenterX(x).whc_CenterY(y)
    }
    
    /// 设置中心偏移x,y = 0 与指定视图中心重合
    ///
    /// - Parameters:
    ///   - x: 中心x偏移量
    ///   - y: 中心y偏移量
    ///   - toView: 指定视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Center(_ x: CGFloat, y: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_CenterX(x, toView: toView).whc_CenterY(y, toView: toView)
    }
    
    /// 设置中心相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_CenterXEqual(view).whc_CenterYEqual(view)
    }
    
    /// 设置frame(默认相对父视图)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Frame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> WHC_VIEW {
        return self.whc_Left(left).whc_Top(top).whc_Width(width).whc_Height(height)
    }
    
    /// 设置frame与指定视图
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - height: 高度
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Frame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Width(width).whc_Height(height)
    }
    
    
    /// 设置frame与view相同
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    public func whc_FrameEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_LeftEqual(view).whc_TopEqual(view).whc_SizeEqual(view)
    }
    
    /// 设置size
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Size(_ width: CGFloat, height: CGFloat) -> WHC_VIEW {
        return self.whc_Width(width).whc_Height(height)
    }
    
    /// 设置size相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_SizeEqual(_ view: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_WidthEqual(view).whc_HeightEqual(view)
    }
    
    /// 设置frame (默认相对父视图，宽高自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - bottom: 底边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> WHC_VIEW {
        return self.whc_Left(left).whc_Top(top).whc_Right(right).whc_Bottom(bottom)
    }
    
    /// 设置frame与指定视图（宽高自动）
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - bottom: 底边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Right(right, toView: toView).whc_Bottom(bottom, toView: toView)
    }
    
    /// 设置frame (默认相对父视图，宽度自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat) -> WHC_VIEW {
        return self.whc_Left(left).whc_Top(top).whc_Right(right).whc_Height(height)
    }
    
    /// 设置frame与指定视图（宽度自动）
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - height: 高度
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Right(right, toView: toView).whc_Height(height)
    }
    
    /// 设置frame (默认相对父视图，高度自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - bottom: 底边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat) -> WHC_VIEW {
        return self.whc_Left(left).whc_Top(top).whc_Width(width).whc_Bottom(bottom)
    }
    
    /// 设置frame与指定视图（自动高度）
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - bottom: 底边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat, toView: WHC_VIEW!) -> WHC_VIEW {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Width(width).whc_Bottom(bottom, toView: toView)
    }
    
    //MARK: -私有方法-
    
    fileprivate func setLeftConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setLeftConstraint(constraint)
        case .greaterThanOrEqual:
            setLeftGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setLeftLessConstraint(constraint)
        }
    }
    
    fileprivate func leftConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return leftConstraint()
        case .greaterThanOrEqual:
            return leftGreaterConstraint()
        case .lessThanOrEqual:
            return leftLessConstraint()
        }
    }
    
    fileprivate func setLeftConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeft, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func leftConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeft) as? NSLayoutConstraint
    }
    
    fileprivate func setLeftLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func leftLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftL) as? NSLayoutConstraint
    }
    
    fileprivate func setLeftGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func leftGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftG) as? NSLayoutConstraint
    }
    
    fileprivate func setRightConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setRightConstraint(constraint)
        case .greaterThanOrEqual:
            setRightGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setRightLessConstraint(constraint)
        }
    }
    
    fileprivate func rightConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return rightConstraint()
        case .greaterThanOrEqual:
            return rightGreaterConstraint()
        case .lessThanOrEqual:
            return rightLessConstraint()
        }
    }
    
    fileprivate func setRightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRight, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func rightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRight) as? NSLayoutConstraint
    }
    
    fileprivate func setRightLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func rightLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightL) as? NSLayoutConstraint
    }
    
    fileprivate func setRightGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func rightGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightG) as? NSLayoutConstraint
    }
    
    fileprivate func setTopConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setTopConstraint(constraint)
        case .greaterThanOrEqual:
            setTopGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setTopLessConstraint(constraint)
        }
    }
    
    fileprivate func topConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return topConstraint()
        case .greaterThanOrEqual:
            return topGreaterConstraint()
        case .lessThanOrEqual:
            return topLessConstraint()
        }
    }
    
    fileprivate func setTopConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTop, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func topConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTop) as? NSLayoutConstraint
    }
    
    fileprivate func setTopLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func topLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopL) as? NSLayoutConstraint
    }
    
    fileprivate func setTopGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func topGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopG) as? NSLayoutConstraint
    }
    
    fileprivate func setBottomConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setBottomConstraint(constraint)
        case .greaterThanOrEqual:
            setBottomGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setBottomLessConstraint(constraint)
        }
    }
    
    fileprivate func bottomConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return bottomConstraint()
        case .greaterThanOrEqual:
            return bottomGreaterConstraint()
        case .lessThanOrEqual:
            return bottomLessConstraint()
        }
    }
    
    fileprivate func setBottomConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottom, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func bottomConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottom) as? NSLayoutConstraint
    }
    
    fileprivate func setBottomLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func bottomLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomL) as? NSLayoutConstraint
    }
    
    fileprivate func setBottomGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func bottomGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomG) as? NSLayoutConstraint
    }
    
    fileprivate func setLeadingConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setLeadingConstraint(constraint)
        case .greaterThanOrEqual:
            setLeadingGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setLeadingLessConstraint(constraint)
        }
    }
    
    fileprivate func leadingConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return leadingConstraint()
        case .greaterThanOrEqual:
            return leadingGreaterConstraint()
        case .lessThanOrEqual:
            return leadingLessConstraint()
        }
    }
    
    fileprivate func setLeadingConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeading, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func leadingConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeading) as? NSLayoutConstraint
    }
    
    fileprivate func setLeadingLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func leadingLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingL) as? NSLayoutConstraint
    }
    
    fileprivate func setLeadingGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func leadingGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingG) as? NSLayoutConstraint
    }
    
    fileprivate func setTrailingConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setTrailingConstraint(constraint)
        case .greaterThanOrEqual:
            setTrailingGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setTrailingLessConstraint(constraint)
        }
    }
    
    fileprivate func trailingConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return trailingConstraint()
        case .greaterThanOrEqual:
            return trailingGreaterConstraint()
        case .lessThanOrEqual:
            return trailingLessConstraint()
        }
    }
    
    fileprivate func setTrailingConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailing, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func trailingConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailing) as? NSLayoutConstraint
    }
    
    fileprivate func setTrailingLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func trailingLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingL) as? NSLayoutConstraint
    }
    
    fileprivate func setTrailingGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func trailingGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingG) as? NSLayoutConstraint
    }
    
    fileprivate func setWidthConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setWidthConstraint(constraint)
        case .greaterThanOrEqual:
            setWidthGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setWidthLessConstraint(constraint)
        }
    }
    
    fileprivate func widthConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return widthConstraint()
        case .greaterThanOrEqual:
            return widthGreaterConstraint()
        case .lessThanOrEqual:
            return widthLessConstraint()
        }
        
    }
    
    fileprivate func setWidthConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidth, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func widthConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidth) as? NSLayoutConstraint
    }
    
    fileprivate func setWidthLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func widthLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthL) as? NSLayoutConstraint
    }
    
    fileprivate func setWidthGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func widthGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthG) as? NSLayoutConstraint
    }
    
    fileprivate func setHeightConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setHeightConstraint(constraint)
        case .greaterThanOrEqual:
            setHeightGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setHeightLessConstraint(constraint)
        }
    }
    
    fileprivate func heightConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return heightConstraint()
        case .greaterThanOrEqual:
            return heightGreaterConstraint()
        case .lessThanOrEqual:
            return heightLessConstraint()
        }
    }
    
    fileprivate func setHeightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeight, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func heightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeight) as? NSLayoutConstraint
    }
    
    fileprivate func setHeightLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func heightLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightL) as? NSLayoutConstraint
    }
    
    fileprivate func setHeightGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func heightGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightG) as? NSLayoutConstraint
    }
    
    fileprivate func setCenterXConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setCenterXConstraint(constraint)
        case .greaterThanOrEqual:
            setCenterXGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setCenterXLessConstraint(constraint)
        }
    }
    
    fileprivate func centerXConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return centerXConstraint()
        case .greaterThanOrEqual:
            return centerXGreaterConstraint()
        case .lessThanOrEqual:
            return centerXLessConstraint()
        }
    }
    
    fileprivate func setCenterXConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterX, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func centerXConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterX) as? NSLayoutConstraint
    }
    
    fileprivate func setCenterXLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func centerXLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXL) as? NSLayoutConstraint
    }
    
    fileprivate func setCenterXGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func centerXGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXG) as? NSLayoutConstraint
    }
    
    fileprivate func setCenterYConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setCenterYConstraint(constraint)
        case .greaterThanOrEqual:
            setCenterYGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setCenterYLessConstraint(constraint)
        }
    }
    
    fileprivate func centerYConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return centerYConstraint()
        case .greaterThanOrEqual:
            return centerYGreaterConstraint()
        case .lessThanOrEqual:
            return centerYLessConstraint()
        }
    }
    
    fileprivate func setCenterYConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterY, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func centerYConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterY) as? NSLayoutConstraint
    }
    
    fileprivate func setCenterYLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func centerYLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYL) as? NSLayoutConstraint
    }
    
    fileprivate func setCenterYGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func centerYGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYG) as? NSLayoutConstraint
    }
    
    fileprivate func setLastBaselineConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setLastBaselineConstraint(constraint)
        case .greaterThanOrEqual:
            setLastBaselineGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setLastBaselineLessConstraint(constraint)
        }
    }
    
    fileprivate func lastBaselineConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return lastBaselineConstraint()
        case .greaterThanOrEqual:
            return lastBaselineGreaterConstraint()
        case .lessThanOrEqual:
            return lastBaselineLessConstraint()
        }
    }
    
    fileprivate func setLastBaselineConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaseline, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func lastBaselineConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaseline) as? NSLayoutConstraint
    }
    
    fileprivate func setLastBaselineLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func lastBaselineLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineL) as? NSLayoutConstraint
    }
    
    fileprivate func setLastBaselineGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func lastBaselineGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineG) as? NSLayoutConstraint
    }
    
    fileprivate func setFirstBaselineConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setFirstBaselineConstraint(constraint)
        case .greaterThanOrEqual:
            setFirstBaselineGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setFirstBaselineLessConstraint(constraint)
        }
    }
    
    fileprivate func firstBaselineConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return firstBaselineConstraint()
        case .greaterThanOrEqual:
            return firstBaselineGreaterConstraint()
        case .lessThanOrEqual:
            return firstBaselineLessConstraint()
        }
    }
    
    fileprivate func setFirstBaselineConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaseline, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func firstBaselineConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaseline) as? NSLayoutConstraint
    }
    
    fileprivate func setFirstBaselineLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func firstBaselineLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineL) as? NSLayoutConstraint
    }
    
    fileprivate func setFirstBaselineGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func firstBaselineGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineG) as? NSLayoutConstraint
    }
    
    fileprivate func constraintWithItem(_ item: WHC_VIEW!,
                                        attribute: WHC_LayoutAttribute,
                                        constant: CGFloat) -> WHC_VIEW {
        var toAttribute = attribute
        return self.constraintWithItem(self,
                                       attribute: attribute,
                                       toItem: item,
                                       toAttribute: &toAttribute,
                                       constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: WHC_VIEW!,
                                        attribute: WHC_LayoutAttribute,
                                        multiplier: CGFloat,
                                        constant: CGFloat) -> WHC_VIEW {
        var toAttribute = attribute
        return self.constraintWithItem(self,
                                       attribute: attribute,
                                       toItem: item,
                                       toAttribute: &toAttribute ,
                                       multiplier: multiplier,
                                       constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: WHC_VIEW!,
                                        attribute: WHC_LayoutAttribute,
                                        toItem: WHC_VIEW!,
                                        toAttribute: inout WHC_LayoutAttribute,
                                        constant: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(item,
                                       attribute: attribute,
                                       toItem: toItem,
                                       toAttribute: &toAttribute,
                                       multiplier: 1,
                                       constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: WHC_VIEW!,
                                        attribute: WHC_LayoutAttribute,
                                        toItem: WHC_VIEW!,
                                        toAttribute: inout WHC_LayoutAttribute,
                                        multiplier: CGFloat,
                                        constant: CGFloat) -> WHC_VIEW {
        return self.constraintWithItem(item,
                                       attribute: attribute,
                                       related: .equal,
                                       toItem: toItem,
                                       toAttribute: &toAttribute,
                                       multiplier: multiplier,
                                       constant: constant)
    }
    
    fileprivate func constraintWithItem(_ item: WHC_VIEW!,
                                        attribute: WHC_LayoutAttribute,
                                        related: WHC_LayoutRelation,
                                        toItem: WHC_VIEW!,
                                        toAttribute: inout WHC_LayoutAttribute,
                                        multiplier: CGFloat,
                                        constant: CGFloat) -> WHC_VIEW {
        var superView = item.superview
        if toItem != nil {
            if toItem.superview == nil {
                superView = toItem
            }else if toItem.superview !== item.superview {
                superView = toItem
            }
        }else {
            superView = item
            toAttribute = .notAnAttribute
        }
        if self.translatesAutoresizingMaskIntoConstraints {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        if ((item?.translatesAutoresizingMaskIntoConstraints) != nil) {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        switch attribute {
        case .left:
            var leading = self.leadingConstraint()
            if leading != nil {
                superView!.removeConstraint(leading!)
                self.setLeadingConstraint(nil)
            }
            leading = self.leadingLessConstraint()
            if leading != nil {
                superView!.removeConstraint(leading!)
                self.setLeadingLessConstraint(nil)
            }
            leading = self.leadingGreaterConstraint()
            if leading != nil {
                superView!.removeConstraint(leading!)
                self.setLeadingGreaterConstraint(nil)
            }
            let left = self.leftConstraint(related)
            if left != nil {
                if (left!.firstAttribute == attribute &&
                    left!.secondAttribute == toAttribute &&
                    left!.firstItem === item &&
                    left!.secondItem === toItem &&
                    left!.relation == related &&
                    left!.multiplier == multiplier) {
                    left!.constant = constant
                    return self
                }
                superView!.removeConstraint(left!)
                self.setLeftConstraint(nil, relation: related)
            }
        case .right:
            var trailing = self.trailingConstraint()
            if trailing != nil {
                superView!.removeConstraint(trailing!)
                self.setTrailingConstraint(nil)
            }
            trailing = self.trailingLessConstraint()
            if trailing != nil {
                superView!.removeConstraint(trailing!)
                self.setTrailingLessConstraint(nil)
            }
            trailing = self.trailingGreaterConstraint()
            if trailing != nil {
                superView!.removeConstraint(trailing!)
                self.setTrailingGreaterConstraint(nil)
            }
            let right = self.rightConstraint(related)
            if right != nil {
                if (right!.firstAttribute == attribute &&
                    right!.secondAttribute == toAttribute &&
                    right!.firstItem === item &&
                    right!.secondItem === toItem &&
                    right!.relation == related &&
                    right!.multiplier == multiplier) {
                    right!.constant = constant
                    return self
                }
                superView!.removeConstraint(right!)
                self.setRightConstraint(nil, relation: related)
            }
        case .top:
            var firstBaseline = self.firstBaselineConstraint()
            if firstBaseline != nil {
                superView!.removeConstraint(firstBaseline!)
                self.setFirstBaselineConstraint(nil)
            }
            firstBaseline = self.firstBaselineLessConstraint()
            if firstBaseline != nil {
                superView!.removeConstraint(firstBaseline!)
                self.setFirstBaselineLessConstraint(nil)
            }
            firstBaseline = self.firstBaselineGreaterConstraint()
            if firstBaseline != nil {
                superView!.removeConstraint(firstBaseline!)
                self.setFirstBaselineGreaterConstraint(nil)
            }
            let top = self.topConstraint(related)
            if top != nil {
                if (top!.firstAttribute == attribute &&
                    top!.secondAttribute == toAttribute &&
                    top!.firstItem === item &&
                    top!.secondItem === toItem &&
                    top!.relation == related &&
                    top!.multiplier == multiplier) {
                    top!.constant = constant
                    return self
                }
                superView!.removeConstraint(top!)
                self.setTopConstraint(nil, relation: related)
            }
        case .bottom:
            var lastBaseline = self.lastBaselineConstraint()
            if lastBaseline != nil {
                superView!.removeConstraint(lastBaseline!)
                self.setLastBaselineConstraint(nil)
            }
            lastBaseline = self.lastBaselineLessConstraint()
            if lastBaseline != nil {
                superView!.removeConstraint(lastBaseline!)
                self.setLastBaselineLessConstraint(nil)
            }
            lastBaseline = self.lastBaselineGreaterConstraint()
            if lastBaseline != nil {
                superView!.removeConstraint(lastBaseline!)
                self.setLastBaselineGreaterConstraint(nil)
            }
            let bottom = self.bottomConstraint(related)
            if bottom != nil {
                if (bottom!.firstAttribute == attribute &&
                    bottom!.secondAttribute == toAttribute &&
                    bottom!.firstItem === item &&
                    bottom!.secondItem === toItem &&
                    bottom!.relation == related &&
                    bottom!.multiplier == multiplier) {
                    bottom!.constant = constant
                    return self
                }
                superView!.removeConstraint(bottom!)
                self.setBottomConstraint(nil, relation: related)
            }
        case .leading:
            var left = self.leftConstraint()
            if left != nil {
                superView!.removeConstraint(left!)
                self.setLeftConstraint(nil)
            }
            left = self.leftLessConstraint()
            if left != nil {
                superView!.removeConstraint(left!)
                self.setLeftLessConstraint(nil)
            }
            left = self.leftGreaterConstraint()
            if left != nil {
                superView!.removeConstraint(left!)
                self.setLeftGreaterConstraint(nil)
            }
            let leading = self.leadingConstraint(related)
            if leading != nil {
                if (leading!.firstAttribute == attribute &&
                    leading!.secondAttribute == toAttribute &&
                    leading!.firstItem === item &&
                    leading!.secondItem === toItem &&
                    leading!.relation == related &&
                    leading!.multiplier == multiplier) {
                    leading!.constant = constant
                    return self
                }
                superView!.removeConstraint(leading!)
                self.setLeadingConstraint(nil, relation: related)
            }
        case .trailing:
            var right = self.rightConstraint()
            if right != nil {
                superView!.removeConstraint(right!)
                self.setRightConstraint(nil)
            }
            right = self.rightLessConstraint()
            if right != nil {
                superView!.removeConstraint(right!)
                self.setRightLessConstraint(nil)
            }
            right = self.rightGreaterConstraint()
            if right != nil {
                superView!.removeConstraint(right!)
                self.setRightGreaterConstraint(nil)
            }
            let trailing = self.trailingConstraint(related)
            if trailing != nil {
                if (trailing!.firstAttribute == attribute &&
                    trailing!.secondAttribute == toAttribute &&
                    trailing!.firstItem === item &&
                    trailing!.secondItem === toItem &&
                    trailing!.relation == related &&
                    trailing!.multiplier == multiplier) {
                    trailing!.constant = constant
                    return self
                }
                superView!.removeConstraint(trailing!)
                self.setTrailingConstraint(nil, relation: related)
            }
        case .width:
            let width = self.widthConstraint(related)
            if width != nil {
                if (width!.firstAttribute == attribute &&
                    width!.secondAttribute == toAttribute &&
                    width!.firstItem === item &&
                    width!.secondItem === toItem &&
                    width!.relation == related &&
                    width!.multiplier == multiplier) {
                    width!.constant = constant
                    return self
                }
                if width!.secondAttribute != .notAnAttribute {
                    superView!.removeConstraint(width!)
                }else {
                    self.removeConstraint(width!)
                }
                self.setWidthConstraint(nil, relation: related)
            }
        case .height:
            let height = self.heightConstraint(related)
            if height != nil {
                if (height!.firstAttribute == attribute &&
                    height!.secondAttribute == toAttribute &&
                    height!.firstItem === item &&
                    height!.secondItem === toItem &&
                    height!.relation == related &&
                    height!.multiplier == multiplier) {
                    height!.constant = constant
                    return self
                }
                if height!.secondAttribute != .notAnAttribute {
                    superView!.removeConstraint(height!)
                }else {
                    self.removeConstraint(height!)
                }
                self.setHeightConstraint(nil, relation: related)
            }
        case .centerX:
            let centerX = self.centerXConstraint(related)
            if centerX != nil {
                if (centerX!.firstAttribute == attribute &&
                    centerX!.secondAttribute == toAttribute &&
                    centerX!.firstItem === item &&
                    centerX!.secondItem === toItem &&
                    centerX!.relation == related &&
                    centerX!.multiplier == multiplier) {
                    centerX!.constant = constant
                    return self
                }
                superView!.removeConstraint(centerX!)
                self.setCenterXConstraint(nil, relation: related)
            }
        case .centerY:
            let centerY = self.centerYConstraint(related)
            if centerY != nil {
                if (centerY!.firstAttribute == attribute &&
                    centerY!.secondAttribute == toAttribute &&
                    centerY!.firstItem === item &&
                    centerY!.secondItem === toItem &&
                    centerY!.relation == related &&
                    centerY!.multiplier == multiplier) {
                    centerY!.constant = constant
                    return self
                }
                superView!.removeConstraint(centerY!)
                self.setCenterYConstraint(nil, relation: related)
            }
        case .lastBaseline:
            var bottom = self.bottomConstraint()
            if bottom != nil {
                superView!.removeConstraint(bottom!)
                self.setBottomConstraint(nil)
            }
            bottom = self.bottomLessConstraint()
            if bottom != nil {
                superView!.removeConstraint(bottom!)
                self.setBottomLessConstraint(nil)
            }
            bottom = self.bottomGreaterConstraint()
            if bottom != nil {
                superView!.removeConstraint(bottom!)
                self.setBottomGreaterConstraint(nil)
            }
            let lastBaseline = self.lastBaselineConstraint(related)
            if lastBaseline != nil {
                if (lastBaseline!.firstAttribute == attribute &&
                    lastBaseline!.secondAttribute == toAttribute &&
                    lastBaseline!.firstItem === item &&
                    lastBaseline!.secondItem === toItem &&
                    lastBaseline!.relation == related &&
                    lastBaseline!.multiplier == multiplier) {
                    lastBaseline!.constant = constant
                    return self
                }
                superView!.removeConstraint(lastBaseline!)
                self.setLastBaselineConstraint(nil, relation: related)
            }
        case .firstBaseline:
            var top = self.topConstraint()
            if top != nil {
                superView!.removeConstraint(top!)
                self.setTopConstraint(nil)
            }
            top = self.topLessConstraint()
            if top != nil {
                superView!.removeConstraint(top!)
                self.setTopLessConstraint(nil)
            }
            top = self.topGreaterConstraint()
            if top != nil {
                superView!.removeConstraint(top!)
                self.setTopGreaterConstraint(nil)
            }
            let firstBaseline = self.firstBaselineConstraint(related)
            if firstBaseline != nil {
                if (firstBaseline!.firstAttribute == attribute &&
                    firstBaseline!.secondAttribute == toAttribute &&
                    firstBaseline!.firstItem === item &&
                    firstBaseline!.secondItem === toItem &&
                    firstBaseline!.relation == related &&
                    firstBaseline!.multiplier == multiplier) {
                    firstBaseline!.constant = constant
                    return self
                }
                superView!.removeConstraint(firstBaseline!)
                self.setFirstBaselineConstraint(nil, relation: related)
            }
        default:
            break
        }
        
        let constraint = NSLayoutConstraint(item: item,
                                            attribute: attribute,
                                            relatedBy: related,
                                            toItem: toItem,
                                            attribute: toAttribute,
                                            multiplier: multiplier,
                                            constant: constant)
        setCacheConstraint(constraint, attribute: attribute, relation: related)
        superView!.addConstraint(constraint)
        self.currentConstraint = constraint
        return self
    }
    
    private func setCacheConstraint(_ constraint: NSLayoutConstraint!, attribute: WHC_LayoutAttribute, relation: WHC_LayoutRelation) {
        switch (attribute) {
        case .firstBaseline:
            self.setFirstBaselineConstraint(constraint, relation: relation)
        case .lastBaseline:
            self.setLastBaselineConstraint(constraint, relation: relation)
        case .centerY:
            self.setCenterYConstraint(constraint, relation: relation)
        case .centerX:
            self.setCenterXConstraint(constraint, relation: relation)
        case .trailing:
            self.setTrailingConstraint(constraint, relation: relation)
        case .leading:
            self.setLeadingConstraint(constraint, relation: relation)
        case .bottom:
            self.setBottomConstraint(constraint, relation: relation)
        case .top:
            self.setTopConstraint(constraint, relation: relation)
        case .right:
            self.setRightConstraint(constraint, relation: relation)
        case .left:
            self.setLeftConstraint(constraint, relation: relation)
        case .width:
            self.setWidthConstraint(constraint, relation: relation)
        case .height:
            self.setHeightConstraint(constraint, relation: relation)
        default:
            break;
        }
    }
    
    #if os(iOS) || os(tvOS)
    
    class WHC_Line: WHC_VIEW {
        
    }
    
    struct WHC_Tag {
        static let kLeftLine = 100000
        static let kRightLine = kLeftLine + 1
        static let kTopLine = kRightLine + 1
        static let kBottomLine = kTopLine + 1
    }
    
    fileprivate func createLineWithTag(_ lineTag: Int)  -> WHC_Line! {
        var line: WHC_Line!
        for view in self.subviews {
            if view is WHC_Line && view.tag == lineTag {
                line = view as! WHC_Line
                break
            }
        }
        if line == nil {
            line = WHC_Line()
            line.tag = lineTag
            self.addSubview(line)
        }
        return line
    }
    
    //MARK: -自动添加底部线和顶部线-
    @discardableResult
    public func whc_AddBottomLine(_ height: CGFloat, color: WHC_COLOR) -> WHC_VIEW {
        return self.whc_AddBottomLine(height, color: color, marge: 0)
    }
    
    @discardableResult
    public func whc_AddBottomLine(_ height: CGFloat, color: WHC_COLOR, marge: CGFloat) -> WHC_VIEW {
        let line = self.createLineWithTag(WHC_Tag.kBottomLine)
        line?.backgroundColor = color
        return line!.whc_Right(marge).whc_Left(marge).whc_Height(height).whc_Bottom(0)
    }
    
    @discardableResult
    public func whc_AddTopLine(_ height: CGFloat, color: WHC_COLOR) -> WHC_VIEW {
        return self.whc_AddTopLine(height, color: color, marge: 0)
    }
    
    @discardableResult
    public func whc_AddTopLine(_ height: CGFloat, color: WHC_COLOR, marge: CGFloat) -> WHC_VIEW {
        let line = self.createLineWithTag(WHC_Tag.kTopLine)
        line?.backgroundColor = color
        return line!.whc_Right(marge).whc_Left(marge).whc_Height(height).whc_Top(0)
    }
    
    #endif
}

