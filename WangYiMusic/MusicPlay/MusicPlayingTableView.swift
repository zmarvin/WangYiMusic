//
//  MusicPlayTableView.swift
//  EnjoyMusic
//
//  Created by zz on 2017/10/30.
//  Copyright © 2017年 Mac. All rights reserved.
//

import Foundation

class MusicPlayingTableView: UIView ,UITableViewDelegate ,UITableViewDataSource{

    var cellModels:[Music]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    let contentView  = UIView()
    let tableView = UITableView()
    
    static let shared = MusicPlayingTableView(frame: CGRect(x: 0, y: WY_SCREEN_HEIGHT, width: WY_SCREEN_WIDTH, height: 300.0))
    var selectItemCallBack : ((Music) -> Void)?

    let animateDuration = 0.3
    let identifier = NSStringFromClass(MusicPlayingTableView.self)
    let barHeight : CGFloat = 45.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        gesture.delegate = self
        self.addGestureRecognizer(gesture)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(contentView)
        let barView = UIView()
        let bottomBtn = UIButton()
        contentView.addSubview(barView)
        barView.backgroundColor = UIColor.random
        
        contentView.addSubview(bottomBtn)
        bottomBtn.backgroundColor = UIColor.random
        bottomBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        bottomBtn.setTitle("关闭", for: .normal)
        
        contentView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.random
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.left.right.bottom.equalToSuperview()
        }
        
        barView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(barHeight)
        }
        bottomBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(barHeight)
            make.bottom.equalToSuperview().offset(-WY_SAFE_BOTTOM_MARGIN)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(barView.snp.bottom)
            make.bottom.equalTo(bottomBtn.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let musics = cellModels {
            cell.textLabel?.text = musics[indexPath.row].name
        }else{
            cell.textLabel?.text = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let music  = self.cellModels?[indexPath.row] else { return }
        selectItemCallBack?(music)
    }
    
    func show() {
        let keyWindow = UIApplication.shared.keyWindow!
        keyWindow.addSubview(self)
        
        UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseIn, animations: {
            var tempRect = keyWindow.frame
            tempRect.origin.y = 0
            self.frame = tempRect
        })
    }
    
    @objc func hide() {

        UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
            var tempRect = self.frame
            tempRect.origin.y = WY_SCREEN_HEIGHT
            self.frame = tempRect
        }) { (finished) in
            self.removeFromSuperview()
        }
    }

}

extension MusicPlayingTableView : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        return !self.contentView.frame.contains(touchPoint)
    }
    
}
