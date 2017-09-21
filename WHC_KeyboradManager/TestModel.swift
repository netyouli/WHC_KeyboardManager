//
//  TestModel.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 17/7/21.
//  Copyright © 2017年 WHC. All rights reserved.
//

import UIKit

class TestModel {
    private weak var vc: StyleVC2!
    private(set) lazy var view = TestView.create()

    /// 开始日期结束日期
    private(set) var begin: Date!
    private(set) var end: Date!
    
    deinit {
        print("TestModel")
    }
    
    init(_ vc: StyleVC2) {
        vc.view.addSubview(view)
        self.vc = vc
        
        view.clickBlock = {[unowned self] in
            print("\(self.vc.view.frame)")
        }
    }

}
