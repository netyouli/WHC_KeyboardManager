//
//  WHC_KeyboradHeaderView.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 16/11/16.
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

class WHC_KeyboradHeaderView: UIView {

    private var currentFieldView: UIView?
    private var nextFieldView: UIView?
    private var frontFieldView: UIView?
    private let kMargin: CGFloat = 0
    private let kWidth: CGFloat = 60
    
    /// 点击前一个按钮回调
    var clickFrontButtonBlock: (() -> Void)!
    /// 点击下一个按钮回调
    var clickNextButtonBlock: (() -> Void)!
    /// 点击完成按钮回调
    var clickDoneButtonBlock: (() -> Void)!
    
    lazy var nextButton = UIButton()
    lazy var frontButton = UIButton()
    lazy var doneButton = UIButton()
    
    /// 隐藏上一个下一个按钮只保留done按钮
    var hideNextAndFrontButton = false {
        didSet {
            frontButton.isHidden = hideNextAndFrontButton
            nextButton.isHidden = hideNextAndFrontButton
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(nextButton)
        self.addSubview(frontButton)
        self.addSubview(doneButton)
        
        frontButton.setTitle("←", for: .normal)
        nextButton.setTitle("→", for: .normal)
        doneButton.setTitle("完成", for: .normal)
        
        frontButton.setTitleColor(UIColor.black, for: .normal)
        nextButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        
        frontButton.addTarget(self, action: #selector(clickFront(button:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(clickNext(button:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(clickDone(button:)), for: .touchUpInside)
        
        frontButton.whc_Left(kMargin)
                   .whc_Top(0)
                   .whc_Bottom(0)
                   .whc_Width(kWidth)
        
        nextButton.whc_Left(kMargin, toView: frontButton)
                  .whc_Top(0)
                  .whc_Bottom(0)
                  .whc_Width(kWidth)
        
        doneButton.whc_Trailing(kMargin)
                  .whc_Top(0)
                  .whc_Bottom(0)
                  .whc_Width(kWidth)
        
        self.whc_AddTopLine(0.5, color: UIColor.init(white: 0.8, alpha: 1.0))
        
        /// 监听WHC_KeyboradManager通知
        NotificationCenter.default.addObserver(self, selector: #selector(getCurrentFieldView(notify:)), name: NSNotification.Name.CurrentFieldView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getFrontFieldView(notify:)), name: NSNotification.Name.FrontFieldView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getNextFieldView(notify:)), name: NSNotification.Name.NextFieldView, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 获取WHC_KeyboradManager发来的通知 -
    @objc private func getCurrentFieldView(notify: Notification) {
        currentFieldView = notify.object as? UIView
    }
    
    @objc private func getFrontFieldView(notify: Notification) {
        frontFieldView = notify.object as? UIView
    }
    
    @objc private func getNextFieldView(notify: Notification) {
        nextFieldView = notify.object as? UIView
    }
    
    //MARK: - ACTION -
    @objc private func clickFront(button: UIButton) {
        if frontFieldView != nil {
            if frontFieldView is UITextField {
                (frontFieldView as? UITextField)?.becomeFirstResponder()
            }else if frontFieldView is UITextView {
                (frontFieldView as? UITextView)?.becomeFirstResponder()
            }
        }
        clickFrontButtonBlock?()
    }
    
    @objc private func clickNext(button: UIButton) {
        if nextFieldView != nil {
            if nextFieldView is UITextField {
                (nextFieldView as? UITextField)?.becomeFirstResponder()
            }else if nextFieldView is UITextView {
                (nextFieldView as? UITextView)?.becomeFirstResponder()
            }
        }
        clickNextButtonBlock?()
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
