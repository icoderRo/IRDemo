//
//  MVVMVM.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit


class MVVMVM: NSObject {
    
    var reloadData:(() -> Void)?
    
    lazy var models = [MVVMModel]()
}

extension MVVMVM {
    
    func setCell(_ cell: UITableViewCell, _ index: Int) {
        
        if cell.isKind(of: MVVMCell.self) {
            let cell = cell as! MVVMCell
            
            let model = models[index]
            cell.setName(model.name, index: index)
            
            cell.clickNameClosure = {[weak self] index in
                
                let model = self?.models[index]
                model?.name = "test test.."
                self?.reloadData?()
            }
        }
    }
}

extension MVVMVM {
    func loadData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            for i in 0..<20 {
                
                let model = MVVMModel()
                model.name = "simon" + "\(i)"
                
                self.models.append(model)
            }
            
            self.reloadData?()
        }
        
    }
}
