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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*******只需要在要处理键盘的界面创建WHC_KeyboardManager对象即可无需任何其他设置*******/
        WHC_KeyboardManager.share.addMonitorViewController(self)
        
        self.navigationItem.title = "Tableview"
        self.view.backgroundColor = UIColor.white
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
        return indexPath.row % 2 == 0 ? 40 : 60
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
        }
        (cell?.contentView.viewWithTag(100) as? UITextField)?.placeholder = "请输入内容\(indexPath.row)"
        return cell!
    }

}

