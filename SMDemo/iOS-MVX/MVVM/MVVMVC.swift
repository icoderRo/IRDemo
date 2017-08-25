//
//  MVVMVC.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class MVVMVC: UIViewController {

    fileprivate lazy var mvvmView: MVVMView = { [unowned self] in
        let mvvmView = MVVMView(frame: self.view.bounds)
        self.view.addSubview(mvvmView)
        return mvvmView
    }()
    
    fileprivate lazy var mvvmModel: MVVMModel = {
        let mvvmModel = MVVMModel()
        mvvmModel.name = "simon Init"
        return mvvmModel
    }()
    
    fileprivate lazy var mvvmVM: MVVMViewModel = {
        let mvvmVM = MVVMViewModel()
        return mvvmVM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "MVVMVC"

        mvvmView.mvvmVM = mvvmVM
        mvvmVM.mvvmModel = mvvmModel
        
    }
}

