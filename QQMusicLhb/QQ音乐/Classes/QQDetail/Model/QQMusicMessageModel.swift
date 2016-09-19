//
//  QQMusicMessageModel.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {

    var musicM: QQMusicModel?
    
    var costTime: NSTimeInterval = 0
    var totalTime: NSTimeInterval  = 0
    var isPlaying: Bool = false
    
    var costTimeFormat: String {
        get {
           return QQTimeTool.getFormatTime(costTime)
        }
    }
    var totalTimeFormat: String {
        get {
           return QQTimeTool.getFormatTime(totalTime)
        }
    }
    
    
}
