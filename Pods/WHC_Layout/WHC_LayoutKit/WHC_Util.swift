//
//  WHC_Util.swift
//  WHC_Layout
//
//  Created by WHC on 2018/1/18.
//  Copyright © 2018年 WHC. All rights reserved.
//
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
    public typealias WHC_LayoutRelation = NSLayoutConstraint.Relation
    public typealias WHC_LayoutAttribute = NSLayoutConstraint.Attribute
    public typealias WHC_CLASS_VIEW = UIView
    public typealias WHC_COLOR = UIColor
    public typealias WHC_LayoutPriority = UILayoutPriority
    public typealias WHC_ConstraintAxis = NSLayoutConstraint.Axis
    
    @available(iOS 9.0, *)
    public typealias WHC_CLASS_LGUIDE = UILayoutGuide
#else
    public typealias WHC_LayoutRelation = NSLayoutConstraint.Relation
    public typealias WHC_LayoutAttribute = NSLayoutConstraint.Attribute
    public typealias WHC_CLASS_VIEW = NSView
    public typealias WHC_COLOR = NSColor
    public typealias WHC_LayoutPriority = NSLayoutConstraint.Priority
    public typealias WHC_ConstraintAxis = NSLayoutConstraint.Orientation
    
    @available(OSX 10.11, *)
    public typealias WHC_CLASS_LGUIDE = NSLayoutGuide
#endif
