//
//  MVVMViewModel.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class MVVMViewModel: NSObject {

    dynamic var name = ""
    
    var mvvmModel: MVVMModel? {
        didSet {
            name = mvvmModel?.name ?? ""
        }
    }
}

extension MVVMViewModel {
    
    func clickName() {
        let index = arc4random() % 9
        
        let mvvmModel = MVVMModel()
        mvvmModel.name = "simon" + "\(index)"
        self.mvvmModel = mvvmModel
    }
}
