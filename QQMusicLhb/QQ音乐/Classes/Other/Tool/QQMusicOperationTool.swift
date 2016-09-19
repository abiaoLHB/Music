//
//  QQMusicOperationTool.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//  这个类, 负责歌曲的调度(业务逻辑), 比如说上一首下一首, 顺序播放, 随机播放

 /// 一定要注意, 把功能实现, 和业务逻辑分开
 /// 功能实现的重用性最高, 业务逻辑不一定
 /// 如果写到一块, 不利于重用, 而且业务逻辑更加复杂冗余

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {

    // 记录上一次绘制的行号
    var lastRow = 0
    // 创建一个专辑图片
    var artwork: MPMediaItemArtwork?
    
    
    private var musicMessageM: QQMusicMessageModel = QQMusicMessageModel()
    
    func getMusicMessageM() -> QQMusicMessageModel {
        
        if musicMList == nil {
            return musicMessageM
        }
        
        // 需要在这里,保证数据模型的数据信息, 处于最新的状态
        musicMessageM.musicM = musicMList![currentIndex]
        
        if tool.player != nil {
            musicMessageM.costTime = (tool.player?.currentTime)!
            musicMessageM.totalTime = (tool.player?.duration)!
            musicMessageM.isPlaying = (tool.player?.playing)!
        }
     
        
        return musicMessageM
        
    }
    
    // 单例
    static let shareInstance = QQMusicOperationTool()
    
    var musicMList: [QQMusicModel]?
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex < 0
            {
                currentIndex = (musicMList?.count)! - 1
            }
            if currentIndex > (musicMList?.count)! - 1
            {
                currentIndex = 0
            }
        }
    }
    
    
    
    
    // 真正负责单首歌曲操作的工具类(播放, 暂停, 快进等)
    private let tool: QQMusicTool = QQMusicTool()
    
    
    func playMusic(musicM: QQMusicModel) {
        
        // 使用工具类, 根据外界传递的数据模型, 播放对应的歌曲
        tool.playMusic(musicM.filename!)
        
        // 根据外界传递的数据模型, 计算它在播放列表中的索引
        guard let musicMs = musicMList else {
            print("没有播放列表, 只能播放单首歌曲")
            return
        }
        currentIndex = musicMs.indexOf(musicM)!
        // 有东西可以优化
        
        
    }
    
    func playCurrentMusic() -> () {
        tool.playCurrentMusic()
    }
    
    
    func pauseCurrentMusic() -> () {
        tool.pauseCurrentMusic()
    }
    
    func nextMusic() -> () {
        
        // 调整索引  +1
        currentIndex += 1
        // 获取对应的数据模型
        let musicM = musicMList![currentIndex]
        // 根据数据模型播放
        playMusic(musicM)
        
        
    }
    
    func preMusic() -> () {
        // 调整索引  -1
        currentIndex -= 1
        // 获取对应的数据模型
        let musicM = musicMList![currentIndex]
        // 根据数据模型播放
        playMusic(musicM)
    }
    
    
    func  setTime(currentTime: NSTimeInterval) -> () {
        tool.setTime(currentTime)
    }
    
    
    
    func setUpLockMessage() {
        
        
        // 0. 取出需要展示的信息模型
        let musicMessageM = getMusicMessageM()
        
        // 1. 获取锁屏中心
        let infoCenter = MPNowPlayingInfoCenter.defaultCenter()
        
        // 1.1 创建显示信息的字典
        var name = ""
        var singer = ""
        if musicMessageM.musicM?.name != nil {
            name = (musicMessageM.musicM?.name)!
        }
        
        if musicMessageM.musicM?.singer != nil {
            singer = (musicMessageM.musicM?.singer)!
        }
        

        
        let imageNname = musicMessageM.musicM?.icon
        if imageNname != nil {
            let image = UIImage(named: imageNname!)
            if image != nil
            {
                
                // 1. 获取歌词, 添加歌词, 到图片上, 组成一张新的图片, 来展示
                // 1. 获取当前歌曲对应的所有歌词模型组成的shuzu
                let musicM = musicMessageM.musicM
                if musicM?.lrcname != nil
                {
                    let lrcMs = QQDataTool.getLrcMData((musicM?.lrcname)!)
                    
                    // 2. 获取当前正在播放的歌词模型
                    let rowLrcM = QQDataTool.getRowLrcM(lrcMs, currentTime: musicMessageM.costTime)
                    
                    // 3. 获取当前歌词的信息
                    if lastRow != rowLrcM.row {
                        lastRow = rowLrcM.row
                        // 4. 把文字, 绘制到图片上, 生成新的图片
                        let resultImage = QQImageTool.getImage(image!, text: rowLrcM.lrcM?.lrcContent)
                        
                        artwork = MPMediaItemArtwork(image: resultImage)
                        
                         print("绘制了图片")
                        
                    }
   
                }
                
            }
        }
        
        
        
        
        let infoDic: NSMutableDictionary = NSMutableDictionary()
        infoDic.setValue(name, forKey: MPMediaItemPropertyAlbumTitle)
        infoDic.setValue(singer, forKey: MPMediaItemPropertyArtist)
        infoDic.setValue(musicMessageM.totalTime, forKey: MPMediaItemPropertyPlaybackDuration)
        infoDic.setValue(musicMessageM.costTime, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
        
        
        if artwork != nil {
            infoDic.setValue(artwork!, forKey: MPMediaItemPropertyArtwork)
        }
        
        
        
  
//            :
     
        let infoDic2 = infoDic.copy()
        
        // 2. 设置信息
        infoCenter.nowPlayingInfo = infoDic2 as? [String: AnyObject]
        
        
        // 3. 接收远程事件
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
    }
    
    
}
