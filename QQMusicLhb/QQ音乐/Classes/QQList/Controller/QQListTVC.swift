//
//  QQListTVC.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQListTVC: UITableViewController {

    /// 数据源, tablview负责显示的内容
    var musicMs: [QQMusicModel] = [QQMusicModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    /// 业务逻辑方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInit()
        
        
        // 1. 加载数据
        musicMs = QQDataTool.getMusicListData()
        // 给工具类, 赋值播放的音乐列表数据
        QQMusicOperationTool.shareInstance.musicMList = musicMs
    
    }

 
}


extension QQListTVC {
    
    /**
     初始化方法: 把其他所有的初始化方法, 都是写到这个方法里面, 有外界统一调用
     */
    func setUpInit()
    {
        navigationController?.navigationBarHidden = true
        setTableView()
    }
    
    
    /**
     修改状态栏为白色
     */
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    /**
     设置表格的操作
     */
    func setTableView() {
       
        tableView.rowHeight = 60
        let image = UIImage(named: "QQListBack.jpg")
        let imageView = UIImageView(image: image)
        tableView.backgroundView = imageView
        
        tableView.separatorStyle = .None
    }
    
    
    
    
}


/// 数据显示
extension QQListTVC {
    

    
    // 显示多少行
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musicMs.count
    }
    
    // 每行显示cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = QQMusicListCell.cellWithTableView(tableView)
        
        // 取出数据模型, 赋值
        cell.musicM = musicMs[indexPath.row]
        
        // 可以在ci
        cell.animation(AnimationType.Scale)

        
        

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = musicMs[indexPath.row]
        print("播放音乐--" + model.name!)
        
        QQMusicOperationTool.shareInstance.playMusic(model)
        
        self.performSegueWithIdentifier("listToDetail", sender: nil)
        
        
    }
    
    

}


