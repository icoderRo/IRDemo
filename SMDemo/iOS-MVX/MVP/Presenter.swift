//
//  Presenter.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class Presenter: NSObject {
    var mvpModel: MVPModel?     
    var mvpView: MVPView? {
        didSet {
            mvpView?.delegate = self as MVPViewDelegate
            
            mvpView?.clickNameClosure = {[weak self] in
                self?.setName()
            }
        }
    }
}

extension Presenter: MVPViewDelegate {
    func setName() {
        let index = arc4random() % 9
        
        mvpModel?.name = "simon" + "\(index)"
        
        mvpView?.setName(mvpModel?.name)
    }
    
    func mvpView(_ mvpView: MVPView, didClickText text: String) {
        mvpModel?.name = text
        self.mvpView?.setName(text)
    }
}
