//
//  WHC_KeyboardHeaderView.h
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

#import <UIKit/UIKit.h>

@interface WHC_KeyboardHeaderView : UIView
@property (nonatomic, strong, readonly)UIView * currentFieldView;
@property (nonatomic, strong, readonly)UIView * nextFieldView;
@property (nonatomic, strong, readonly)UIView * frontFieldView;
@property (nonatomic, strong, readonly)UIButton * nextButton;
@property (nonatomic, strong, readonly)UIButton * frontButton;
@property (nonatomic, strong, readonly)UIButton * doneButton;
@property (nonatomic, strong, readonly)UIView * lineView;

///// 点击前一个按钮回调
@property (nonatomic, copy)void (^clickFrontButtonBlock)(void);
///// 点击下一个按钮回调
@property (nonatomic, copy)void (^clickNextButtonBlock)(void);
///// 点击完成按钮回调
@property (nonatomic, copy)void (^clickDoneButtonBlock)(void);
/// 隐藏上一个下一个按钮只保留done按钮
@property (nonatomic, assign)BOOL hideNextAndFrontButton;
@end
