//
//  MVPView.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

@objc protocol MVPViewDelegate: class {
   @objc optional func mvpView(_ mvpView: MVPView, didClickText text: String)
}

class MVPView: UIView {
    
    weak var delegate: MVPViewDelegate?
    
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
    
    fileprivate lazy var textLb: UILabel = {
        let nameLb = UILabel(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        nameLb.textColor = .black
        nameLb.textAlignment = .center
        nameLb.text = "请点击"
        nameLb.font = UIFont.systemFont(ofSize: 20)
        nameLb.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickText))
        nameLb.addGestureRecognizer(tap)
        return nameLb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLb)
        addSubview(textLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MVPView {
    
    @objc fileprivate func clickName() {
        clickNameClosure?()
    }
    
    @objc fileprivate func clickText() {
        delegate?.mvpView?(self, didClickText: "simon")
    }
    
    func setName(_ name: String?) {
        nameLb.text = name
    }

}
