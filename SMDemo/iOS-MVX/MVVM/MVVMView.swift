//
//  MVVMView.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit


class MVVMView: UIView {
    
    fileprivate lazy var nameLb: UILabel = {
        let nameLb = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        nameLb.textColor = .black
        nameLb.textAlignment = .center
        nameLb.font = UIFont.systemFont(ofSize: 20)
        nameLb.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickName))
        nameLb.addGestureRecognizer(tap)
        return nameLb
    }()
    
    
    var mvvmVM: MVVMViewModel? {
        didSet {
            mvvmVM?.addObserver(self, forKeyPath: "name", options: [.new, .initial], context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "name" {
            let name = change?[.newKey] as? String
            setName(name)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        mvvmVM?.removeObserver(self, forKeyPath: "name")
    }
}

extension MVVMView {
    @objc fileprivate func clickName() {
        mvvmVM?.clickName()
    }
    
   fileprivate func setName(_ name: String?) {
        nameLb.text = name
    }
}
