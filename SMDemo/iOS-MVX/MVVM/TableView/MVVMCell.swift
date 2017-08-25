//
//  MVVMCell.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class MVVMCell: UITableViewCell {

    fileprivate var index: Int = 0
    
    var clickNameClosure: ((_ index: Int) -> Void)?
    
    @IBOutlet weak var nameBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func clickName(_ sender: UIButton) {
        clickNameClosure?(index)
    }
}

extension MVVMCell {
    func setName(_ name: String?, index: Int) {
        self.index = index
        nameBtn.setTitle(name, for: .normal)
    }
}

