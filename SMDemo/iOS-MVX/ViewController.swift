//
//  ViewController.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "请触屏"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        navigationController?.pushViewController(MVCVC(), animated: true)
//        navigationController?.pushViewController(MVPVC(), animated: true)
//        navigationController?.pushViewController(MVVMVC(), animated: true)
        navigationController?.pushViewController(MVVMController(), animated: true)

    }

}

