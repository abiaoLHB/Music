//
//  QQTimeTool.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {

    class func getFormatTime(time: NSTimeInterval) -> String {
        
        let min = Int(time) / 60
        let sec = Int(time) % 60
        
        
        return String(format: "%02d:%02d", min, sec)
    }
    
    class func getTime(formatTime: String) -> NSTimeInterval {
        
        // 00:33.20
        let minSec = formatTime.componentsSeparatedByString(":")
        if minSec.count == 2 {
            let min = Double(minSec[0])
            let sec = Double(minSec[1])
            return min! * 60 + sec!
        }
        return 0
    }
    
    
}
