//
//  WHC_KeyboardHeaderView.m
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

#import "WHC_KeyboardHeaderView.h"
#import "WHC_KeyboardManager.h"

@implementation WHC_KeyboardHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView * blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            [self addSubview:blurEffectView];
            blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        }
        
        _nextButton = [UIButton new];
        _frontButton = [UIButton new];
        _doneButton = [UIButton new];
        _lineView = [UIView new];
        
        [self addSubview:_nextButton];
        [self addSubview:_frontButton];
        [self addSubview:_doneButton];
        [self addSubview:_lineView];
        
        _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
        _frontButton.translatesAutoresizingMaskIntoConstraints = NO;
        _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [_frontButton setTitle:@"←" forState: UIControlStateNormal];
        [_nextButton setTitle:@"→" forState: UIControlStateNormal];
        [_doneButton setTitle:@"完成" forState: UIControlStateNormal];

        [_frontButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_frontButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [_nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
        _frontButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];

        [_frontButton addTarget:self action:@selector(clickFront:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton addTarget:self action:@selector(clickDone:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat kMargin = 0;
        CGFloat kWidth = 60;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_frontButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:kMargin]];
        [_frontButton addConstraint:[NSLayoutConstraint constraintWithItem:_frontButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_frontButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_frontButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_frontButton attribute:NSLayoutAttributeRight multiplier:1 constant:kMargin]];
        [_nextButton addConstraint:[NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_doneButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-kMargin]];
        [_doneButton addConstraint:[NSLayoutConstraint constraintWithItem:_doneButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_doneButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_doneButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [_lineView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        /// 监听WHC_KeyboardManager通知
        NSNotificationCenter * nCenter = [NSNotificationCenter defaultCenter];
        [nCenter addObserver:self selector:@selector(getCurrentFieldView:) name:(NSString *)WHC_KBM_CurrentFieldView object:nil];
        [nCenter addObserver:self selector:@selector(getNextFieldView:) name:(NSString *)WHC_KBM_NextFieldView object:nil];
        [nCenter addObserver:self selector:@selector(getFrontFieldView:) name:(NSString *)WHC_KBM_FrontFieldView object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 获取WHC_KeyboardManager发来的通知 -
- (void)getCurrentFieldView:(NSNotification *)notify {
    _currentFieldView = notify.object;
}

- (void)getFrontFieldView:(NSNotification *)notify {
    _frontFieldView = notify.object;
    _frontButton.selected = _frontFieldView == nil;
}

- (void)getNextFieldView:(NSNotification *)notify {
    _nextFieldView = notify.object;
    _nextButton.selected = _nextFieldView == nil;
}

#pragma mark - ACTION -
- (void)clickFront:(UIButton *)button {
    if (_frontFieldView) {
        if ([_frontFieldView isKindOfClass:[UITextField class]]) {
            [((UITextField *)_frontFieldView) becomeFirstResponder];
        }else if ([_frontFieldView isKindOfClass:[UITextView class]]) {
            [((UITextView *)_frontFieldView) becomeFirstResponder];
        }
    }
    if (_clickFrontButtonBlock) {
        _clickFrontButtonBlock();
    }
}

- (void)clickNext:(UIButton *)button {
    if (_nextFieldView) {
        if ([_nextFieldView isKindOfClass:[UITextField class]]) {
            [((UITextField *)_nextFieldView) becomeFirstResponder];
        }else if ([_nextFieldView isKindOfClass:[UITextView class]]) {
            [((UITextView *)_nextFieldView) becomeFirstResponder];
        }
    }
    if (_clickNextButtonBlock) {
        _clickNextButtonBlock();
    }
}

- (void)clickDone:(UIButton *)button {
    if (_currentFieldView) {
        if ([_currentFieldView isKindOfClass:[UITextField class]]) {
            [((UITextField *)_currentFieldView) resignFirstResponder];
        }else if ([_currentFieldView isKindOfClass:[UITextView class]]) {
            [((UITextView *)_currentFieldView) resignFirstResponder];
        }
    }
    if (_clickDoneButtonBlock) {
        _clickDoneButtonBlock();
    }
}

@end
