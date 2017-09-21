//
//  TestView.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 17/7/21.
//  Copyright © 2017年 WHC. All rights reserved.
//

import UIKit

class TestView: UIView {

    var clickBlock: (() -> Void)!
    
    static func create() -> TestView {
        return TestView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

}
