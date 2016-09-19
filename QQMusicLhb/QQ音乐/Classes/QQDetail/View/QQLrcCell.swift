//
//  QQLrcCell.swift
//  QQ音乐
//
//  Created by LHB on 16/4/6.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var progress: CGFloat = 0 {
        didSet {
            lrcLabel.progress = progress
        }
    }
    
    var lrcM: QQLrcModel? {
        didSet {
            lrcLabel.text = lrcM?.lrcContent
        }
    }
    
    
    class func cellWithTableView(tableView: UITableView) -> QQLrcCell {
        
        let ID = "LRC"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? QQLrcCell
        if cell == nil {
            
            cell = NSBundle.mainBundle().loadNibNamed("QQLrcCell", owner: nil, options: nil)!.first as? QQLrcCell
            
        }
        
        
        return cell!
        
    }
    
}
