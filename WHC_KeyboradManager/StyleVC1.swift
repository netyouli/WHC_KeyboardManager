//
//  ViewController.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 16/11/14.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

class StyleVC1: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    private let kCellName = "WHCCell"
    private lazy var keyborad = WHC_KeyboradManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Tableview"
        self.view.backgroundColor = UIColor.white
        /// 设置键盘头视图
        keyborad.whc_SetHeader(view: WHC_KeyboradHeaderView())
        /// 设置偏移视图
        keyborad.whc_SetOffsetView {[unowned self] (field) -> UIView? in
            return self.tableView
        }
        /// 当挡住的时候设置偏移距离
        keyborad.whc_SetOffset { (field) -> CGFloat in
            return 40
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kCellName)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kCellName)
            let field = UITextField()
            cell?.contentView.addSubview(field)
            field.tag = 100
            field.whc_Left(16)
                .whc_Top(0)
                .whc_Right(0)
                .whc_Bottom(0)
            /// 添加监视视图
            keyborad.whc_AutoMonitor(view: cell!)
        }
        (cell?.contentView.viewWithTag(100) as? UITextField)?.placeholder = "请输入内容\(indexPath.row)"
        return cell!
    }

}

