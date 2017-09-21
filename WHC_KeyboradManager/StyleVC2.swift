//
//  StyleVC2.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 16/11/17.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

class StyleVC2: UIViewController {

    deinit {
        print("StyleVC2")
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    private lazy var stackView: WHC_StackView = WHC_StackView()
    private var testModel: TestModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testModel = TestModel(self)
        // Do any additional setup after loading the view.
        self.navigationItem.title = "ScrollView无键盘头"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(clickRight(sender:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(clickLeft(sender:)))
        /// 键盘处理配置
        /*******只需要在要处理键盘的界面创建WHC_KeyboradManager对象即可无需任何其他设置*******/
        let configuration = WHC_KeyboardManager.share.addMonitorViewController(self)
        /// 不要键盘头
        configuration.enableHeader = false
        
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
        .whc_Bottom(0)/// scrollview contentSize自动
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clickLeft(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clickRight(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        let vc = TestVC(nibName: "TestVC", bundle: nil)
        vc.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        let currentVC = self.whc_CurrentViewController()
        
//        currentVC?.definesPresentationContext = true
        let nv = UINavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .overCurrentContext
        currentVC?.present(nv, animated: true, completion: nil)
//        currentVC?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}
