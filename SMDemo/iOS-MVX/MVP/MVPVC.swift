//
//  MVPVC.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class MVPVC: UIViewController {
    
    fileprivate lazy var mvpView: MVPView = {[unowned self] in
        let mvpView = MVPView(frame: self.view.bounds)
        self.view.addSubview(mvpView)
        return mvpView
    }()
    
    fileprivate lazy var mvpModel: MVPModel = {
        let mvpModel = MVPModel()
        return mvpModel
    }()
    
    fileprivate lazy var presenter: Presenter = {
        let presenter = Presenter()
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Passive MVP"
        
        
        presenter.mvpView = mvpView
        presenter.mvpModel = mvpModel 
        
        presenter.setName()
    }
}
