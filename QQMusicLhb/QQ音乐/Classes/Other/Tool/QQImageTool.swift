//
//  QQImageTool.swift
//  QQ音乐
//
//  Created by LHB on 16/4/6.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {

    
    class func getImage(sourceImage: UIImage, text: String?) -> UIImage {
        
        if text == nil || text! == "" {
            return sourceImage
        }
        
        // 1. 开启上下文
        UIGraphicsBeginImageContext(sourceImage.size)
        
        // 2. 绘制大图片
        sourceImage.drawInRect(CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height))
        
        
        // 3. 绘制文字
        
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .Center
        
        let dic: [String: AnyObject] = [
            NSFontAttributeName: UIFont.systemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSParagraphStyleAttributeName: style
        ]
        
        (text! as NSString).drawInRect(CGRectMake(0, 0, sourceImage.size.width, 28), withAttributes: dic)
        
        // 4. 获取合成图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
        
        
        
        
        
    }
    
    
}
