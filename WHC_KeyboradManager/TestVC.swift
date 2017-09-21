//
//  TestVC.swift
//  WHC_KeyboradManager
//
//  Created by WHC on 17/7/23.
//  Copyright © 2017年 WHC. All rights reserved.
//

import UIKit

class TestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func clickPush(_ sender: UIButton) {
        let vc = StyleVC3(nibName: "StyleVC3", bundle: nil)
        //vc.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        //let currentVC = self.whc_CurrentViewController()
        //currentVC?.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
