//
//  EMDiscoverMusicController.swift
//  EnjoyMusic
//
//  Created by zz on 2017/10/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class DiscoverMusicController: UITableViewController,DiscoverMusicCellDelegate, UISearchBarDelegate, UINavigationControllerDelegate {
    let disposeBag = DisposeBag()
    var API = RxDiscoverMusicAPI()
    var overallModels : [DiscoverMusicModel]?
    var personalTailorMiddleRandomSection : Int = 0
    var newDishAlbumHeaderBtns : [UIButton] = []
    var banner : LLCycleScrollView = {
        var banner = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.zero)
        banner.autoScroll = true
        banner.infiniteLoop = true
        banner.autoScrollTimeInterval = 2.0
        banner.placeHolderImage = UIImage(named: "LLCycleScrollView.bundle/llplaceholder")
        banner.imageViewContentMode = .scaleToFill
        banner.scrollDirection = .horizontal
        banner.customPageControlStyle = .pill
        banner.customPageControlInActiveTintColor = UIColor(red: 250/255.0, green: 220/255.0, blue: 220/255.0, alpha: 0.5)
        banner.pageControlCurrentPageColor = UIColor.white
        banner.customPageControlIndicatorPadding = 8.0
        banner.pageControlPosition = .center
        return banner
    }()
    
    override init(style: UITableView.Style) {
        super.init(style: .plain)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
        self.nav_BackBarButtonColor = .custom
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavgationBar()
        self.setUpHeaderView()
        self.setUpData()
    }

    func setUpData() {
        
        self.tableView.mj_header = MJRefreshGifHeader(custom: { [unowned self] in
            API.get_superZip.subscribe(onSuccess: { overallModels in
                let sectionModels = overallModels.sorted {sectionSortedArry.firstIndex(of: $0.ID)! < sectionSortedArry.firstIndex(of: $1.ID)!}// 排序
                self.overallModels = sectionModels
                for sectionModel in sectionModels  {
                    self.tableView.register(DiscoverMusicCell.self, forCellReuseIdentifier: sectionModel.ID.rawValue)
                }
                self.tableView.reloadData()
                self.tableView.mj_header?.endRefreshing()
            }, onFailure: { error in
                self.tableView.mj_header?.endRefreshing()
            }).disposed(by: disposeBag)

            API.get_Banner().subscribe(onSuccess: { bannerModels in
                self.banner.imagePaths = bannerModels.filter{ $0.pic.count > 0 }.map{ $0.pic }
            }, onFailure: { error in
                print(error)
            }).disposed(by: disposeBag)
        }).refresh()
    }
    
    var searchController : SearchViewController = SearchViewController(searchResultsController: nil)
    func setUpNavgationBar() {
        self.definesPresentationContext = true
        let reV = ResultDisplayController()
        searchController = SearchViewController(searchResultsController: reV)
        searchController.searchResultsUpdater = reV
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "圣诞 最近很火哦"
        searchController.searchBar.tintColor = .black
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).title = "取消"
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.layer.cornerRadius = 18
            searchController.searchBar.searchTextField.layer.masksToBounds = true
        } else {
            // Fallback on earlier versions
        }
        self.navigationItem.titleView = searchController.searchBar
        switchNavBarCancelEidting()
    }
    
    func setUpHeaderView() {
        let headerBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 240))
        self.banner.lldidSelectItemAtIndex = {(index : NSInteger) -> Void in
            print("23123\(index)")
        }
        let columnBarView = setUpColumnBarView()
        headerBackgroundView.addSubview(self.banner)
        headerBackgroundView.addSubview(columnBarView)
        self.tableView.tableHeaderView = headerBackgroundView
        
        self.banner.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.6)
        }
        self.banner.customPageControl?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
        })
        columnBarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.banner.snp_bottom)
            make.bottom.equalToSuperview().offset(-0.5)
        }
        // 创建分割线
        let dividingLine = UIView()
        dividingLine.backgroundColor = UIColor(red: 249/255.0, green: 248/255.0, blue: 249/255.0, alpha: 1.0)
        headerBackgroundView.addSubview(dividingLine)
        dividingLine.snp.makeConstraints { (make) in
            make.top.equalTo(columnBarView.snp_bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func setUpColumnBarView() -> UIView{
        let columnBarView = DiscoverMusicColumnBarView { (index) in
            switch index {
                case 0:
                    print("跳转私人FM")
                case 1:
                    print("跳转推荐歌曲")
                case 2:
                    let controller = PlayListPlazaOverallController()
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                case 3:
                    print("跳转排行榜")
                case 4:break
//                    self.navigationController?.pushViewController(EMStationTableViewController(), animated: true)
                default: break
            }
        }
        return columnBarView
    }
    // TODO: navigationItemClick待实现
    @objc func navigationItemClick()  {
        
    }
    func switchNavBarEidting() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
        UIView.animate(withDuration: 0.2) {
            let sFrame = self.searchController.searchBar.frame
            self.searchController.searchBar.frame = CGRect(x: -100, y: sFrame.minY, width: sFrame.width, height: sFrame.height)
        }
        
    }
    func switchNavBarCancelEidting() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_right_voices"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(navigationItemClick))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cm4_list_icn_multi"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(navigationItemClick))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.searchController.searchBar.resignFirstResponder()
        
        // 放大镜和placeholder文字调整到居中位置
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let placeholderWidth = searchController.searchBar.placeholder?.boundingRect(with: CGSize(width: 200, height: 100), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil).width ?? 200
        let leftViewWidt : CGFloat = 20
        let searchBarWidth = searchController.searchBar.frame.width - 150.0
        let offset = UIOffset(horizontal: (searchBarWidth - placeholderWidth - leftViewWidt) / 2, vertical: 0)
        searchController.searchBar.setPositionAdjustment(offset, for: .search) // 调整到居中
        
    }
    // MARK: -- UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        switchNavBarEidting()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switchNavBarCancelEidting()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        print("searchText:\(searchText)")
    }
    // MARK: -- DiscoverMusicCellDelegate 使用collectionView的cell的代理方法
    func discoverMusicCell(numberOfItemsInSection virtualSection: Int) -> Int {
        guard let overallModel = overallModels?[virtualSection] else {return 0}
        return overallModel.data.count
    }
    func discoverMusicCell(type: DiscoverMusicSectionCellType,at virtualIndexPath: IndexPath){
        let overallModel = overallModels?[virtualIndexPath.section]
        let models = overallModel?.data
        guard let model = models?[virtualIndexPath.row] else {return}
        let url = URL(string: model.picUrl)
        switch type {
        case .recommendMusicCell(let cell):
            cell.imageView.kf.setImageAspectFillScale(with: url)
            cell.titleLabel.text = model.name
            cell.playCountLabel.text = String(model.playCount)
        case .recommendDjprogramCell(let cell):
            cell.imageView.kf.setImageAspectFillScale(with: url)
            cell.titleLabel.text = model.name
        case .new_songCell(let cell):
            cell.imageView.kf.setImageAspectFillScale(with: url)
            cell.titleLabel.text = model.name
            cell.playCountLabel.text = String(model.playCount)
        case .djprogramCollectionCell(let cell):
            cell.imageView.kf.setImageAspectFillScale(with: url)
            cell.titleLabel.text = model.name
            cell.playCountLabel.text = String(model.playCount)
        case .mvCollectionCell(let cell):
            cell.imageView.kf.setImageAspectFillScale(with: url)
            cell.titleLabel.text = model.name
            cell.playCountLabel.text = String(model.playCount)
        case .yuncunKTVCell(let cell):
            cell.imageView.kf.setImageAspectFillScale(with: url)
            cell.titleLabel.text = model.name
        case .voiceLiveCell(let cell):
            cell.imageView.kf.setImageAspectFillScale(with: url)
            cell.titleLabel.text = model.name
        default:break
        }

    }
    func discoverMusicCell(swipeLeftLoadMore AtVirtualSection: Int){
        guard let overallModel = overallModels?[AtVirtualSection] else {return}
        print("DiscoverMusicCell ---- 左滑加载:\(overallModel.ID)")
    }
    func discoverMusicCell(didSelectItemAt virtualIndexPath: IndexPath){
        guard let overallModel = overallModels?[virtualIndexPath.section] else {return}
        let ID = overallModel.data[virtualIndexPath.row].id
        switch overallModel.ID {
        case .recommendMusic:
//            EMRouter.push(EMRouter.playListDetailController(ID))
            let vc = PlayListController(musicId: ID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .recommendMV: //
            print(".recommendM")
        case .new_song:
            print(".new_song")
        case .recommendDjprogram:
            print(".recommendDjprogram")
        case .rankingList:
            print("跳转到排行榜")
        default:break
        }
        
    }
    func discoverMusicCell(heightForRowAt virtualIndexPath: IndexPath) -> CGFloat{
        let overallModel = overallModels?[virtualIndexPath.section]
        return overallModel?.ID.sectionHeight ?? 0
    }
    
    // MARK: -- rankingListType 排行榜
    func discoverMusicCell(rankingListType: DiscoverMusicSectionCellType,atInnerIndexPath: IndexPath,atOuterIndexPath: IndexPath){
        guard let overallModel = overallModels?[atOuterIndexPath.section]else { return}
        guard overallModel.ID == .rankingList else {return}
        let models = overallModel.data
        let sectionModel = models[atOuterIndexPath.row] as! EMRankingListSectionModel
        let innerCellModel : EMRankingListCellModel = sectionModel.sectionModels[atInnerIndexPath.row]
        
        guard case .rankingListCell(let cell) = rankingListType else{return}
        cell.textLabel?.text = innerCellModel.name
        cell.imageView?.kf.setImageAspectFillScale(with: URL(string: innerCellModel.coverImgUrl))
        cell.indexLabel.text = "\(atInnerIndexPath.row+1)"
    }
    func discoverMusicCell(rankingListTitleForHeaderInInnerSection section: Int,atOuterIndexPath: IndexPath) -> String?{
        guard let overallModel = overallModels?[atOuterIndexPath.section]else { return ""}
        guard overallModel.ID == .rankingList else {return ""}
        let models = overallModel.data
        let sectionModel = models[atOuterIndexPath.row] as! EMRankingListSectionModel
        return sectionModel.sectionName
    }
    func discoverMusicCell(rankingListDidSelectItemAt atInnerIndexPath: IndexPath,atOuterIndexPath: IndexPath){
        guard let overallModel = overallModels?[atOuterIndexPath.section]else { return}
        guard overallModel.ID == .rankingList else {return}
        let models = overallModel.data
        let sectionModel = models[atOuterIndexPath.row] as! EMRankingListSectionModel
        let innerCellModel = sectionModel.sectionModels[atInnerIndexPath.row]
        print("点击排行榜cell：\(innerCellModel.name)")
    }
    
    // MARK: -- personalTailor 私人定制
    func discoverMusicCell(personalTailor: DiscoverMusicSectionCellType,outSection: Int,middleRandomSection: Int,innerSection:Int,row:Int){
        guard let overallModel = overallModels?[outSection]else { return}
        guard overallModel.ID == .personalTailor else {return}
        let models = overallModel.data
        let sectionModel = models[middleRandomSection] as! EMPersonalTailorSectionModel
        let innerSectionModel = sectionModel.sectionModels[innerSection]
        let innerRowModel = innerSectionModel[row] as EMPersonalTailorModel
        guard case .personalTailorCell(let cell) = personalTailor else{return}
        cell.textLabel?.text = innerRowModel.name
        self.personalTailorMiddleRandomSection = middleRandomSection
        cell.imageView?.kf.setImageAspectFillScale(with: URL(string: innerRowModel.picUrl))
    }
    func discoverMusicCell(personalTailorDidSelectRowAt outSection: Int,middleRandomSection: Int,innerSection:Int,row:Int){
        guard let overallModel = overallModels?[outSection]else { return}
        guard overallModel.ID == .personalTailor else {return}
        let models = overallModel.data
        let sectionModel = models[middleRandomSection] as! EMPersonalTailorSectionModel
        let innerSectionModel = sectionModel.sectionModels[innerSection]
        let innerRowModel = innerSectionModel[row] as EMPersonalTailorModel
        print("点击私人定制cell：\(innerRowModel.name)")
    }
    
    // MARK: -- newDishAlbumCell 新歌|新碟|数字专辑
    func discoverMusicCell(newDishAlbumUpCell: NewDishAlbumSectionCell,outSection: Int,middleSection: Int,innerSection:Int,row:Int){
        guard let overallModel = overallModels?[outSection]else { return}
        guard overallModel.ID == .newDishAlbum else {return}
        let models = overallModel.data
        let sectionModel = models[middleSection] as! EMNewDishAlbumSectionModel
        let innerSectionModel = sectionModel.sectionModels[innerSection]
        let innerRowModel = innerSectionModel[row] as EMNewDishAlbumModel
        newDishAlbumUpCell.textLabel?.text = innerRowModel.name
        newDishAlbumUpCell.detailTextLabel?.text = innerRowModel.song.artists?.first?.name
        newDishAlbumUpCell.imageView?.kf.setImageAspectFillScale(with: URL(string: innerRowModel.picUrl))
    }
    func discoverMusicCell(newDishAlbumUpDidSelectRowAt outSection: Int,middleSection: Int,innerSection:Int,row:Int){
        guard let overallModel = overallModels?[outSection]else { return}
        guard overallModel.ID == .newDishAlbum else {return}
        let models = overallModel.data
        let sectionModel = models[middleSection] as! EMNewDishAlbumSectionModel
        let innerSectionModel = sectionModel.sectionModels[innerSection]
        let innerRowModel = innerSectionModel[row] as EMNewDishAlbumModel
        print("newDishAlbumUp:\(innerRowModel.name)")
    }
    func discoverMusicCell(newDishAlbumDownCell: NewDishAlbumSectionCell,outSection: Int,middleSection: Int,innerSection:Int,row:Int){
        guard let overallModel = overallModels?[outSection]else { return}
        guard overallModel.ID == .newDishAlbum else {return}
        let models = overallModel.data
        let sectionModel = models[middleSection] as! EMNewDishAlbumSectionModel
        let innerSectionModel = sectionModel.sectionModels[innerSection]
        let innerRowModel = innerSectionModel[row] as EMNewDishAlbumModel
        newDishAlbumDownCell.textLabel?.text = innerRowModel.name
        newDishAlbumDownCell.detailTextLabel?.text = innerRowModel.song.artists?.first?.name
        newDishAlbumDownCell.imageView?.kf.setImageAspectFillScale(with: URL(string: innerRowModel.picUrl))
        newDishAlbumDownCell.playBtn.setImage(nil, for: UIControl.State.normal)
    }
    func discoverMusicCell(newDishAlbumDownDidSelectRowAt outSection: Int,middleSection: Int,innerSection:Int,row:Int){
        guard let overallModel = overallModels?[outSection]else { return}
        guard overallModel.ID == .newDishAlbum else {return}
        let models = overallModel.data
        let sectionModel = models[middleSection] as! EMNewDishAlbumSectionModel
        let innerSectionModel = sectionModel.sectionModels[innerSection]
        let innerRowModel = innerSectionModel[row] as EMNewDishAlbumModel
        print("newDishAlbumDown:\(innerRowModel.name)")
    }
    
    // MARK: -- calendarCell 音乐日历
    func discoverMusicCell(calendarCell: CalendarSectionCell, atVirtualIndexPath: IndexPath){
        guard let overallModel = overallModels?[atVirtualIndexPath.section]else { return}
        let model = overallModel.data[atVirtualIndexPath.row]
        guard let calendarModel:EMCalendarModel  = model as? EMCalendarModel else{return}
        let url = URL(string: calendarModel.imgUrl)
        if  atVirtualIndexPath.row == 0{
            calendarCell.textLabel?.text = "今天"
        }else{
            calendarCell.textLabel?.text = "明天"
        }
        
        calendarCell.detailTextLabel?.text = calendarModel.title
        calendarCell.rightImageView.kf.setImage(with: url)
    }
    func discoverMusicCell(calendarDidSelectRowAt indexPath: IndexPath){
        guard let overallModel = overallModels?[indexPath.section]else { return}
        let model = overallModel.data[indexPath.row]
        guard let calendarModel:EMCalendarModel  = model as? EMCalendarModel else{return}
    }
    
    // MARK: -- choosyMusicMV 精选音乐视频
    lazy var choosyMusicMVInfinityIndexArr :[Int] = {
        var indexArr = [Int]()
        guard let overallModels = self.overallModels else {return indexArr}
        for overallModel in overallModels{
            if overallModel.ID == .recommendMV { //查找到 精选音乐视频
                let models = overallModel.data
                for _ in 0 ..< 100 { //
                    for j in 0 ..< models.count {
                        indexArr.append(j)
                    }
                }
                break
            }
        }
        
        return indexArr
    }()
    func discoverMusicCell_choosyMusicMV(numberOfItemsInSection virtualSection: Int) -> Int {
        let overallModel = overallModels?[virtualSection]
        guard let _ = overallModel?.data else {return 0}
        
        return self.choosyMusicMVInfinityIndexArr.count
    }
    
    func discoverMusicCell_choosyMusicMV(cell: ChoosyMusicMVSectionCell, at virtualIndexPath: IndexPath) {
        let overallModel = overallModels?[virtualIndexPath.section]
        let index = self.choosyMusicMVInfinityIndexArr[virtualIndexPath.row]//取出index
        guard let model = overallModel?.data[index] else {return}
        guard let m = model as? RecommendMV else{return}
        cell.titleLabel.text = m.name
//        cell.mvUrl = m.mvUrl
        // 由于mvUrl是在self.tableView.reloadData()之后的获取的，异步的，所以这里KVO绑定
        m.rx.observe(\.mvUrl).bind(to: cell.rx.mvUrl).disposed(by: disposeBag) //
    }
    
    func discoverMusicCell_choosyMusicMV(didSelectRowAt virtualIndexPath: IndexPath) {
        let overallModel = overallModels?[virtualIndexPath.section]
        let index = self.choosyMusicMVInfinityIndexArr[virtualIndexPath.row]//取出index
        let models = overallModel?.data
        guard let model = models?[index] else {return}
        guard let m = model as? RecommendMV else{return}
        print("跳转精品音乐视频\(m.id)")
    }
    
    // MARK: -- 主列表
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.overallModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let overallModel = overallModels?[indexPath.section] else {return UITableViewCell()}
        let cell  = tableView.dequeueReusableCell(withIdentifier: overallModel.ID.rawValue, for: indexPath) as! DiscoverMusicCell
        cell.myVirtualSection = indexPath.section
        cell.myDelegate = self
        cell.sectionType = overallModel.ID
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let overallModel = overallModels?[section] else {return UIView()}
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: overallModel.ID.sectionHeaderHeight))
        
        let titleLabel = UILabel(frame: CGRect.init(x: 10, y: 0, width: 200, height: headerView.bounds.height))
        headerView.addSubview(titleLabel)
        titleLabel.text = overallModel.ID.sectionTitle

        let headerBtn = DiscoverHeaderCustomBtn()
        headerBtn.sectionType = overallModel.ID
        headerBtn.setTitle(overallModel.ID.sectionHeaderBtnTitle, for: UIControl.State.normal)
        let headerBtnRightMargin : CGFloat = 20
        let btnX = headerView.frame.width - headerBtn.bounds.width - headerBtnRightMargin
        headerBtn.frame = CGRect(x:btnX , y: 0, width: headerBtn.bounds.width, height: headerBtn.bounds.height)
        let tempCenter = CGPoint(x: headerBtn.center.x, y: titleLabel.center.y)
        headerBtn.center = tempCenter
        headerView.addSubview(headerBtn)
        headerBtn.addTarget(self, action: #selector(headerRightBtnClick), for: UIControl.Event.touchUpInside)
        if overallModel.ID.sectionHeaderBtnTitle.count == 0 { //电台sectionHeaderBtnTitle.count = 0不设置headerBtn
            headerBtn.removeFromSuperview()
        }
        
        // 特别设置 私人定制 header
        if overallModel.ID == .personalTailor {
            titleLabel.frame = CGRect.init(x: 10, y: 20, width: 100, height: 15)
            titleLabel.textColor = UIColor.lightGray
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            
            let refreshBtn = UIButton()
            refreshBtn.addTarget(self, action: #selector(personalTailorRefreshMiddleRandomSection), for: UIControl.Event.touchUpInside)
            headerView.addSubview(refreshBtn)
            refreshBtn.tag = section
            refreshBtn.setImage(UIImage(named: "cm2_act_refresh_prs"), for: UIControl.State.normal)
            let models = overallModel.data
            let sectionModel = models[self.personalTailorMiddleRandomSection] as! EMPersonalTailorSectionModel
            refreshBtn.setTitle(sectionModel.sectionName, for: UIControl.State.normal)
            refreshBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            refreshBtn.contentHorizontalAlignment = .left
            refreshBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(titleLabel.snp_bottom)
                make.width.equalTo(200)
                make.bottom.equalToSuperview()
            }
            
            headerBtn.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-headerBtnRightMargin)
                make.width.equalTo(headerBtn.bounds.width)
                make.height.equalTo(headerBtn.bounds.height)
                make.centerY.equalTo(refreshBtn.snp_centerY)
            }
        }
        // 特别设置 新歌，新碟，数字专辑 header
        if overallModel.ID == .newDishAlbum {
            self.newDishAlbumHeaderBtns.removeAll()
            
            let btn1 = UIButton()
            btn1.addTarget(self, action: #selector(newDishAlbumRefreshMiddleSection), for: UIControl.Event.touchUpInside)
            headerView.addSubview(btn1)
            btn1.setTitle("新歌", for: UIControl.State.normal)
            btn1.tag = 0
            self.newDishAlbumHeaderBtns.append(btn1)
            
            let btn2 = UIButton()
            btn2.addTarget(self, action: #selector(newDishAlbumRefreshMiddleSection), for: UIControl.Event.touchUpInside)
            headerView.addSubview(btn2)
            btn2.setTitle("新碟", for: UIControl.State.normal)
            btn2.tag = 1
            self.newDishAlbumHeaderBtns.append(btn2)
            
            let btn3 = UIButton()
            btn3.addTarget(self, action: #selector(newDishAlbumRefreshMiddleSection), for: UIControl.Event.touchUpInside)
            headerView.addSubview(btn3)
            btn3.setTitle("数字专辑", for: UIControl.State.normal)
            btn3.tag = 2
            self.newDishAlbumHeaderBtns.append(btn3)
            
            btn1.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(60)
                make.bottom.equalToSuperview()
            }
            btn2.snp.makeConstraints { (make) in
                make.left.equalTo(btn1.snp_right)
                make.top.equalToSuperview()
                make.width.equalTo(60)
                make.bottom.equalToSuperview()
            }
            btn3.snp.makeConstraints { (make) in
                make.left.equalTo(btn2.snp_right)
                make.top.equalToSuperview()
                make.width.equalTo(100)
                make.bottom.equalToSuperview()
            }
            
            for headerBtn in self.newDishAlbumHeaderBtns{
                headerBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
                if self.newDishAlbumSelectedBtnTag == headerBtn.tag {// 如果是选中的btn
                    headerBtn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
                }
            }
        }
        
        return headerView
    }
    var newDishAlbumSelectedBtnTag : Int = 0
    @objc func newDishAlbumRefreshMiddleSection(btn:UIButton) {
        guard self.newDishAlbumHeaderBtns.count > 0 else { return}
        // 通知：回调在DiscoverMusicCell.swift
        NotificationCenter.default.post(name: Notification.Name("reloadNewDishAlbumWithSectionNum"), object: btn.tag)
        // 刷新btn 颜色状态
        for headerBtn in self.newDishAlbumHeaderBtns {
            headerBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
            if headerBtn === btn {// 如果是选中的btn
                headerBtn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
                self.newDishAlbumSelectedBtnTag = btn.tag
            }
        }
    }

    @objc func personalTailorRefreshMiddleRandomSection(btn:UIButton) {
        // 通知：回调在DiscoverMusicCell.swift
        NotificationCenter.default.post(name: Notification.Name("personalTailorMiddleRandomSection"), object: nil)
        // 刷新btn title
        if let overallModel = overallModels?[btn.tag],overallModel.ID == .personalTailor{
            let models = overallModel.data
            let sectionModel = models[self.personalTailorMiddleRandomSection] as! EMPersonalTailorSectionModel
            btn.setTitle(sectionModel.sectionName, for: UIControl.State.normal)
        }
        // 旋转动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 4
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 1
        rotationAnim.isRemovedOnCompletion = false
        btn.imageView?.layer.add(rotationAnim, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            btn.imageView?.layer.removeAllAnimations()
        }
    }
    
    // 使用footerView设置分割条
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10))
        view.backgroundColor = UIColor(red: 251/255.0, green: 249/255.0, blue: 251/255.0, alpha: 1.0)
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let overallModel = overallModels?[section] else {return 0}
        return overallModel.ID.sectionHeaderHeight
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let overallModel = overallModels?[indexPath.section]
        return overallModel?.ID.sectionHeight ?? 0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 去掉section的头脚视图浮动效果
        if scrollView === self.tableView {
          let tableview = self.tableView!

          let headerHeight: CGFloat = 90
          let footerHeight: CGFloat = 10
          let offsetY = scrollView.contentOffset.y

          if offsetY <= headerHeight && offsetY >= 0 {
            scrollView.contentInset = UIEdgeInsets(top: -offsetY, left: 0, bottom: 0, right: 0);
          } else if (offsetY >= headerHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - footerHeight) {
            tableview.contentInset = UIEdgeInsets(top: -headerHeight, left: 0, bottom: -footerHeight, right: 0);
          }else if offsetY >= tableview.contentSize.height - tableview.frame.size.height - footerHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height {
            scrollView.contentInset = UIEdgeInsets(top: -headerHeight, left: 0, bottom: 0, right: 0);
          }
        }
        
    }
    lazy var initializeChoosyMusicMVCell_OneCode: Void = {
        // 通知精品音乐视频choosyMusicMV cell状态初始化
        // 回调在DiscoverMusicMVSectionView.swift
        // 应该在ChoosyMusicMVCell布局完成后调用，暂时这么写
        NotificationCenter.default.post(name: NSNotification.Name("initializeChoosyMusicMVCell"), object: nil)
        
    }()
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let overallModels = self.overallModels {
            for overallModel in overallModels {
                if overallModel.ID == .recommendMV {
                    
                    let _ = self.initializeChoosyMusicMVCell_OneCode
                }
            }
        }
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 停止播放精品音乐视频Cell
        NotificationCenter.default.post(name: NSNotification.Name("choosyMusicIsPlayMV"), object: false)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && choosyMusicMVIsInScreen(){
            NotificationCenter.default.post(name: NSNotification.Name("choosyMusicIsPlayMV"), object: true)
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let isPlay = choosyMusicMVIsInScreen()
        // 回调在DiscoverMusicMVSectionView.swift
        NotificationCenter.default.post(name: NSNotification.Name("choosyMusicIsPlayMV"), object: isPlay)
    }
    // 判断精品音乐视频cell是否显示在屏幕上
    func choosyMusicMVIsInScreen() -> Bool {
        guard let overallModels = self.overallModels else { return false }
        var index = 0
        for (i,overallModel) in overallModels.enumerated() {
            if overallModel.ID == .recommendMV {
                index = i
            }
        }
        
        if index == 0 {
            return false
        }
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else { return false }
        for indexP in indexPaths {
            if indexP.section == index {
                return true
            }
        }
        return false
    }
    
    @objc func headerRightBtnClick(btn:DiscoverHeaderCustomBtn) {
        
        switch btn.sectionType {
        case .recommendMusic:
            let controller = PlayListPlazaOverallController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        case .recommendMV:
            print("header——recommendMV")
//                    nav(EMRouter.PlayListPlazaController)
        case .new_song:
            print("header——new_song")
        case .recommendDjprogram:
            print("header——recommendDjprogram")
        case .calendar:
            print("header——calendar")
        case .rankingList:
            print("header——rankingList")
        case .personalTailor:
            print("header——personalTailor")
        case .newDishAlbum:
            print("header——newDishAlbum")
        case .djprogramCollection:
            print("header——djprogramCollection")
        case .mvCollection:
            print("header——mvCollection")
        case .yuncunKTV:
            print("header——yuncunKTV")
        case .voiceLive:
            print("header——oiceLive:")
        }
    }
    
}

class DiscoverHeaderCustomBtn: UIButton {
    var sectionType : DiscoverMusicSectionType = .recommendMusic
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let costomFont = UIFont.systemFont(ofSize: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.gray.cgColor
        self.setTitleColor(UIColor(red: 160/255.0, green: 160/255.0, blue: 160/255.0, alpha: 1), for: UIControl.State.normal)
        self.titleLabel?.font = costomFont
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        let attrs = [NSAttributedString.Key.font : costomFont]
        guard let t = title else { return }
        let size = t.boundingRect(with: CGSize(width: 200, height: 100), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        self.bounds = CGRect(x: 0, y: 0, width: size.width+25, height: size.height+10)
    }
}
