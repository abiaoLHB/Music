//
//  QQMusicTool.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
 /// 负责单手歌曲的播放

import UIKit
import AVFoundation


let kPlayerFinishNotification = "playFinish"

class QQMusicTool: NSObject {

    override init() {
        super.init()
        
        // 不要忘记勾选后台模式
        
        // 1. 获取音频会话
        let session = AVAudioSession.sharedInstance()
        
        // 2. 设置会话类别
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
             // 3. 激活会话
            try session.setActive(true)
        }catch {
            return
        }
     
        
    }
    
    var player: AVAudioPlayer?
    
    func playMusic(musicName: String) {
        
        // 1. 获取需要播放的音乐文件路径
        guard let url = NSBundle.mainBundle().URLForResource(musicName, withExtension: nil) else {return}
        
        if player?.url == url {
            player?.play()
            return
        }
        
        
        // 2. 根据路径创建一个播放器
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            player?.delegate = self
        }catch
        {
            print(error)
            return
        }
        
        // 3. 准备播放
        player?.prepareToPlay()
        // 4. 开始播放
        player?.play()
        
        
    }
    
    func pauseCurrentMusic() -> () {
        player?.pause()
    }
    
    
    func playCurrentMusic() -> () {
        player?.play()
    }
    
    func stopCurrentMusic() -> () {
        player?.currentTime = 0
        player?.stop()
    }
    
    
    func  setTime(currentTime: NSTimeInterval) -> () {
        player?.currentTime = currentTime
    }
    
    
    
}


extension QQMusicTool: AVAudioPlayerDelegate {
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        print("播放完成后")
        NSNotificationCenter.defaultCenter().postNotificationName(kPlayerFinishNotification, object: nil)
        
        
    }
    
}

