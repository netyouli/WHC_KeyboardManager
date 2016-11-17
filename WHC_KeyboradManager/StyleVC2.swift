//
//  StyleVC2.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 16/11/17.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

class StyleVC2: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    private lazy var keyborad = WHC_KeyboradManager()
    private lazy var stackView: WHC_StackView = WHC_StackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "ScrollView"
        self.view.backgroundColor = UIColor.white
        
        /********************* 构建UI ***********************/
        /// 设置垂直布局
        stackView.whc_Orientation = .vertical
        /// 设置分割线高度
        stackView.whc_SegmentLineSize = 0.5
        /// 设置子视图高度
        stackView.whc_SubViewHeight = 40
        /// 设置子视图内边距
        stackView.whc_Edge = UIEdgeInsetsMake(0, 16, 0, 16)
        
        scrollView.addSubview(stackView)
        stackView.whc_Left(0)
        .whc_Top(0)
        .whc_Right(0, toView: self.view)
        .whc_HeightAuto()
        .whc_Bottom(0, keepHeightConstraint: true)
        
        for i in 0 ..< 30 {
            if i < 15 {
                let text = UITextView()
                text.text = "UITextView = \(i)"
                text.font = UIFont.systemFont(ofSize: 14)
                stackView.addSubview(text)
            }else {
                let text = UITextField()
                text.placeholder = "UITextField \(i)"
                stackView.addSubview(text)
            }
        }
        stackView.whc_StartLayout()
        
        
        /******************** 设置键盘处理器 *******************/
        
        let header = WHC_KeyboradHeaderView()
        header.nextButton.setTitleColor(UIColor.white, for: .normal)
        header.frontButton.setTitleColor(UIColor.white, for: .normal)
        header.doneButton.setTitleColor(UIColor.white, for: .normal)
        header.backgroundColor = UIColor.orange
        
        header.clickDoneButtonBlock = {
            print("点击完成")
        }
        
        header.clickFrontButtonBlock = {
            print("点击前一个")
        }
        
        header.clickNextButtonBlock = {
            print("点击下一个")
        }
        
        /// 更多api请查看WHC_KeyboradManager文件
        
        /// 设置监视器视图
        keyborad.whc_AutoMonitor(view: scrollView)
        /// 设置键盘头视图
        keyborad.whc_SetHeader(view: header)
        /// 设置偏移视图
        keyborad.whc_SetOffsetView {[unowned self] (field) -> UIView? in
            return self.scrollView
        }
        /// 当挡住的时候设置偏移距离
        keyborad.whc_SetOffset { (field) -> CGFloat in
            return 40
        }
        
        
        keyborad.whc_SetKeyboradWillHide { (notification) in
            print("监听键盘将要隐藏")
        }
        
        keyborad.whc_SetKeyboradWillShow { (notification) in
            print("监听键盘将要显示")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
