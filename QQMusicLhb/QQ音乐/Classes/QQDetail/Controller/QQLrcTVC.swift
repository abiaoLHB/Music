//
//  QQLrcTVC.swift
//  QQ音乐
//
//  Created by LHB on 16/4/6.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQLrcTVC: UITableViewController {

    var lrcMs: [QQLrcModel] = [QQLrcModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var scrollRow: Int = -1 {
        didSet {
            if scrollRow == oldValue
            {
                return
            }
            print(scrollRow)
            
            tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows!, withRowAnimation: UITableViewRowAnimation.Fade)
            
            let indexPath = NSIndexPath(forRow: scrollRow, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            
            
          
            
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            // 修改cell ,里面歌词标签的进度
             let indexPath = NSIndexPath(forRow: scrollRow, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? QQLrcCell
            cell?.progress = progress
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置tablview背景色为空
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsetsMake(tableView.height * 0.5, 0, tableView.height * 0.5, 0)
    }
    
    
   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return lrcMs.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = QQLrcCell.cellWithTableView(tableView)

        if scrollRow == indexPath.row {
            cell.progress = progress
        }else {
            cell.progress = 0
        }
        
        // 获取歌词数据模型, 赋值
        let lrcM = lrcMs[indexPath.row]
        cell.lrcM = lrcM
        
        return cell
    }


  
}
