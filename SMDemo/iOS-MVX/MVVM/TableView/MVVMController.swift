//
//  MVVMController.swift
//  iOS-MVX
//
//  Created by simon on 2017/3/2.
//  Copyright © 2017年 simon. All rights reserved.
//

import UIKit

class MVVMController: UIViewController {
    
    fileprivate lazy var mvvmVM: MVVMVM = {return $0}(MVVMVM())
    
    fileprivate lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .yellow
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: "MVVMCell", bundle: nil), forCellReuseIdentifier: "cellId")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVMTableView"
        
        view.addSubview(tableView)
        
        mvvmVM.loadData()
        mvvmVM.reloadData = {[weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MVVMController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mvvmVM.models.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") 
        mvvmVM.setCell(cell!, indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

