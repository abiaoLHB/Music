//
//  QQMusicListCell.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

enum AnimationType: Int {
    case Rotate
    case Scale
}


class QQMusicListCell: UITableViewCell {
 
    
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var iconIMV: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!

    /// 需要外界赋值的数据模型
    var musicM: QQMusicModel? {
        didSet {
            if musicM?.icon != nil
            {
                iconIMV.image = UIImage(named: (musicM?.icon)!)
            }
            singerNameLabel.text = musicM?.singer
            songNameLabel.text = musicM?.name
            
        }
    }
    
    
    /**
     当cell 从xib加载完成之后, 完成一些初始化方法
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        iconIMV.layer.cornerRadius = iconIMV.width * 0.5
        iconIMV.layer.masksToBounds = true
    }
    
    
    /**
     提供快捷创建cell的方法
     
     - parameter tableView: 表格
     
     - returns: cell
     */
    class func cellWithTableView(tableView: UITableView) -> QQMusicListCell {
        
        let ID = "musicList"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? QQMusicListCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQMusicListCell", owner: nil, options: nil)!.first as? QQMusicListCell
        }
        
        return cell!
        
    }
    

    
    func animation(type: AnimationType)
    {
        
        switch type {
        case .Rotate:
            self.layer.removeAnimationForKey("roatation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.x")
            animation.values = [-1/4 * M_PI, 0, 1/4 * M_PI, 0]
            animation.duration = 0.5
            animation.repeatCount = 2
            self.layer.addAnimation(animation, forKey: "roatation")

        case .Scale:
            self.layer.removeAnimationForKey("scale")
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.5
            scaleAnimation.toValue = 1
            scaleAnimation.duration = 1
            scaleAnimation.repeatCount = 1
            self.layer.addAnimation(scaleAnimation, forKey: "scale")
        }
        
        // 在这里做一些特殊动画
       
        
       
    }
    
    
    
    
    
    
}
