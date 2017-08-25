//
//  MVCView.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class MVCView: UIView {
    
    var clickNameClosure: (() -> Void)?

    fileprivate lazy var nameLb: UILabel = {
        let nameLb = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        nameLb.textColor = .black
        nameLb.textAlignment = .center
        nameLb.font = UIFont.systemFont(ofSize: 20)
        nameLb.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickName))
        nameLb.addGestureRecognizer(tap)
        return nameLb
    }()
    
    var model: MVCModel? {
        didSet {
            nameLb.text = model?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MVCView {
    
    @objc fileprivate func clickName() {
        clickNameClosure?()
    }
}
