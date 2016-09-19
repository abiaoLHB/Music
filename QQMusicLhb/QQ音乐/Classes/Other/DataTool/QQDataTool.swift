//
//  QQDataTool.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQDataTool: NSObject {
    
    class func getMusicListData() -> [QQMusicModel] {
        
        // 1. 获取plist
        guard let path = NSBundle.mainBundle().pathForResource("Musics.plist", ofType: nil) else { return [QQMusicModel]() }
        
        // 2. 转换模型
        guard let dicArray = NSArray(contentsOfFile: path) else {
            return [QQMusicModel]()
        }
        
        // 遍历数组
        var musicMs: [QQMusicModel] = [QQMusicModel]()
        for dic in dicArray {
            
            let musicM = QQMusicModel(dic: dic as! [String : AnyObject])
            musicMs.append(musicM)
            
        }
        
        return musicMs

    }
    
    class func getLrcMData(lrcName: String) -> [QQLrcModel] {
        
        
        // 1. 获取歌词文件的路径
        guard let path = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil) else {  return [QQLrcModel]() }
        
        // 2. 获取歌词文件的内容
        var lrcContent: String?
        do {
             lrcContent = try String(contentsOfFile: path)
        }catch {
            print(error)
            return [QQLrcModel]()
        }
        if lrcContent == nil {
            return [QQLrcModel]()
        }
        
        
        // 3. 解析歌词
//        print(lrcContent!)
        
        var lrcMs = [QQLrcModel]()
        
        let lrcStrArray = lrcContent!.componentsSeparatedByString("\n")
        for lrcStr in lrcStrArray {
//            print(lrcStr)
            
            // 1. 过滤垃圾数据
            if lrcStr.containsString("[ti:") || lrcStr.containsString("[ar:") || lrcStr.containsString("[al:")
            {
                continue
            }
            
            
            // 2. 拿到正确的数据, 开始解析
            // 删除没必要的数据
            let resultStr = lrcStr.stringByReplacingOccurrencesOfString("[", withString: "")
            
            let timeAndLrc = resultStr.componentsSeparatedByString("]")
            
            if timeAndLrc.count == 2 {
                let timeFormat = timeAndLrc[0]
                let lrc = timeAndLrc[1]
//                print(time, lrc)
                let lrcM = QQLrcModel()
                lrcM.startTime = QQTimeTool.getTime(timeFormat)
                lrcM.lrcContent = lrc
                lrcMs.append(lrcM)
            }
            
            
        }
        
        for i in 0..<lrcMs.count
        {
            if i == lrcMs.count - 1 {
                break
            }
            
            lrcMs[i].endTime = lrcMs[i + 1].startTime
            
        }
        
        
        
        return lrcMs
    }
    
    
    class func getRowLrcM(lrcMs: [QQLrcModel], currentTime: NSTimeInterval) -> (row: Int, lrcM: QQLrcModel?) {
        
        for i in 0..<lrcMs.count {
            if currentTime > lrcMs[i].startTime && currentTime < lrcMs[i].endTime {
                return (i, lrcMs[i])
            }
        }
        
        return (0, nil)
        
    }
    
    
    
    
}
