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

private struct WHC_LayoutAssociatedObjectKey {
    
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

public protocol WHC_VIEW: AnyObject {
    associatedtype SELF
}


@available(iOS 9.0, *)
extension WHC_CLASS_LGUIDE: WHC_VIEW {
    public typealias SELF = WHC_CLASS_LGUIDE
}

extension WHC_CLASS_VIEW: WHC_VIEW {
    public typealias SELF = WHC_CLASS_VIEW
    
    
    /// 设置视图抗拉伸优先级（优先级越高越不容易被拉伸）
    ///
    /// - Parameters:
    ///   - priority: 优先级大小默认 251
    ///   - axix: 拉伸方向
    /// - Returns: 当前视图
    @discardableResult
    public func whc_ContentHuggingPriority(_ priority: WHC_LayoutPriority, for axix: WHC_ConstraintAxis) -> Self {
        self.setContentHuggingPriority(priority, for: axix)
        return self
    }
    
    
    /// 设置视图抗压缩优先级（优先级越高越不容易被压缩）
    ///
    /// - Parameters:
    ///   - priority: 优先级大小 750
    ///   - axix: 压缩方向
    /// - Returns: 当前视图
    @discardableResult
    public func whc_ContentCompressionResistancePriority(_ priority: WHC_LayoutPriority, for axix: WHC_ConstraintAxis) -> Self {
        self.setContentCompressionResistancePriority(priority, for: axix)
        return self
    }
    
    
    #if os(iOS) || os(tvOS)
    
    class WHC_Line: WHC_CLASS_VIEW {
        
    }
    
    struct WHC_Tag {
        static let kLeftLine = 100000
        static let kRightLine = kLeftLine + 1
        static let kTopLine = kRightLine + 1
        static let kBottomLine = kTopLine + 1
    }
    
    private func createLineWithTag(_ lineTag: Int)  -> WHC_Line? {
        var line: WHC_Line!
        for view in self.subviews {
            if view is WHC_Line && view.tag == lineTag {
                line = view as? WHC_Line
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
    public func whc_AddBottomLine(_ height: CGFloat, color: WHC_COLOR) -> SELF {
        return self.whc_AddBottomLine(height, color: color, marge: 0)
    }
    
    @discardableResult
    public func whc_AddBottomLine(_ height: CGFloat, color: WHC_COLOR, marge: CGFloat) -> SELF {
        let line = self.createLineWithTag(WHC_Tag.kBottomLine)
        line?.backgroundColor = color
        line!.whc_Right(marge).whc_Left(marge).whc_Height(height).whc_Bottom(0)
        return self
    }
    
    @discardableResult
    public func whc_AddTopLine(_ height: CGFloat, color: WHC_COLOR) -> SELF {
        return self.whc_AddTopLine(height, color: color, marge: 0)
    }
    
    @discardableResult
    public func whc_AddTopLine(_ height: CGFloat, color: WHC_COLOR, marge: CGFloat) -> SELF {
        let line = self.createLineWithTag(WHC_Tag.kTopLine)
        line?.backgroundColor = color
        line!.whc_Right(marge).whc_Left(marge).whc_Height(height).whc_Top(0)
        return self
    }
    
    #endif
}

extension WHC_VIEW {
    
    /// 当前添加的约束对象
    private var currentConstraint: NSLayoutConstraint? {
        set {
            objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kCurrentConstraints, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let value = objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kCurrentConstraints)
            if value != nil {
                return value as? NSLayoutConstraint
            }
            return nil
        }
    }
    
    //MARK: - 移除约束 -
    
    /// 获取约束对象视图
    ///
    /// - Parameter constraint: 约束对象
    /// - Returns: 返回约束对象视图
    private func whc_MainViewConstraint(_ constraint: NSLayoutConstraint!) -> WHC_CLASS_VIEW? {
        var view: WHC_CLASS_VIEW?
        if constraint != nil {
            if constraint.secondAttribute == .notAnAttribute ||
                constraint.secondItem == nil {
                view = owningview(constraint.firstItem)
            }else if constraint.firstAttribute == .notAnAttribute ||
                constraint.firstItem == nil {
                view = owningview(constraint.secondItem)
            }else {
                let firstItem = constraint.firstItem
                let secondItem = constraint.secondItem
                if let sameSuperView = mainSuperView(view1: secondItem, view2: firstItem) {
                    view = sameSuperView
                }else if let sameSuperView = mainSuperView(view1: firstItem, view2: secondItem) {
                    view = sameSuperView
                }else {
                    view = secondItem as? WHC_CLASS_VIEW
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
    private func whc_CommonRemoveConstraint(_ attribute: WHC_LayoutAttribute, mainView: AnyObject?, to: AnyObject?) {
        switch (attribute) {
        case .firstBaseline:
            if let constraint = self.firstBaselineConstraint() {
                removeCache(constraint: constraint).setFirstBaselineConstraint(nil)
            }
            if let constraint = self.firstBaselineLessConstraint() {
                removeCache(constraint: constraint).setFirstBaselineLessConstraint(nil)
            }
            if let constraint = self.firstBaselineGreaterConstraint() {
                removeCache(constraint: constraint).setFirstBaselineGreaterConstraint(nil)
            }
        case .lastBaseline:
            if let constraint = self.lastBaselineConstraint() {
                removeCache(constraint: constraint).setLastBaselineConstraint(nil)
            }
            if let constraint = self.lastBaselineLessConstraint() {
                removeCache(constraint: constraint).setLastBaselineLessConstraint(nil)
            }
            if let constraint = self.lastBaselineGreaterConstraint() {
                removeCache(constraint: constraint).setLastBaselineGreaterConstraint(nil)
            }
        case .centerY:
            if let constraint = self.centerYConstraint() {
                removeCache(constraint: constraint).setCenterYConstraint(nil)
            }
            if let constraint = self.centerYLessConstraint() {
                removeCache(constraint: constraint).setCenterYLessConstraint(nil)
            }
            if let constraint = self.centerYGreaterConstraint() {
                removeCache(constraint: constraint).setCenterYGreaterConstraint(nil)
            }
        case .centerX:
            if let constraint = self.centerXConstraint() {
                removeCache(constraint: constraint).setCenterXConstraint(nil)
            }
            if let constraint = self.centerXLessConstraint() {
                removeCache(constraint: constraint).setCenterXLessConstraint(nil)
            }
            if let constraint = self.centerXGreaterConstraint() {
                removeCache(constraint: constraint).setCenterXGreaterConstraint(nil)
            }
        case .trailing:
            if let constraint = self.trailingConstraint() {
                removeCache(constraint: constraint).setTrailingConstraint(nil)
            }
            if let constraint = self.trailingLessConstraint() {
                removeCache(constraint: constraint).setTrailingLessConstraint(nil)
            }
            if let constraint = self.trailingGreaterConstraint() {
                removeCache(constraint: constraint).setTrailingGreaterConstraint(nil)
            }
        case .leading:
            if let constraint = self.leadingConstraint() {
                removeCache(constraint: constraint).setLeadingConstraint(nil)
            }
            if let constraint = self.leadingLessConstraint() {
                removeCache(constraint: constraint).setLeadingLessConstraint(nil)
            }
            if let constraint = self.leadingGreaterConstraint() {
                removeCache(constraint: constraint).setLeadingGreaterConstraint(nil)
            }
        case .bottom:
            if let constraint = self.bottomConstraint() {
                removeCache(constraint: constraint).setBottomConstraint(nil)
            }
            if let constraint = self.bottomLessConstraint() {
                removeCache(constraint: constraint).setBottomLessConstraint(nil)
            }
            if let constraint = self.bottomGreaterConstraint() {
                removeCache(constraint: constraint).setBottomGreaterConstraint(nil)
            }
        case .top:
            if let constraint = self.topConstraint() {
                removeCache(constraint: constraint).setTopConstraint(nil)
            }
            if let constraint = self.topLessConstraint() {
                removeCache(constraint: constraint).setTopLessConstraint(nil)
            }
            if let constraint = self.topGreaterConstraint() {
                removeCache(constraint: constraint).setTopGreaterConstraint(nil)
            }
        case .right:
            if let constraint = self.rightConstraint() {
                removeCache(constraint: constraint).setRightConstraint(nil)
            }
            if let constraint = self.rightLessConstraint() {
                removeCache(constraint: constraint).setRightLessConstraint(nil)
            }
            if let constraint = self.rightGreaterConstraint() {
                removeCache(constraint: constraint).setRightGreaterConstraint(nil)
            }
        case .left:
            if let constraint = self.leftConstraint() {
                removeCache(constraint: constraint).setLeftConstraint(nil)
            }
            if let constraint = self.leftLessConstraint() {
                removeCache(constraint: constraint).setLeftLessConstraint(nil)
            }
            if let constraint = self.leftGreaterConstraint() {
                removeCache(constraint: constraint).setLeftGreaterConstraint(nil)
            }
        case .width:
            if let constraint = self.widthConstraint() {
                removeCache(constraint: constraint).setWidthConstraint(nil)
            }
            if let constraint = self.widthLessConstraint() {
                removeCache(constraint: constraint).setWidthLessConstraint(nil)
            }
            if let constraint = self.widthGreaterConstraint() {
                removeCache(constraint: constraint).setWidthGreaterConstraint(nil)
            }
        case .height:
            if let constraint = self.heightConstraint() {
                removeCache(constraint: constraint).setHeightConstraint(nil)
            }
            if let constraint = self.heightLessConstraint() {
                removeCache(constraint: constraint).setHeightLessConstraint(nil)
            }
            if let constraint = self.heightGreaterConstraint() {
                removeCache(constraint: constraint).setHeightGreaterConstraint(nil)
            }
        default:
            break;
        }
        
        if let mView = owningview(mainView) {
            mView.constraints.forEach({ (constraint) in
                if let linkView = (to != nil ? to : mainView) {
                    if (constraint.firstItem === self && constraint.firstAttribute == attribute && (constraint.secondItem === linkView || constraint.secondItem == nil)) || (constraint.firstItem === linkView && constraint.secondItem === self && constraint.secondAttribute == attribute) {
                        mView.removeConstraint(constraint)
                    }
                }
            })
        }
    }
    
    
    /// 遍历视图约束并删除指定约束约束
    ///
    /// - Parameters:
    ///   - attr: 约束属性
    ///   - view: 约束视图
    ///   - removeSelf: 是否删除自身约束
    private func whc_SwitchRemoveAttr(_ attr: WHC_LayoutAttribute, view: AnyObject?, to: AnyObject?,  removeSelf: Bool) {
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
    public func whc_ResetConstraints() -> Self {
        if let constraint = self.firstBaselineConstraint() {
            removeCache(constraint: constraint).setFirstBaselineConstraint(nil)
        }
        if let constraint = self.firstBaselineLessConstraint() {
            removeCache(constraint: constraint).setFirstBaselineLessConstraint(nil)
        }
        if let constraint = self.firstBaselineGreaterConstraint() {
            removeCache(constraint: constraint).setFirstBaselineGreaterConstraint(nil)
        }
        
        
        if let constraint = self.lastBaselineConstraint() {
            removeCache(constraint: constraint).setLastBaselineConstraint(nil)
        }
        if let constraint = self.lastBaselineLessConstraint() {
            removeCache(constraint: constraint).setLastBaselineLessConstraint(nil)
        }
        if let constraint = self.lastBaselineGreaterConstraint() {
            removeCache(constraint: constraint).setLastBaselineGreaterConstraint(nil)
        }
        
        
        if let constraint = self.centerYConstraint() {
            removeCache(constraint: constraint).setCenterYConstraint(nil)
        }
        if let constraint = self.centerYLessConstraint() {
            removeCache(constraint: constraint).setCenterYLessConstraint(nil)
        }
        if let constraint = self.centerYGreaterConstraint() {
            removeCache(constraint: constraint).setCenterYGreaterConstraint(nil)
        }
        
        
        if let constraint = self.centerXConstraint() {
            removeCache(constraint: constraint).setCenterXConstraint(nil)
        }
        if let constraint = self.centerXLessConstraint() {
            removeCache(constraint: constraint).setCenterXLessConstraint(nil)
        }
        if let constraint = self.centerXGreaterConstraint() {
            removeCache(constraint: constraint).setCenterXGreaterConstraint(nil)
        }
        
        
        if let constraint = self.trailingConstraint() {
            removeCache(constraint: constraint).setTrailingConstraint(nil)
        }
        if let constraint = self.trailingLessConstraint() {
            removeCache(constraint: constraint).setTrailingLessConstraint(nil)
        }
        if let constraint = self.trailingGreaterConstraint() {
            removeCache(constraint: constraint).setTrailingGreaterConstraint(nil)
        }
        
        
        if let constraint = self.leadingConstraint() {
            removeCache(constraint: constraint).setLeadingConstraint(nil)
        }
        if let constraint = self.leadingLessConstraint() {
            removeCache(constraint: constraint).setLeadingLessConstraint(nil)
        }
        if let constraint = self.leadingGreaterConstraint() {
            removeCache(constraint: constraint).setLeadingGreaterConstraint(nil)
        }
        
        
        if let constraint = self.bottomConstraint() {
            removeCache(constraint: constraint).setBottomConstraint(nil)
        }
        if let constraint = self.bottomLessConstraint() {
            removeCache(constraint: constraint).setBottomLessConstraint(nil)
        }
        if let constraint = self.bottomGreaterConstraint() {
            removeCache(constraint: constraint).setBottomGreaterConstraint(nil)
        }
        
        
        if let constraint = self.topConstraint() {
            removeCache(constraint: constraint).setTopConstraint(nil)
        }
        if let constraint = self.topLessConstraint() {
            removeCache(constraint: constraint).setTopLessConstraint(nil)
        }
        if let constraint = self.topGreaterConstraint() {
            removeCache(constraint: constraint).setTopGreaterConstraint(nil)
        }
        
        
        if let constraint = self.rightConstraint() {
            removeCache(constraint: constraint).setRightConstraint(nil)
        }
        if let constraint = self.rightLessConstraint() {
            removeCache(constraint: constraint).setRightLessConstraint(nil)
        }
        if let constraint = self.rightGreaterConstraint() {
            removeCache(constraint: constraint).setRightGreaterConstraint(nil)
        }
        
        
        if let constraint = self.leftConstraint() {
            removeCache(constraint: constraint).setLeftConstraint(nil)
        }
        if let constraint = self.leftLessConstraint() {
            removeCache(constraint: constraint).setLeftLessConstraint(nil)
        }
        if let constraint = self.leftGreaterConstraint() {
            removeCache(constraint: constraint).setLeftGreaterConstraint(nil)
        }
        
        
        if let constraint = self.widthConstraint() {
            removeCache(constraint: constraint).setWidthConstraint(nil)
        }
        if let constraint = self.widthLessConstraint() {
            removeCache(constraint: constraint).setWidthLessConstraint(nil)
        }
        if let constraint = self.widthGreaterConstraint() {
            removeCache(constraint: constraint).setWidthGreaterConstraint(nil)
        }
        
        
        if let constraint = self.heightConstraint() {
            removeCache(constraint: constraint).setHeightConstraint(nil)
        }
        if let constraint = self.heightLessConstraint() {
            removeCache(constraint: constraint).setHeightLessConstraint(nil)
        }
        if let constraint = self.heightGreaterConstraint() {
            removeCache(constraint: constraint).setHeightGreaterConstraint(nil)
        }
        return self
    }
    
    
    /// 清除自身与其他视图关联的所有约束
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_ClearConstraints() -> Self {
        autoreleasepool {
            if let sv = owningview() {
                var constraints = sv.constraints
                for constraint in constraints {
                    if constraint.firstItem === self &&
                        constraint.secondAttribute == .notAnAttribute {
                        sv.removeConstraint(constraint)
                    }
                }
                
                var superView: WHC_CLASS_VIEW?
                if #available(iOS 9.0, *) {
                    if let g = guide() {
                        superView = g.owningView
                    }else {
                        superView = sv.superview
                    }
                }else {
                    superView = sv.superview
                }
                if let sview = superView {
                    constraints = sview.constraints
                    for constraint in constraints {
                        if constraint.firstItem === self ||
                            constraint.secondItem === self {
                            sview.removeConstraint(constraint)
                        }
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
    public func whc_RemoveFrom(_ view: AnyObject?, attrs:WHC_LayoutAttribute ...) -> Self {
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
    public func whc_RemoveTo(_ view: AnyObject?, attrs:WHC_LayoutAttribute ...) -> Self {
        for attr in attrs {
            if attr != .notAnAttribute {
                self.whc_SwitchRemoveAttr(attr, view: superview() , to: view ,removeSelf: false)
            }
        }
        return self
    }
    
    /// 移除与自身或者父视图指定的相关约束集合
    ///
    /// - Parameter attrs: 约束属性集合
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RemoveAttrs(_ attrs: WHC_LayoutAttribute ...) -> Self {
        for attr in attrs {
            if attr != .notAnAttribute {
                self.whc_SwitchRemoveAttr(attr, view: superview(), to: nil, removeSelf: true)
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
    private func whc_HandleConstraints(priority: WHC_LayoutPriority) -> Self {
        if let constraints = self.currentConstraint, constraints.priority != priority {
            if constraints.priority == WHC_LayoutPriority.required {
                if let mainView = whc_MainViewConstraint(constraints) {
                    let tmpConstraints = NSLayoutConstraint(item: constraints.firstItem!, attribute: constraints.firstAttribute, relatedBy: constraints.relation, toItem: constraints.secondItem, attribute: constraints.secondAttribute, multiplier: constraints.multiplier, constant: constraints.constant)
                    tmpConstraints.priority = priority
                    mainView.removeConstraint(constraints)
                    mainView.addConstraint(tmpConstraints)
                    self.currentConstraint = tmpConstraints
                    self.setCacheConstraint(nil, attribute: constraints.firstAttribute, relation: constraints.relation)
                    self.setCacheConstraint(tmpConstraints, attribute: tmpConstraints.firstAttribute, relation: tmpConstraints.relation)
                }
            }else {
                constraints.priority = priority
            }
        }
        return self
    }
    
    private func whc_HandleConstraintsRelation(_ relation: WHC_LayoutRelation) -> Self {
        if let constraints = self.currentConstraint, constraints.relation != relation {
            let tmpConstraints = NSLayoutConstraint(item: constraints.firstItem ?? 0, attribute: constraints.firstAttribute, relatedBy: relation, toItem: constraints.secondItem, attribute: constraints.secondAttribute, multiplier: constraints.multiplier, constant: constraints.constant)
            if let mainView = whc_MainViewConstraint(constraints) {
                mainView.removeConstraint(constraints)
                self.setCacheConstraint(nil, attribute: constraints.firstAttribute, relation: constraints.relation)
                mainView.addConstraint(tmpConstraints)
                self.setCacheConstraint(tmpConstraints, attribute: tmpConstraints.firstAttribute, relation: tmpConstraints.relation)
                self.currentConstraint = tmpConstraints
            }
        }
        return self
    }
    
    
    /// 设置当前约束小于等于
    ///
    /// - Returns: 当前视图
    @discardableResult
    public func whc_LessOrEqual() -> Self {
        return whc_HandleConstraintsRelation(.lessThanOrEqual)
    }
    
    /// 设置当前约束大于等于
    ///
    /// - Returns: 当前视图
    @discardableResult
    public func whc_GreaterOrEqual() -> Self {
        return whc_HandleConstraintsRelation(.greaterThanOrEqual)
    }
    
    /// 设置当前约束的低优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityLow() -> Self {
        return whc_HandleConstraints(priority: .defaultLow)
    }
    
    /// 设置当前约束的高优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityHigh() -> Self {
        return whc_HandleConstraints(priority: .defaultHigh)
    }
    
    
    /// 设置当前约束的默认优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityRequired() -> Self {
        return whc_HandleConstraints(priority: .required)
    }
    
    /// 设置当前约束的合适优先级
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_PriorityFitting() -> Self {
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
    public func whc_Priority(_ value: CGFloat) -> Self {
        return whc_HandleConstraints(priority: WHC_LayoutPriority(Float(value)))
    }
    
    //MARK: -自动布局公开接口api -
    
    /// 设置左边距(默认相对父视图)
    ///
    /// - Parameter space: 左边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Left(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
        let sview = superview()
        #if os(iOS)
            if #available(iOS 11.0, *) , isSafe  {
                return self.constraintWithItem(sview?.safeAreaLayoutGuide, attribute: .left, constant: space)
            }
        #endif
        return self.constraintWithItem(sview, attribute: .left, constant: space)
    }
    
    /// 设置左边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 左边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Left(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.right
        if !sameSuperview(view1: toView, view2: self).1 {
            toAttribute = .left
        }
        return self.constraintWithItem(self, attribute: .left, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置左边距相等指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeftEqual(_ view: AnyObject?) -> Self {
        return self.whc_LeftEqual(view, offset: 0)
    }
    
    /// 设置左边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeftEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.left
        return self.constraintWithItem(self, attribute: .left, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
    }
    
    /// 设置右边距(默认相对父视图)
    ///
    /// - Parameter space: 右边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Right(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
        let sview = superview()
        #if os(iOS)
            if #available(iOS 11.0, *) , isSafe  {
                return self.constraintWithItem(sview?.safeAreaLayoutGuide, attribute: .right, constant: 0 - space)
            }
        #endif
        return self.constraintWithItem(sview, attribute: .right, constant: 0 - space)
    }
    
    /// 设置右边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 右边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Right(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.left
        if !sameSuperview(view1: toView, view2: self).1 {
            toAttribute = .right
        }
        return self.constraintWithItem(self, attribute: .right, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置右边距相等指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RightEqual(_ view: AnyObject?) -> Self {
        return self.whc_RightEqual(view, offset: 0)
    }
    
    /// 设置右边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_RightEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.right
        return self.constraintWithItem(self, attribute: .right, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
    }
    
    /// 设置左边距(默认相对父视图)
    ///
    /// - Parameter space: 左边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Leading(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
        let sview = superview()
        #if os(iOS)
            if #available(iOS 11.0, *) , isSafe  {
                return self.constraintWithItem(sview?.safeAreaLayoutGuide, attribute: .leading, constant: space)
            }
        #endif
        return self.constraintWithItem(sview, attribute: .leading, constant: space)
    }
    
    /// 设置左边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 左边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Leading(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.trailing
        if !sameSuperview(view1: toView, view2: self).1 {
            toAttribute = .leading
        }
        return self.constraintWithItem(self, attribute: .leading, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置左边距相等指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeadingEqual(_ view: AnyObject?) -> Self {
        return self.whc_LeadingEqual(view, offset: 0)
    }
    
    /// 设置左边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LeadingEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.leading
        return self.constraintWithItem(self, attribute: .leading, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
    }
    
    /// 设置右间距(默认相对父视图)
    ///
    /// - Parameter space: 右边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Trailing(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
        let sview = superview()
        #if os(iOS)
            if #available(iOS 11.0, *) , isSafe  {
                return self.constraintWithItem(sview?.safeAreaLayoutGuide, attribute: .trailing, constant: 0.0 - space)
            }
        #endif
        return self.constraintWithItem(sview, attribute: .trailing, constant: 0.0 - space)
    }
    
    /// 设置右间距与指定视图
    ///
    /// - Parameters:
    ///   - space: 右边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Trailing(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.leading
        if !sameSuperview(view1: toView, view2: self).1 {
            toAttribute = .trailing
        }
        return self.constraintWithItem(self, attribute: .trailing, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置右对齐相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TrailingEqual(_ view: AnyObject?) -> Self {
        return self.whc_TrailingEqual(view, offset: 0)
    }
    
    /// 设置右对齐相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TrailingEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.trailing
        return self.constraintWithItem(self, attribute: .trailing, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
    }
    
    /// 设置顶边距(默认相对父视图)
    ///
    /// - Parameter space: 顶边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Top(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
        let sview = superview()
        #if os(iOS)
            if #available(iOS 11.0, *) , isSafe  {
                return self.constraintWithItem(sview?.safeAreaLayoutGuide, attribute: .top, constant: space)
            }
        #endif
        return self.constraintWithItem(sview, attribute: .top, constant: space)
    }
    
    /// 设置顶边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 顶边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Top(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.bottom
        if !sameSuperview(view1: toView, view2: self).1 {
            toAttribute = .top
        }
        return self.constraintWithItem(self, attribute: .top, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置顶边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TopEqual(_ view: AnyObject?) -> Self {
        return self.whc_TopEqual(view, offset: 0)
    }
    
    /// 设置顶边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_TopEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.top
        return self.constraintWithItem(self, attribute: .top, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: offset)
    }
    
    /// 设置底边距(默认相对父视图)
    ///
    /// - Parameter space: 底边距
    /// - Parameter isSafe: 是否采用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Bottom(_ space: CGFloat, _ isSafe: Bool = false) -> Self {
        let sview = superview()
        #if os(iOS)
            if #available(iOS 11.0, *) , isSafe  {
                return self.constraintWithItem(sview?.safeAreaLayoutGuide, attribute: .bottom, constant: 0 - space)
            }
        #endif
        return self.constraintWithItem(sview, attribute: .bottom, constant: 0 - space)
    }
    
    /// 设置底边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 底边距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Bottom(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.top
        return self.constraintWithItem(self, attribute: .bottom, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: space)
    }
    
    /// 设置底边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_BottomEqual(_ view: AnyObject?) -> Self {
        return self.whc_BottomEqual(view, offset: 0)
    }
    
    /// 设置底边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_BottomEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.bottom
        return self.constraintWithItem(self, attribute: .bottom, related: .equal, toItem: view, toAttribute: &toAttribute, multiplier: 1, constant: 0.0 - offset)
    }
    
    
    /// 设置宽度
    ///
    /// - Parameter width: 宽度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Width(_ width: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.notAnAttribute
        return self.constraintWithItem(self, attribute: .width, related: .equal, toItem: nil, toAttribute: &toAttribute, multiplier: 0, constant: width)
    }
    
    /// 设置宽度相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_WidthEqual(_ view: AnyObject?) -> Self {
        return self.constraintWithItem(view, attribute: .width, constant: 0)
    }
    
    /// 设置宽度按比例相等与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_WidthEqual(_ view: AnyObject?, ratio: CGFloat) -> Self {
        return self.constraintWithItem(view, attribute: .width, multiplier: ratio, constant: 0)
    }
    
    /// 设置自动宽度
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_WidthAuto() -> Self {
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
    public func whc_HeightWidthRatio(_ ratio: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.width
        return self.constraintWithItem(self, attribute: .height, related: .equal, toItem: self, toAttribute: &toAttribute, multiplier: ratio, constant: 0)
    }
    
    /// 设置高度
    ///
    /// - Parameter height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Height(_ height: CGFloat) -> Self {
        return self.constraintWithItem(nil, attribute: .height, constant: height)
    }
    
    /// 设置高度相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_HeightEqual(_ view: AnyObject?) -> Self {
        return self.constraintWithItem(view, attribute: .height, constant: 0)
    }
    
    
    /// 设置高度按比例相等与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - ratio: 比例
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_HeightEqual(_ view: AnyObject?, ratio: CGFloat) -> Self {
        return self.constraintWithItem(view, attribute: .height, multiplier: ratio, constant: 0)
    }
    
    /// 设置自动高度
    ///
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_HeightAuto() -> Self {
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
    public func whc_WidthHeightRatio(_ ratio: CGFloat) -> Self {
        var toAttribute = WHC_LayoutAttribute.height
        return self.constraintWithItem(self, attribute: .width, related: .equal, toItem: self, toAttribute: &toAttribute, multiplier: ratio, constant: 0)
    }
    
    /// 设置中心x(默认相对父视图)
    ///
    /// - Parameter x: 中心x偏移量（0与父视图中心x重合）
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterX(_ x: CGFloat) -> Self {
        return self.constraintWithItem(superview(), attribute: .centerX, constant: x)
    }
    
    /// 设置中心x相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterXEqual(_ view: AnyObject?) -> Self {
        return self.constraintWithItem(view, attribute: .centerX, constant: 0)
    }
    
    /// 设置中心x相等并偏移x与指定视图
    ///
    /// - Parameters:
    ///   - x: x偏移量（0与指定视图重合）
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterX(_ x: CGFloat, toView: AnyObject?) -> Self {
        return self.constraintWithItem(toView, attribute: .centerX, constant: x)
    }
    
    /// 设置中心y偏移(默认相对父视图)
    ///
    /// - Parameter y: 中心y坐标偏移量（0与父视图重合）
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterY(_ y: CGFloat) -> Self {
        return self.constraintWithItem(superview(), attribute: .centerY, constant: y)
    }
    
    /// 设置中心y相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterYEqual(_ view: AnyObject?) -> Self {
        return self.constraintWithItem(view, attribute: .centerY, constant: 0)
    }
    
    /// 设置中心y相等并偏移x与指定视图
    ///
    /// - Parameters:
    ///   - y: y偏移量（0与指定视图中心y重合）
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterY(_ y: CGFloat, toView: AnyObject?) -> Self {
        return self.constraintWithItem(toView, attribute: .centerY, constant: y)
    }
    
    /// 设置顶部基线边距(默认相对父视图,相当于y)
    ///
    /// - Parameter space: 顶部基线边距
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLine(_ space: CGFloat) -> Self {
        return self.constraintWithItem(superview(), attribute: .firstBaseline, constant: 0 - space)
    }
    
    /// 设置顶部基线边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 间距
    ///   - toView: 指定视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLine(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.lastBaseline
        if !sameSuperview(view1: toView, view2: self).1 {
            toAttribute = .firstBaseline
        }
        return self.constraintWithItem(self, attribute: .firstBaseline, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置顶部基线边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLineEqual(_ view: AnyObject?) -> Self {
        return self.whc_FirstBaseLineEqual(view, offset: 0)
    }
    
    /// 设置顶部基线边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_FirstBaseLineEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        return self.constraintWithItem(view, attribute: .firstBaseline, constant: offset)
    }
    
    /// 设置底部基线边距(默认相对父视图)
    ///
    /// - Parameter space: 间隙
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLine(_ space: CGFloat) -> Self {
        return self.constraintWithItem(superview(), attribute: .lastBaseline, constant: 0 - space)
    }
    
    /// 设置底部基线边距与指定视图
    ///
    /// - Parameters:
    ///   - space: 间距
    ///   - toView: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLine(_ space: CGFloat, toView: AnyObject?) -> Self {
        var toAttribute = WHC_LayoutAttribute.firstBaseline
        if !sameSuperview(view1: toView, view2: self).1 {
            toAttribute = .lastBaseline
        }
        return self.constraintWithItem(self, attribute: .lastBaseline, related: .equal, toItem: toView, toAttribute: &toAttribute, multiplier: 1, constant: 0 - space)
    }
    
    /// 设置底部基线边距相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLineEqual(_ view: AnyObject?) -> Self {
        return self.whc_LastBaseLineEqual(view, offset: 0)
    }
    
    /// 设置底部基线边距相等并偏移与指定视图
    ///
    /// - Parameters:
    ///   - view: 相对视图
    ///   - offset: 偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_LastBaseLineEqual(_ view: AnyObject?, offset: CGFloat) -> Self {
        return self.constraintWithItem(view, attribute: .lastBaseline, constant: 0.0 - offset)
    }
    
    /// 设置中心偏移(默认相对父视图)x,y = 0 与父视图中心重合
    ///
    /// - Parameters:
    ///   - x: 中心x偏移量
    ///   - y: 中心y偏移量
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Center(_ x: CGFloat, y: CGFloat) -> Self {
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
    public func whc_Center(_ x: CGFloat, y: CGFloat, toView: AnyObject?) -> Self {
        return self.whc_CenterX(x, toView: toView).whc_CenterY(y, toView: toView)
    }
    
    /// 设置中心相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_CenterEqual(_ view: AnyObject?) -> Self {
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
    public func whc_Frame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) -> Self {
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
    public func whc_Frame(_ left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat, toView: AnyObject?) -> Self {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Width(width).whc_Height(height)
    }
    
    
    /// 设置frame与view相同
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    public func whc_FrameEqual(_ view: AnyObject?) -> Self {
        return self.whc_LeftEqual(view).whc_TopEqual(view).whc_SizeEqual(view)
    }
    
    /// 设置size
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_Size(_ width: CGFloat, height: CGFloat) -> Self {
        return self.whc_Width(width).whc_Height(height)
    }
    
    /// 设置size相等与指定视图
    ///
    /// - Parameter view: 相对视图
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_SizeEqual(_ view: AnyObject?) -> Self {
        return self.whc_WidthEqual(view).whc_HeightEqual(view)
    }
    
    /// 设置frame (默认相对父视图，宽高自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - bottom: 底边距
    ///   - isSafe: 是否使用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat, _ isSafe: Bool = false) -> Self {
        return self.whc_Left(left, isSafe).whc_Top(top, isSafe).whc_Right(right, isSafe).whc_Bottom(bottom, isSafe)
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
    public func whc_AutoSize(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat, toView: AnyObject?) -> Self {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Right(right, toView: toView).whc_Bottom(bottom, toView: toView)
    }
    
    /// 设置frame (默认相对父视图，宽度自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - right: 右边距
    ///   - height: 高度
    ///   - isSafe: 是否使用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat, _ isSafe: Bool = false) -> Self {
        return self.whc_Left(left, isSafe).whc_Top(top, isSafe).whc_Right(right, isSafe).whc_Height(height)
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
    public func whc_AutoWidth(left: CGFloat, top: CGFloat, right: CGFloat, height: CGFloat, toView: AnyObject?) -> Self {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Right(right, toView: toView).whc_Height(height)
    }
    
    /// 设置frame (默认相对父视图，高度自动)
    ///
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 顶边距
    ///   - width: 宽度
    ///   - bottom: 底边距
    ///   - isSafe: 是否使用安全边界
    /// - Returns: 返回当前视图
    @discardableResult
    public func whc_AutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat, _ isSafe: Bool = false) -> Self {
        return self.whc_Left(left, isSafe).whc_Top(top, isSafe).whc_Width(width).whc_Bottom(bottom, isSafe)
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
    public func whc_AutoHeight(left: CGFloat, top: CGFloat, width: CGFloat, bottom: CGFloat, toView: AnyObject?) -> Self {
        return self.whc_Left(left, toView: toView).whc_Top(top, toView: toView).whc_Width(width).whc_Bottom(bottom, toView: toView)
    }
    
    //MARK: -私有方法-
    
    private func superview(_ object: AnyObject? = nil) -> WHC_CLASS_VIEW? {
        if #available(iOS 9.0, *) {
            switch object {
            case let v as WHC_CLASS_VIEW:
                return v.superview
            case let g as WHC_CLASS_LGUIDE:
                return g.owningView
            default:()
            }
            switch self {
            case let v as WHC_CLASS_VIEW:
                return v.superview
            case let g as WHC_CLASS_LGUIDE:
                return g.owningView
            default:()
            }
        }
        return view(object)?.superview
    }
    
    private func owningview(_ object: AnyObject? = nil) -> WHC_CLASS_VIEW? {
        if #available(iOS 9.0, *) {
            switch object {
            case let v as WHC_CLASS_VIEW:
                return v
            case let g as WHC_CLASS_LGUIDE:
                return g.owningView
            default:()
            }
            switch self {
            case let v as WHC_CLASS_VIEW:
                return v
            case let g as WHC_CLASS_LGUIDE:
                return g.owningView
            default:()
            }
        } else {
            // Fallback on earlier versions
            if let v = object as? WHC_CLASS_VIEW {
                return v
            }
            if let v = self as? WHC_CLASS_VIEW {
                return v
            }
        }
        return nil
    }
    
    private func view(_ object: AnyObject? = nil) -> WHC_CLASS_VIEW? {
        if let v = object as? WHC_CLASS_VIEW {
            return v
        }
        return self as? WHC_CLASS_VIEW
    }
    
    @available(iOS 9.0, *)
    private func guide(_ object: AnyObject? = nil) -> WHC_CLASS_LGUIDE? {
        if let g = object as? WHC_CLASS_LGUIDE {
            return g
        }
        return self as? WHC_CLASS_LGUIDE
    }
    
    private func setLeftConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setLeftConstraint(constraint)
        case .greaterThanOrEqual:
            setLeftGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setLeftLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func leftConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return leftConstraint()
        case .greaterThanOrEqual:
            return leftGreaterConstraint()
        case .lessThanOrEqual:
            return leftLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setLeftConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeft, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func leftConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeft) as? NSLayoutConstraint
    }
    
    private func setLeftLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func leftLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftL) as? NSLayoutConstraint
    }
    
    private func setLeftGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func leftGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeftG) as? NSLayoutConstraint
    }
    
    private func setRightConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setRightConstraint(constraint)
        case .greaterThanOrEqual:
            setRightGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setRightLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func rightConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return rightConstraint()
        case .greaterThanOrEqual:
            return rightGreaterConstraint()
        case .lessThanOrEqual:
            return rightLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setRightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRight, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func rightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRight) as? NSLayoutConstraint
    }
    
    private func setRightLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func rightLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightL) as? NSLayoutConstraint
    }
    
    private func setRightGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func rightGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeRightG) as? NSLayoutConstraint
    }
    
    private func setTopConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setTopConstraint(constraint)
        case .greaterThanOrEqual:
            setTopGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setTopLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func topConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return topConstraint()
        case .greaterThanOrEqual:
            return topGreaterConstraint()
        case .lessThanOrEqual:
            return topLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setTopConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTop, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func topConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTop) as? NSLayoutConstraint
    }
    
    private func setTopLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func topLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopL) as? NSLayoutConstraint
    }
    
    private func setTopGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func topGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTopG) as? NSLayoutConstraint
    }
    
    private func setBottomConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setBottomConstraint(constraint)
        case .greaterThanOrEqual:
            setBottomGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setBottomLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func bottomConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return bottomConstraint()
        case .greaterThanOrEqual:
            return bottomGreaterConstraint()
        case .lessThanOrEqual:
            return bottomLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setBottomConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottom, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func bottomConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottom) as? NSLayoutConstraint
    }
    
    private func setBottomLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func bottomLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomL) as? NSLayoutConstraint
    }
    
    private func setBottomGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func bottomGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeBottomG) as? NSLayoutConstraint
    }
    
    private func setLeadingConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setLeadingConstraint(constraint)
        case .greaterThanOrEqual:
            setLeadingGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setLeadingLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func leadingConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return leadingConstraint()
        case .greaterThanOrEqual:
            return leadingGreaterConstraint()
        case .lessThanOrEqual:
            return leadingLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setLeadingConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeading, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func leadingConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeading) as? NSLayoutConstraint
    }
    
    private func setLeadingLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func leadingLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingL) as? NSLayoutConstraint
    }
    
    private func setLeadingGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func leadingGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLeadingG) as? NSLayoutConstraint
    }
    
    private func setTrailingConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setTrailingConstraint(constraint)
        case .greaterThanOrEqual:
            setTrailingGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setTrailingLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func trailingConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return trailingConstraint()
        case .greaterThanOrEqual:
            return trailingGreaterConstraint()
        case .lessThanOrEqual:
            return trailingLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setTrailingConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailing, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func trailingConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailing) as? NSLayoutConstraint
    }
    
    private func setTrailingLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func trailingLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingL) as? NSLayoutConstraint
    }
    
    private func setTrailingGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func trailingGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeTrailingG) as? NSLayoutConstraint
    }
    
    private func setWidthConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setWidthConstraint(constraint)
        case .greaterThanOrEqual:
            setWidthGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setWidthLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func widthConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return widthConstraint()
        case .greaterThanOrEqual:
            return widthGreaterConstraint()
        case .lessThanOrEqual:
            return widthLessConstraint()
        @unknown default:
            return nil
        }
        
    }
    
    private func setWidthConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidth, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func widthConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidth) as? NSLayoutConstraint
    }
    
    private func setWidthLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func widthLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthL) as? NSLayoutConstraint
    }
    
    private func setWidthGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func widthGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeWidthG) as? NSLayoutConstraint
    }
    
    private func setHeightConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setHeightConstraint(constraint)
        case .greaterThanOrEqual:
            setHeightGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setHeightLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func heightConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return heightConstraint()
        case .greaterThanOrEqual:
            return heightGreaterConstraint()
        case .lessThanOrEqual:
            return heightLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setHeightConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeight, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func heightConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeight) as? NSLayoutConstraint
    }
    
    private func setHeightLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func heightLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightL) as? NSLayoutConstraint
    }
    
    private func setHeightGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func heightGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeHeightG) as? NSLayoutConstraint
    }
    
    private func setCenterXConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setCenterXConstraint(constraint)
        case .greaterThanOrEqual:
            setCenterXGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setCenterXLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func centerXConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return centerXConstraint()
        case .greaterThanOrEqual:
            return centerXGreaterConstraint()
        case .lessThanOrEqual:
            return centerXLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setCenterXConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterX, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func centerXConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterX) as? NSLayoutConstraint
    }
    
    private func setCenterXLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func centerXLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXL) as? NSLayoutConstraint
    }
    
    private func setCenterXGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func centerXGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterXG) as? NSLayoutConstraint
    }
    
    private func setCenterYConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setCenterYConstraint(constraint)
        case .greaterThanOrEqual:
            setCenterYGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setCenterYLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func centerYConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return centerYConstraint()
        case .greaterThanOrEqual:
            return centerYGreaterConstraint()
        case .lessThanOrEqual:
            return centerYLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setCenterYConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterY, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func centerYConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterY) as? NSLayoutConstraint
    }
    
    private func setCenterYLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func centerYLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYL) as? NSLayoutConstraint
    }
    
    private func setCenterYGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func centerYGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeCenterYG) as? NSLayoutConstraint
    }
    
    private func setLastBaselineConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setLastBaselineConstraint(constraint)
        case .greaterThanOrEqual:
            setLastBaselineGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setLastBaselineLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func lastBaselineConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return lastBaselineConstraint()
        case .greaterThanOrEqual:
            return lastBaselineGreaterConstraint()
        case .lessThanOrEqual:
            return lastBaselineLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setLastBaselineConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaseline, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func lastBaselineConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaseline) as? NSLayoutConstraint
    }
    
    private func setLastBaselineLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func lastBaselineLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineL) as? NSLayoutConstraint
    }
    
    private func setLastBaselineGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func lastBaselineGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeLastBaselineG) as? NSLayoutConstraint
    }
    
    private func setFirstBaselineConstraint(_ constraint: NSLayoutConstraint!, relation: WHC_LayoutRelation) {
        switch relation {
        case .equal:
            setFirstBaselineConstraint(constraint)
        case .greaterThanOrEqual:
            setFirstBaselineGreaterConstraint(constraint)
        case .lessThanOrEqual:
            setFirstBaselineLessConstraint(constraint)
        @unknown default:
            break
        }
    }
    
    private func firstBaselineConstraint(_ relation: WHC_LayoutRelation) -> NSLayoutConstraint! {
        switch relation {
        case .equal:
            return firstBaselineConstraint()
        case .greaterThanOrEqual:
            return firstBaselineGreaterConstraint()
        case .lessThanOrEqual:
            return firstBaselineLessConstraint()
        @unknown default:
            return nil
        }
    }
    
    private func setFirstBaselineConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaseline, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func firstBaselineConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaseline) as? NSLayoutConstraint
    }
    
    private func setFirstBaselineLessConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineL, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func firstBaselineLessConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineL) as? NSLayoutConstraint
    }
    
    private func setFirstBaselineGreaterConstraint(_ constraint: NSLayoutConstraint!) {
        objc_setAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineG, constraint, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func firstBaselineGreaterConstraint() -> NSLayoutConstraint! {
        return objc_getAssociatedObject(self, &WHC_LayoutAssociatedObjectKey.kAttributeFirstBaselineG) as? NSLayoutConstraint
    }
    
    private func constraintWithItem(_ item: AnyObject?,
                                    attribute: WHC_LayoutAttribute,
                                    constant: CGFloat) -> Self {
        var toAttribute = attribute
        return self.constraintWithItem(self,
                                       attribute: attribute,
                                       toItem: item,
                                       toAttribute: &toAttribute,
                                       constant: constant)
    }
    
    private func constraintWithItem(_ item: AnyObject?,
                                    attribute: WHC_LayoutAttribute,
                                    multiplier: CGFloat,
                                    constant: CGFloat) -> Self {
        var toAttribute = attribute
        return self.constraintWithItem(self,
                                       attribute: attribute,
                                       toItem: item,
                                       toAttribute: &toAttribute ,
                                       multiplier: multiplier,
                                       constant: constant)
    }
    
    private func constraintWithItem(_ item: AnyObject?,
                                    attribute: WHC_LayoutAttribute,
                                    toItem: AnyObject?,
                                    toAttribute: inout WHC_LayoutAttribute,
                                    constant: CGFloat) -> Self {
        return self.constraintWithItem(item,
                                       attribute: attribute,
                                       toItem: toItem,
                                       toAttribute: &toAttribute,
                                       multiplier: 1,
                                       constant: constant)
    }
    
    private func constraintWithItem(_ item: AnyObject?,
                                    attribute: WHC_LayoutAttribute,
                                    toItem: AnyObject?,
                                    toAttribute: inout WHC_LayoutAttribute,
                                    multiplier: CGFloat,
                                    constant: CGFloat) -> Self {
        return self.constraintWithItem(item,
                                       attribute: attribute,
                                       related: .equal,
                                       toItem: toItem,
                                       toAttribute: &toAttribute,
                                       multiplier: multiplier,
                                       constant: constant)
    }
    
    private func constraintWithItem(_ item: AnyObject?,
                                    attribute: WHC_LayoutAttribute,
                                    related: WHC_LayoutRelation,
                                    toItem: AnyObject?,
                                    toAttribute: inout WHC_LayoutAttribute,
                                    multiplier: CGFloat,
                                    constant: CGFloat) -> Self {
        
        var firstAttribute = attribute
        if toItem == nil {
            toAttribute = .notAnAttribute
        }else if item == nil {
            firstAttribute = .notAnAttribute
        }
        if let sf = view() {
            if sf.translatesAutoresizingMaskIntoConstraints {
                sf.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        if let iv = view(item) {
            iv.translatesAutoresizingMaskIntoConstraints = false
        }
        switch firstAttribute {
        case .left:
            if let leading = self.leadingConstraint() {
                removeCache(constraint: leading).setLeadingConstraint(nil)
            }
            if let leading = self.leadingLessConstraint() {
                removeCache(constraint: leading).setLeadingLessConstraint(nil)
            }
            if let leading = self.leadingGreaterConstraint() {
                removeCache(constraint: leading).setLeadingGreaterConstraint(nil)
            }
            if let left = self.leftConstraint(related) {
                if (left.firstAttribute == firstAttribute &&
                    left.secondAttribute == toAttribute &&
                    left.firstItem === item &&
                    left.secondItem === toItem &&
                    left.relation == related &&
                    left.multiplier == multiplier) {
                    left.constant = constant
                    return self
                }
                removeCache(constraint: left).setLeftConstraint(nil, relation: related)
            }
        case .right:
            if let trailing = self.trailingConstraint() {
                removeCache(constraint: trailing).setTrailingConstraint(nil)
            }
            if let trailing = self.trailingLessConstraint() {
                removeCache(constraint: trailing).setTrailingLessConstraint(nil)
            }
            if let trailing = self.trailingGreaterConstraint() {
                removeCache(constraint: trailing).setTrailingGreaterConstraint(nil)
            }
            
            if let right = self.rightConstraint(related) {
                if (right.firstAttribute == firstAttribute &&
                    right.secondAttribute == toAttribute &&
                    right.firstItem === item &&
                    right.secondItem === toItem &&
                    right.relation == related &&
                    right.multiplier == multiplier) {
                    right.constant = constant
                    return self
                }
                removeCache(constraint: right).setRightConstraint(nil, relation: related)
            }
        case .top:
            if let firstBaseline = self.firstBaselineConstraint() {
                removeCache(constraint: firstBaseline).setFirstBaselineConstraint(nil)
            }
            if let firstBaseline = self.firstBaselineLessConstraint() {
                removeCache(constraint: firstBaseline).setFirstBaselineLessConstraint(nil)
            }
            if let firstBaseline = self.firstBaselineGreaterConstraint() {
                removeCache(constraint: firstBaseline).setFirstBaselineGreaterConstraint(nil)
            }
            if let top = self.topConstraint(related) {
                if (top.firstAttribute == firstAttribute &&
                    top.secondAttribute == toAttribute &&
                    top.firstItem === item &&
                    top.secondItem === toItem &&
                    top.relation == related &&
                    top.multiplier == multiplier) {
                    top.constant = constant
                    return self
                }
                removeCache(constraint: top).setTopConstraint(nil, relation: related)
            }
        case .bottom:
            if let lastBaseline = self.lastBaselineConstraint() {
                removeCache(constraint: lastBaseline).setLastBaselineConstraint(nil)
            }
            if let lastBaseline = self.lastBaselineLessConstraint() {
                removeCache(constraint: lastBaseline).setLastBaselineLessConstraint(nil)
            }
            if let lastBaseline = self.lastBaselineGreaterConstraint() {
                removeCache(constraint: lastBaseline).setLastBaselineGreaterConstraint(nil)
            }
            if let bottom = self.bottomConstraint(related) {
                if (bottom.firstAttribute == firstAttribute &&
                    bottom.secondAttribute == toAttribute &&
                    bottom.firstItem === item &&
                    bottom.secondItem === toItem &&
                    bottom.relation == related &&
                    bottom.multiplier == multiplier) {
                    bottom.constant = constant
                    return self
                }
                removeCache(constraint: bottom).setBottomConstraint(nil, relation: related)
            }
        case .leading:
            if let left = self.leftConstraint() {
                removeCache(constraint: left).setLeftConstraint(nil)
            }
            if let left = self.leftLessConstraint() {
                removeCache(constraint: left).setLeftLessConstraint(nil)
            }
            if let left = self.leftGreaterConstraint() {
                removeCache(constraint: left).setLeftGreaterConstraint(nil)
            }
            if let leading = self.leadingConstraint(related) {
                if (leading.firstAttribute == firstAttribute &&
                    leading.secondAttribute == toAttribute &&
                    leading.firstItem === item &&
                    leading.secondItem === toItem &&
                    leading.relation == related &&
                    leading.multiplier == multiplier) {
                    leading.constant = constant
                    return self
                }
                removeCache(constraint: leading).setLeadingConstraint(nil, relation: related)
            }
        case .trailing:
            if let right = self.rightConstraint() {
                removeCache(constraint: right).setRightConstraint(nil)
            }
            if let right = self.rightLessConstraint() {
                removeCache(constraint: right).setRightLessConstraint(nil)
            }
            if let right = self.rightGreaterConstraint() {
                removeCache(constraint: right).setRightGreaterConstraint(nil)
            }
            if let trailing = self.trailingConstraint(related) {
                if (trailing.firstAttribute == firstAttribute &&
                    trailing.secondAttribute == toAttribute &&
                    trailing.firstItem === item &&
                    trailing.secondItem === toItem &&
                    trailing.relation == related &&
                    trailing.multiplier == multiplier) {
                    trailing.constant = constant
                    return self
                }
                removeCache(constraint: trailing).setTrailingConstraint(nil, relation: related)
            }
        case .width:
            if let width = self.widthConstraint(related) {
                if (width.firstAttribute == firstAttribute &&
                    width.secondAttribute == toAttribute &&
                    width.firstItem === item &&
                    width.secondItem === toItem &&
                    width.relation == related &&
                    width.multiplier == multiplier) {
                    width.constant = constant
                    return self
                }
                removeCache(constraint: width).setWidthConstraint(nil, relation: related)
            }
        case .height:
            if let height = self.heightConstraint(related) {
                if (height.firstAttribute == firstAttribute &&
                    height.secondAttribute == toAttribute &&
                    height.firstItem === item &&
                    height.secondItem === toItem &&
                    height.relation == related &&
                    height.multiplier == multiplier) {
                    height.constant = constant
                    return self
                }
                removeCache(constraint: height).setHeightConstraint(nil, relation: related)
            }
        case .centerX:
            if let centerX = self.centerXConstraint(related) {
                if (centerX.firstAttribute == firstAttribute &&
                    centerX.secondAttribute == toAttribute &&
                    centerX.firstItem === item &&
                    centerX.secondItem === toItem &&
                    centerX.relation == related &&
                    centerX.multiplier == multiplier) {
                    centerX.constant = constant
                    return self
                }
                removeCache(constraint: centerX).setCenterXConstraint(nil, relation: related)
            }
        case .centerY:
            if let centerY = self.centerYConstraint(related) {
                if (centerY.firstAttribute == firstAttribute &&
                    centerY.secondAttribute == toAttribute &&
                    centerY.firstItem === item &&
                    centerY.secondItem === toItem &&
                    centerY.relation == related &&
                    centerY.multiplier == multiplier) {
                    centerY.constant = constant
                    return self
                }
                removeCache(constraint: centerY).setCenterYConstraint(nil, relation: related)
            }
        case .lastBaseline:
            if let bottom = self.bottomConstraint() {
                removeCache(constraint: bottom).setBottomConstraint(nil)
            }
            if let bottom = self.bottomLessConstraint() {
                removeCache(constraint: bottom).setBottomLessConstraint(nil)
            }
            if let bottom = self.bottomGreaterConstraint() {
                removeCache(constraint: bottom).setBottomGreaterConstraint(nil)
            }
            if let lastBaseline = self.lastBaselineConstraint(related) {
                if (lastBaseline.firstAttribute == firstAttribute &&
                    lastBaseline.secondAttribute == toAttribute &&
                    lastBaseline.firstItem === item &&
                    lastBaseline.secondItem === toItem &&
                    lastBaseline.relation == related &&
                    lastBaseline.multiplier == multiplier) {
                    lastBaseline.constant = constant
                    return self
                }
                removeCache(constraint: lastBaseline).setLastBaselineConstraint(nil, relation: related)
            }
        case .firstBaseline:
            if let top = self.topConstraint() {
                removeCache(constraint: top).setTopConstraint(nil)
            }
            if let top = self.topLessConstraint() {
                removeCache(constraint: top).setTopLessConstraint(nil)
            }
            if let top = self.topGreaterConstraint() {
                removeCache(constraint: top).setTopGreaterConstraint(nil)
            }
            if let firstBaseline = self.firstBaselineConstraint(related) {
                if (firstBaseline.firstAttribute == firstAttribute &&
                    firstBaseline.secondAttribute == toAttribute &&
                    firstBaseline.firstItem === item &&
                    firstBaseline.secondItem === toItem &&
                    firstBaseline.relation == related &&
                    firstBaseline.multiplier == multiplier) {
                    firstBaseline.constant = constant
                    return self
                }
                removeCache(constraint: firstBaseline).setFirstBaselineConstraint(nil, relation: related)
            }
        default:
            break
        }
        if item == nil {
            print("约束视图不能为nil")
            return self
        }
        if let superView = mainSuperView(view1: toItem, view2: item) {
            let constraint = NSLayoutConstraint(item: item!,
                                                attribute: attribute,
                                                relatedBy: related,
                                                toItem: toItem,
                                                attribute: toAttribute,
                                                multiplier: multiplier,
                                                constant: constant)
            setCacheConstraint(constraint, attribute: attribute, relation: related)
            superView.addConstraint(constraint)
            self.currentConstraint = constraint
        }
        return self
    }
    
    @discardableResult
    private func removeCache(constraint: NSLayoutConstraint?) -> Self {
        whc_MainViewConstraint(constraint)?.removeConstraint(constraint!)
        return self
    }
    
    private func mainSuperView(view1: AnyObject?, view2: AnyObject?) -> WHC_CLASS_VIEW? {
        var isView1 = true
        var isView2 = true
        if #available(iOS 9.0, *) {
            isView1 = !(view1 != nil && view1 is WHC_CLASS_LGUIDE)
            isView2 = !(view2 != nil && view2 is WHC_CLASS_LGUIDE)
        }
        if isView1 && isView2 {
            if view1 == nil && view2 != nil {
                return view(view2)
            }
            if view1 != nil && view2 == nil {
                return view(view1)
            }
            if view1 == nil && view2 == nil {
                return nil
            }
            if superview(view1) != nil && superview(view2) == nil {
                return view(view2)
            }
            if superview(view1) == nil && superview(view2) != nil {
                return view(view1)
            }
            var data = sameSuperview(view1: view1, view2: view2)
            if let d1 = data.0 {
                return d1
            }else if data.1 && data.0 == nil {
                return view(view1)
            }
            data = sameSuperview(view1: view2, view2: view1)
            if let d1 = data.0 {
                return d1
            }else if data.1 && data.0 == nil {
                return view(view2)
            }
        }else if #available(iOS 9.0, *) {
            if isView1 && !isView2 {
                if view1 != nil {
                    let s_view = view(view1)
                    let s_guide = guide(view2)
                    if s_view === s_guide?.owningView {
                        return s_view
                    }else {
                        if s_view?.superview === s_guide?.owningView {
                            return s_view?.superview
                        }
                        return mainSuperView(view1: s_view?.superview, view2: s_guide?.owningView)
                    }
                }
                return owningview(view2);
            }else if !isView1 && isView2 {
                if view2 != nil {
                    let s_view = view(view2)
                    let s_guide = guide(view1)
                    if s_view === s_guide?.owningView {
                        return s_view
                    }else {
                        if s_view?.superview === s_guide?.owningView {
                            return s_view?.superview
                        }
                        return mainSuperView(view1: s_view?.superview, view2: s_guide?.owningView)
                    }
                }
                return owningview(view1)
            }else {
                if owningview(view1) === owningview(view2) {
                    return owningview(view1)
                }
                return mainSuperView(view1: owningview(view1), view2: owningview(view2))
            }
        }
        return nil
    }
    
    private func checkSubSuperView(superv: WHC_CLASS_VIEW?, subv: WHC_CLASS_VIEW?) -> WHC_CLASS_VIEW? {
        var superView: WHC_CLASS_VIEW?
        if let spv = superv, let sbv = subv, let sbvspv = sbv.superview, spv !== sbv {
            func scanSubv(_ subvs: [WHC_CLASS_VIEW]?) -> WHC_CLASS_VIEW? {
                var superView: WHC_CLASS_VIEW?
                if let tmpsubvs = subvs, !tmpsubvs.isEmpty {
                    if tmpsubvs.contains(sbvspv) {
                        superView = sbvspv
                    }
                    if superView == nil {
                        var sumSubv = [WHC_CLASS_VIEW]()
                        tmpsubvs.forEach({ (sv) in
                            sumSubv.append(contentsOf: sv.subviews)
                        })
                        superView = scanSubv(sumSubv)
                    }
                }
                return superView
            }
            if scanSubv([spv]) != nil {
                superView = spv
            }
        }
        return superView
    }
    
    private func sameSuperview(view1: AnyObject?, view2: AnyObject?) -> (WHC_CLASS_VIEW?, Bool) {
        var isView1 = true
        var isView2 = true
        if #available(iOS 9.0, *) {
            isView1 = !(view1 != nil && view1 is WHC_CLASS_LGUIDE)
            isView2 = !(view2 != nil && view2 is WHC_CLASS_LGUIDE)
        }
        if isView1 && isView2 {
            var tempToItem = view(view1)
            var tempItem = view(view2)
            if let v1 = tempToItem, let v2 = tempItem {
                if checkSubSuperView(superv: v1, subv: v2) != nil {
                    return (v1, false)
                }
            }
            let checkSameSuperview: ((WHC_CLASS_VIEW, WHC_CLASS_VIEW) -> Bool) = {(tmpSuperview, singleView) in
                var tmpSingleView: WHC_CLASS_VIEW? = singleView
                while let tempSingleSuperview = tmpSingleView?.superview {
                    if tmpSuperview === tempSingleSuperview {
                        return true
                    }else {
                        tmpSingleView = tempSingleSuperview
                    }
                }
                return false
            }
            while let toItemSuperview = tempToItem?.superview,
                let itemSuperview = tempItem?.superview  {
                    if toItemSuperview === itemSuperview {
                        return (toItemSuperview, true)
                    }else {
                        tempToItem = toItemSuperview
                        tempItem = itemSuperview
                        if tempToItem?.superview == nil && tempItem?.superview != nil {
                            if checkSameSuperview(tempToItem!, tempItem!) {
                                return (tempToItem, true)
                            }
                        }else if tempToItem?.superview != nil && tempItem?.superview == nil {
                            if checkSameSuperview(tempItem!, tempToItem!) {
                                return (tempItem, true)
                            }
                        }
                    }
            }
            if let v1 = view(view1), let v2 = view(view2) {
                if checkSubSuperView(superv: v2, subv: v1) != nil {
                    return (v2, false)
                }
            }
        }else if #available(iOS 9.0, *) {
            if isView1 && !isView2 {
                if view1 != nil {
                    let s_view = view(view1)
                    let s_guide = guide(view2)
                    if s_view === s_guide?.owningView {
                        return (s_view, false)
                    }else {
                        if s_view?.superview === s_guide?.owningView {
                            var data: (WHC_CLASS_VIEW?, Bool) = (nil, false)
                            #if os(iOS) || os(tvOS)
                                if #available(iOS 11.0, tvOS 11.0, *) {
                                    data.1 = s_view?.superview?.safeAreaLayoutGuide !== s_guide
                                }else {
                                    data.1 = true
                                }
                            #else
                                data.1 = true
                            #endif
                            data.0 = s_view?.superview
                            return data
                        }
                        return sameSuperview(view1: s_view?.superview, view2: s_guide?.owningView)
                    }
                }
                return (owningview(view2), false)
            }else if !isView1 && isView2 {
                if view2 != nil {
                    let s_view = view(view2)
                    let s_guide = guide(view1)
                    if s_view === s_guide?.owningView {
                        return (s_view, false)
                    }else {
                        if s_view?.superview === s_guide?.owningView {
                            var data: (WHC_CLASS_VIEW?, Bool) = (nil, false)
                            #if os(iOS) || os(tvOS)
                                if #available(iOS 11.0, tvOS 11.0, *) {
                                    data.1 = s_view?.superview?.safeAreaLayoutGuide !== s_guide
                                }else {
                                    data.1 = true
                                }
                            #else
                                data.1 = true
                            #endif
                            data.0 = s_view?.superview
                            return data
                        }
                        return sameSuperview(view1: s_view?.superview, view2: s_guide?.owningView)
                    }
                }
                return (owningview(view1), false)
            }else {
                var data: (WHC_CLASS_VIEW?, Bool) = (nil, false)
                if owningview(view1) === owningview(view2) {
                    data.0 = owningview(view1)
                    #if os(iOS) || os(tvOS)
                        if #available(iOS 11.0, tvOS 11.0, *) {
                            data.1 = !(owningview(view1)?.safeAreaLayoutGuide === guide(view2) ||
                                owningview(view2)?.safeAreaLayoutGuide === guide(view1))
                        }else {
                            data.1 = true
                        }
                    #else
                        data.1 = true
                    #endif
                    return data
                }else {
                    return sameSuperview(view1: owningview(view1), view2: owningview(view2))
                }
            }
        }
        return (nil, false)
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
}

