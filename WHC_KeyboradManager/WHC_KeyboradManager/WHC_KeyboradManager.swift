//
//  WHC_KeyboradManager.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 16/11/14.
//  Copyright © 2016年 WHC. All rights reserved.
//

//  Github <https://github.com/netyouli/WHC_KeyboradManager>

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

import UIKit

extension NSNotification.Name {
    /// 获取下一个编辑框视图的通知
    static let NextFieldView: NSNotification.Name = NSNotification.Name(rawValue: "GetNextFieldViewNotification")
    /// 获取当前编辑框视图的通知
    static let CurrentFieldView: NSNotification.Name = NSNotification.Name(rawValue: "GetCurrentFieldViewNotification")
    /// 获取上一个编辑框视图的通知
    static let FrontFieldView: NSNotification.Name = NSNotification.Name(rawValue: "GetFrontFieldViewNotification")
}

class WHC_KeyboradManager: NSObject,UITextFieldDelegate, UITextViewDelegate,UIScrollViewDelegate {
    
    /// 获取移动视图的偏移回调块
    private var offsetBlock: ((_ field: UIView?) -> CGFloat)!
    /// 获取移动视图回调
    private var offsetViewBlock: ((_ field: UIView?) -> UIView?)!
    /// 获取键盘将要出现回调块
    private var keyboradWillShowBlock: ((_ notify: Notification) -> Void)!
    /// 获取键盘将要隐藏回调块
    private var keyboradWillHideBlock: ((_ notify: Notification) -> Void)!
    /// 存储输入视图和其对应的delegate对象
    private lazy var fieldDelegates = [UIView: UITextFieldDelegate & UITextViewDelegate]()
    /// 存储编辑框视图集合
    private lazy var fieldViews = [UIView]()
    /// 当前的输入视图(UITextView/UITextField)
    private var currentField: UIView!
    /// 获取app显示最前面的控制器
    private weak var topViewController: UIViewController!
    /// 设置移动的视图动画周期
    private lazy var moveViewAnimationDuration: TimeInterval = 0.5
    /// 存储键盘的frame
    private var keyboradFrame: CGRect!
    /// 存储键盘头视图
    private var headerView: UIView!
    /// 监听UIScrollView内容偏移
    private let kContentOffset = "contentOffset"
    /// 是否已经显示了header
    private var didShowHeader = false
    
    override init() {
        super.init()
        addKeyboradMonitor()
    }
    
    deinit {
        let moveView = offsetViewBlock?(currentField)
        if moveView is UITableView ||
            moveView is UIScrollView ||
            moveView is UICollectionView {
            (moveView as? UIScrollView)?.removeObserver(self, forKeyPath: kContentOffset)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - 私有方法 -
    private func addKeyboradMonitor() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboradWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboradWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func autoMonitor(view: UIView) {
        if view is UITextView {
            if (view as? UITextView)?.delegate != nil {
                fieldDelegates.updateValue((view as? UITextView)!.delegate as! UITextFieldDelegate & UITextViewDelegate, forKey: view)
            }
            if !fieldViews.contains(view) {
                fieldViews.append(view)
            }
            (view as? UITextView)!.delegate = self
        }else if view is UITextField {
            if (view as? UITextField)?.delegate != nil {
                fieldDelegates.updateValue((view as? UITextField)!.delegate as! UITextFieldDelegate & UITextViewDelegate, forKey: view)
            }
            if !fieldViews.contains(view) {
                fieldViews.append(view)
            }
            (view as? UITextField)!.delegate = self
        }else if view.subviews.count > 0 {
            for subView in view.subviews {
                autoMonitor(view: subView)
            }
        }
    }
    
    private func updateHeaderView(rect: CGRect, keyboradDuration: TimeInterval?,complete: (() -> Void)!) {
        if headerView != nil && topViewController != nil {
            if rect.width == 0 {
                if headerView.superview != nil {
                    UIView.animate(withDuration: moveViewAnimationDuration, animations: { 
                        self.headerView.layer.transform = CATransform3DMakeTranslation(0, rect.height + self.headerView.frame.height, 0)
                        }, completion: { (finished) in
                            self.headerView.isHidden = true
                            self.headerView.layer.transform = CATransform3DIdentity
                            self.didShowHeader = false
                            complete?()
                    })
                }
            }else {
                self.headerView.isHidden = false
                if headerView.superview == nil {
                    topViewController.view.addSubview(headerView)
                    if headerView.translatesAutoresizingMaskIntoConstraints {
                        headerView.translatesAutoresizingMaskIntoConstraints = false
                    }
                    headerView.superview?.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: headerView.superview!, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))

                    headerView.superview?.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: headerView.superview!, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))

                    headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 44))

                    headerView.superview?.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.lastBaseline, relatedBy: NSLayoutRelation.equal, toItem: headerView.superview!, attribute: NSLayoutAttribute.lastBaseline, multiplier: 1, constant: -rect.height))
                }else {
                    if !headerView.translatesAutoresizingMaskIntoConstraints {
                        headerView.whc_Left(0).whc_Right(0).whc_BaseLine(rect.height).whc_Height(44)
                        for constraint in headerView.superview!.constraints {
                            if constraint.firstItem === headerView {
                                headerView.superview?.removeConstraint(constraint)
                            }
                        }
                        headerView.superview?.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: headerView.superview!, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
                        
                        headerView.superview?.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: headerView.superview!, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
                        
                        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 44))
                        
                        headerView.superview?.addConstraint(NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.lastBaseline, relatedBy: NSLayoutRelation.equal, toItem: headerView.superview!, attribute: NSLayoutAttribute.lastBaseline, multiplier: 1, constant: -rect.height))
                    }else {
                        headerView.frame = CGRect(x: 0, y: topViewController.view.bounds.height - rect.height - 44, width: topViewController.view.bounds.width, height: 44)
                    }
                }
                if !didShowHeader {
                    headerView.alpha = 0
                    let duration = keyboradDuration == nil ? 0.25 : keyboradDuration!
                    UIView.animate(withDuration: duration, delay: duration, options: UIViewAnimationOptions.curveEaseOut, animations: {
                            self.headerView.alpha = 1
                        }, completion: { (finished) in
                            self.didShowHeader = true
                            complete?()
                    })
                }
            }
        }else {
            complete?()
        }
    }
    
    //MARK: - 公开接口Api -
    
    /// 设置键盘头视图
    ///
    /// - parameter view: 键盘出现时要置顶的视图
    func whc_SetHeader(view: UIView?) {
        headerView = view
    }
    
    /// 自动监听容器视图里的输入视图的键盘状态或者单个UITextfield/UITextView
    ///
    /// - parameter vc:
    func whc_AutoMonitor(view: UIView) {
        autoMonitor(view: view)
    }
    
    /// 设置键盘挡住要移动视图的偏移量
    ///
    /// - parameter block: 回调block
    func whc_SetOffset(block: @escaping ((_ field: UIView?) -> CGFloat)) {
        offsetBlock = block
    }
    
    
    /// 设置键盘挡住的Field要移动的视图
    ///
    /// - parameter block: 回调block
    func whc_SetOffsetView(block: @escaping ((_ field: UIView?) -> UIView?)) {
        offsetViewBlock = block
    }
    
    /// 清空所有缓存的field(再reloadData需要调用)
    func whc_ClearCacheField() {
        fieldViews.removeAll()
        fieldDelegates.removeAll()
    }
    
    /// 设置键盘将要出现的回调
    ///
    /// - parameter block: 回调块
    func whc_SetKeyboradWillShow(block: @escaping ((_ notify: Notification) -> Void)) {
        keyboradWillShowBlock = block
    }
    
    /// 设置键盘将要隐藏的回调
    ///
    /// - parameter block: 回调块
    func whc_SetKeyboradWillHide(block: @escaping ((_ notify: Notification) -> Void)) {
        keyboradWillHideBlock = block
    }
    
    //MARK: - 发送通知 -
    private func sendFieldViewNotify() {
        let currentIndex = fieldViews.index(of: currentField)
        NotificationCenter.default.post(name: NSNotification.Name.CurrentFieldView, object: currentField)
        if currentIndex != nil && currentIndex! + 1 < fieldViews.count {
            NotificationCenter.default.post(name: NSNotification.Name.NextFieldView, object: fieldViews[currentIndex! + 1])
        }
        if currentIndex != nil && currentIndex! - 1 >= 0 {
            NotificationCenter.default.post(name: NSNotification.Name.FrontFieldView, object: fieldViews[currentIndex! - 1])
        }
    }
    
    // MARK: - 键盘监听处理 -
    
    @objc private func keyboradWillShow(notify: Notification) {
        let userInfo = notify.userInfo
        keyboradFrame = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboradDuration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        updateHeaderView(rect: keyboradFrame, keyboradDuration: keyboradDuration) { 
            self.keyboradWillShowBlock?(notify)
        }
        if keyboradFrame != nil && topViewController != nil && currentField != nil {
            var moveView = offsetViewBlock?(currentField)
            if moveView == nil {
                moveView = topViewController?.view
            }
            if moveView is UITableView ||
               moveView is UIScrollView ||
               moveView is UICollectionView {
                if moveView != nil {
                    let moveScrollView = moveView as? UIScrollView
                    moveScrollView?.addObserver(self, forKeyPath: kContentOffset, options: NSKeyValueObservingOptions.new, context: nil)
                    moveScrollView?.contentOffset = CGPoint(x: (moveScrollView?.contentOffset.x)!, y: -moveScrollView!.contentInset.top)
                }
            }else {
                moveView?.transform = CGAffineTransform.identity
            }
            headerView?.layoutIfNeeded()
            let convertRect = currentField.convert(currentField.bounds, to: topViewController!.view)
            let yOffset = convertRect.maxY - keyboradFrame!.minY
            let headerHeight: CGFloat = headerView != nil ? headerView.frame.height : 0
            let moveOffset: CGFloat = offsetBlock == nil ? headerHeight : offsetBlock(currentField) + headerHeight
            
            if moveView != nil {
                if moveView is UITableView ||
                   moveView is UIScrollView ||
                   moveView is UICollectionView {
                    let moveScrollView = moveView as! UIScrollView
                    if yOffset >= 0 {
                        UIView.animate(withDuration: moveViewAnimationDuration, animations: { 
                            moveScrollView.contentOffset = CGPoint(x: moveScrollView.contentOffset.x, y:moveOffset + yOffset - moveScrollView.contentInset.top)
                        })
                    }else {
                        if abs(yOffset) < moveOffset {
                            UIView.animate(withDuration: moveViewAnimationDuration, animations: {
                                moveScrollView.contentOffset = CGPoint(x: moveScrollView.contentOffset.x, y: moveOffset + yOffset - moveScrollView.contentInset.top)
                            })
                        }else {
                            UIView.animate(withDuration: moveViewAnimationDuration, animations: {
                                moveScrollView.contentOffset = CGPoint(x: moveScrollView.contentOffset.x, y: -moveScrollView.contentInset.top)
                            })
                        }
                    }
                }else {
                    if yOffset >= 0 {
                        UIView.animate(withDuration: moveViewAnimationDuration, animations: {
                            moveView!.transform  = CGAffineTransform(translationX: 0, y: -(moveOffset + yOffset))
                        })
                    }else {
                        if abs(yOffset) < moveOffset {
                            UIView.animate(withDuration: moveViewAnimationDuration, animations: {
                                moveView!.transform  = CGAffineTransform(translationX: 0, y: -(moveOffset + yOffset))
                            })
                        }else {
                            UIView.animate(withDuration: moveViewAnimationDuration, animations: {
                                moveView!.transform  = CGAffineTransform.identity
                            })
                        }
                    }
                }
            }else {
                print("WHC_KeyboradManager:[offsetView = nil]")
            }
        }
    }
    
    @objc private func keyboradWillHide(notify: Notification) {
        if keyboradFrame == nil {
            keyboradFrame = CGRect.zero
        }
        keyboradFrame.size.width = 0
        updateHeaderView(rect: keyboradFrame, keyboradDuration: 0) { 
            self.keyboradWillHideBlock?(notify)
        }
        keyboradFrame = CGRect.zero
        let moveView = offsetViewBlock?(currentField)
        if moveView is UITableView ||
            moveView is UIScrollView ||
            moveView is UICollectionView {
            let scrollMoveView = moveView as? UIScrollView
            if scrollMoveView != nil {
                UIView.animate(withDuration: moveViewAnimationDuration, animations: {
                    if scrollMoveView!.contentOffset.y < -scrollMoveView!.contentInset.top {
                        scrollMoveView!.contentOffset = CGPoint(x: (scrollMoveView?.contentOffset.x)!, y: -scrollMoveView!.contentInset.top)
                    }else if scrollMoveView!.contentOffset.y > (scrollMoveView!.contentSize.height - scrollMoveView!.bounds.height + scrollMoveView!.contentInset.bottom) {
                        scrollMoveView!.contentOffset = CGPoint(x: (scrollMoveView?.contentOffset.x)!, y: (scrollMoveView!.contentSize.height - scrollMoveView!.bounds.height + scrollMoveView!.contentInset.bottom))
                    }
                })
            }
        }else {
            UIView.animate(withDuration: moveViewAnimationDuration, animations: {
                moveView!.transform = CGAffineTransform.identity
            })
        }
    }

    //MARK: - 滑动监听 -
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != nil && keyPath! == kContentOffset {
            let contentOffset = (change?[.newKey] as? NSValue)?.cgPointValue
            if contentOffset != nil {
                let scrollView = object as? UIScrollView
                if scrollView != nil && (scrollView!.isDragging || scrollView!.isDecelerating) {
                    let convertRect = currentField.convert(currentField.bounds, to: topViewController!.view)
                    let yOffset = convertRect.maxY - keyboradFrame!.minY
                    if yOffset > 0 {
                        if currentField is UITextView {
                            (currentField as! UITextView).resignFirstResponder()
                        }else if currentField is UITextField {
                            (currentField as! UITextField).resignFirstResponder()
                        }else {
                            currentField.endEditing(true)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - UITextFieldDelegate -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let delegate = fieldDelegates[textField]
        let result = delegate?.textFieldShouldBeginEditing?(textField)
        return result != nil ? result! : true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topViewController == nil {
            topViewController = self.currentViewController()
        }
        currentField = textField
        sendFieldViewNotify()
        let delegate = fieldDelegates[textField]
        delegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let delegate = fieldDelegates[textField]
        delegate?.textFieldDidEndEditing?(textField)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let delegate = fieldDelegates[textField]
        let result = delegate?.textFieldShouldClear?(textField)
        return result != nil ? result! : true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let delegate = fieldDelegates[textField]
        let result = delegate?.textFieldShouldEndEditing?(textField)
        return result != nil ? result! : true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        let delegate = fieldDelegates[textField]
        delegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let delegate = fieldDelegates[textField]
        let result = delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        return result != nil ? result! : true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let delegate = fieldDelegates[textField]
        let result = delegate?.textFieldShouldReturn?(textField)
        if result == nil {
            textField.resignFirstResponder()
        }
        return result != nil ? result! : false
    }
    
    //MARK: - UITextViewDelegate -
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if topViewController == nil {
            topViewController = self.currentViewController()
        }
        currentField = textView
        let delegate = fieldDelegates[textView]
        let result = delegate?.textViewShouldBeginEditing?(textView)
        return result != nil ? result! : true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let delegate = fieldDelegates[textView]
        let result = delegate?.textViewShouldEndEditing?(textView)
        return result != nil ? result! : true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentField = textView
        sendFieldViewNotify()
        let delegate = fieldDelegates[textView]
        delegate?.textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let delegate = fieldDelegates[textView]
        delegate?.textViewDidEndEditing?(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let delegate = fieldDelegates[textView]
        let result = delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text)
        return result != nil ? result! : true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let delegate = fieldDelegates[textView]
        delegate?.textViewDidChange?(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let delegate = fieldDelegates[textView]
        delegate?.textViewDidChangeSelection?(textView)
    }
    
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let delegate = fieldDelegates[textView]
        let result = delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction)
        return result != nil ? result! : true
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let delegate = fieldDelegates[textView]
        let result = delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction)
        return result != nil ? result! : true
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let delegate = fieldDelegates[textView]
        let result = delegate?.textView?(textView, shouldInteractWith: URL, in: characterRange)
        return result != nil ? result! : true
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        let delegate = fieldDelegates[textView]
        let result = delegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange)
        return result != nil ? result! : true
    }
    
}
