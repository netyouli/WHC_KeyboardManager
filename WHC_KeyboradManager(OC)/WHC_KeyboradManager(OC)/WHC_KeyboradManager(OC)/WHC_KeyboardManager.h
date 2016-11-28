//
//  WHC_KeyboardManager.h
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
#import "WHC_KeyboardHeaderView.h"

/// 获取下一个编辑框视图的通知
extern const NSString * WHC_KBM_NextFieldView;
/// 获取当前编辑框视图的通知
extern const NSString * WHC_KBM_CurrentFieldView;
/// 获取上一个编辑框视图的通知
extern const NSString * WHC_KBM_FrontFieldView;


@interface WHC_KBMConfiguration : NSObject
/// 存储键盘头视图
@property (nonatomic, strong, readonly)WHC_KeyboardHeaderView * headerView;
/// 是否启用键盘头部工具条
@property (nonatomic, assign)BOOL enableHeader;

/**
 设置键盘挡住要移动视图的偏移量

 @param block 回调block
 */
- (void)setOffset:(CGFloat (^)(UIView * field))block;


/**
 设置键盘挡住的Field要移动的视图

 @param block 回调block
 */
- (void)setOffsetView:(UIView * (^)(UIView * field))block;
@end

@interface WHC_KeyboardManager : NSObject


/**
 键盘管理单利对象
 
 @return 键盘管理对象
 */
+ (instancetype)share;


/**
 添加要监听处理键盘的控制器

 @param vc 控制器

 @return 键盘处理配置对象
 */
- (WHC_KBMConfiguration *)addMonitorViewController:(UIViewController *)vc;


/**
 移除控制器监听

 @param vc 要移除监听的控制器
 */
- (void)removeMonitorViewController:(UIViewController *)vc;


/**
 移除键盘管理对象自动监听
 */
- (void)removeKeyboardObserver;

@end
