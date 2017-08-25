//
//  MVCVC.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class MVCVC: UIViewController {
    
    fileprivate lazy var mvcView: MVCView = { [unowned self] in
        let mvcView = MVCView(frame: self.view.bounds)
        self.view.addSubview(mvcView)
        return mvcView
    }()
    
    fileprivate lazy var mvcModel: MVCModel = {
        let mvcModel = MVCModel()
        return mvcModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "MVC"
        
        changeName()
        
        mvcView.clickNameClosure = {[weak self] in
            self?.changeName()
        }
    }
}

extension MVCVC {
    func changeName() {
        let index = arc4random() % 9
        
        let model = MVCModel()
        model.name = "simon" + "\(index)"
        mvcView.model = model
    }
}

