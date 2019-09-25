//
//  WHC_KeyboardHeaderView.swift
//  WHC_KeyboardManager
//
//  Created by WHC on 16/11/16.
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

import UIKit

extension UIColor {
    static var kbBlack: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(white: 1, alpha: 1)
                }
                return UIColor(white: 0, alpha: 1)
            }
        } else {
            // Fallback on earlier versions
            return UIColor.black
        }
    }
    
    static var kbLine: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(white: 0.2, alpha: 1)
                }
                return UIColor(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1)
            }
        } else {
            // Fallback on earlier versions
            return UIColor(red: 244.0 / 255.0, green: 244.0 / 255.0, blue: 244.0 / 255.0, alpha: 1)
        }
    }
}

public class WHC_KeyboardHeaderView: UIView {

    private(set) public var currentFieldView: UIView?
    private(set) public var nextFieldView: UIView?
    private(set) public var frontFieldView: UIView?
    
    private let kMargin: CGFloat = 0
    private let kWidth: CGFloat = 60
    
    /// 点击前一个按钮回调
    public var clickFrontButtonBlock: (() -> Void)!
    /// 点击下一个按钮回调
    public var clickNextButtonBlock: (() -> Void)!
    /// 点击完成按钮回调
    public var clickDoneButtonBlock: (() -> Void)!
    
    /// 只读
    private(set) public lazy var nextButton = UIButton()
    private(set) public lazy var frontButton = UIButton()
    private(set) public lazy var doneButton = UIButton()
    private(set) public lazy var lineView = UIView()
    private lazy var toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    /// 隐藏上一个下一个按钮只保留done按钮
    public var hideNextAndFrontButton = false {
        didSet {
            frontButton.isHidden = hideNextAndFrontButton
            nextButton.isHidden = hideNextAndFrontButton
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        toolBar.backgroundColor = UIColor.clear
        self.addSubview(toolBar)
        self.addSubview(nextButton)
        self.addSubview(frontButton)
        self.addSubview(doneButton)
        self.addSubview(lineView)
        
        lineView.backgroundColor = UIColor.kbLine
        
        frontButton.setTitle("←", for: .normal)
        nextButton.setTitle("→", for: .normal)
        doneButton.setTitle("完成", for: .normal)
        
        frontButton.setTitleColor(UIColor.kbBlack, for: .normal)
        nextButton.setTitleColor(UIColor.kbBlack, for: .normal)
        doneButton.setTitleColor(UIColor.kbBlack, for: .normal)
        
        frontButton.setTitleColor(UIColor.gray, for: .selected)
        nextButton.setTitleColor(UIColor.gray, for: .selected)
        
        frontButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        frontButton.addTarget(self, action: #selector(clickFront(button:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(clickNext(button:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(clickDone(button:)), for: .touchUpInside)
    
        frontButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        
        
        self.addConstraint(NSLayoutConstraint(item: frontButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: kMargin))
        
        frontButton.addConstraint(NSLayoutConstraint(item: frontButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kWidth))
        
        self.addConstraint(NSLayoutConstraint(item: frontButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: frontButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: nextButton, attribute: .left, relatedBy: .equal, toItem: frontButton, attribute: .right, multiplier: 1, constant: kMargin))
        
        nextButton.addConstraint(NSLayoutConstraint(item: nextButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kWidth))
        
        self.addConstraint(NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: nextButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -kMargin))
        
        doneButton.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kWidth))
        
        self.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
    
        
        self.addConstraint(NSLayoutConstraint(item: lineView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        
        lineView.addConstraint(NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0.5))
        
        self.addConstraint(NSLayoutConstraint(item: lineView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: lineView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        
        /// 监听WHC_KeyboardManager通知
        NotificationCenter.default.addObserver(self, selector: #selector(getCurrentFieldView(notify:)), name: NSNotification.Name.CurrentFieldView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getFrontFieldView(notify:)), name: NSNotification.Name.FrontFieldView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getNextFieldView(notify:)), name: NSNotification.Name.NextFieldView, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 获取WHC_KeyboardManager发来的通知 -
    @objc private func getCurrentFieldView(notify: Notification) {
        currentFieldView = notify.object as? UIView
    }
    
    @objc private func getFrontFieldView(notify: Notification) {
        frontFieldView = notify.object as? UIView
        frontButton.isSelected = frontFieldView == nil
    }
    
    @objc private func getNextFieldView(notify: Notification) {
        nextFieldView = notify.object as? UIView
        nextButton.isSelected = nextFieldView == nil
    }
    
    //MARK: - ACTION -
    @objc private func clickFront(button: UIButton) {
        if WHC_KeyboardManager.share.moveDidAnimation {
            if frontFieldView != nil {
                if frontFieldView is UITextField {
                    (frontFieldView as? UITextField)?.becomeFirstResponder()
                }else if frontFieldView is UITextView {
                    (frontFieldView as? UITextView)?.becomeFirstResponder()
                }
            }
            clickFrontButtonBlock?()
        }
    }
    
    @objc private func clickNext(button: UIButton) {
        if WHC_KeyboardManager.share.moveDidAnimation {
            if nextFieldView != nil {
                if nextFieldView is UITextField {
                    (nextFieldView as? UITextField)?.becomeFirstResponder()
                }else if nextFieldView is UITextView {
                    (nextFieldView as? UITextView)?.becomeFirstResponder()
                }
            }
            clickNextButtonBlock?()
        }
    }
    
    @objc private func clickDone(button: UIButton) {
        if currentFieldView != nil {
            if currentFieldView is UITextField {
                currentFieldView?.resignFirstResponder()
            }else if currentFieldView is UITextView {
                currentFieldView?.resignFirstResponder()
            }
        }
        clickDoneButtonBlock?()
    }

}
