//
//  CalendarSectionView.swift
//  EnjoyMusic
//
//  Created by mac on 2020/12/23.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

protocol CalendarSectionViewDelegate : class{
    func calendar(cell: CalendarSectionCell, at indexPath: IndexPath)
    func calendar(didSelectRowAt indexPath: IndexPath)
}

class CalendarSectionView: UIView ,UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! CalendarSectionCell
        self.myDelegate?.calendar(cell: cell, at: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.myDelegate?.calendar(didSelectRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height/2
    }

    weak var myDelegate : CalendarSectionViewDelegate?
    var reuseIdentifier:String = "CalendarSectionView"
    let tableVIew : UITableView
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        self.tableVIew = UITableView(frame: .zero, style: UITableView.Style.plain)
        super.init(frame: frame)
    }
    convenience init(frame: CGRect,forCellReuseIdentifier:String) {
        self.init(frame: frame)
        self.reuseIdentifier = forCellReuseIdentifier
        self.tableVIew.register(CalendarSectionCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        self.tableVIew.tableFooterView = UIView()
        self.tableVIew.separatorStyle = .none
        self.addSubview(self.tableVIew)
        
        self.tableVIew.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }

}

