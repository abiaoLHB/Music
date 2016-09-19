//
//  QQDetailVC.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit


/// 存放所有的属性
class QQDetailVC: UIViewController {

    /** 歌词背景视图(动画使用) */
    @IBOutlet weak var lrcBackView: UIScrollView!
    
    // 根据当切换歌曲时, 控件的更新频率, 对属性进行分类, 然后采用不同的处理方案解决
    
    // 背景图片 1
    @IBOutlet weak var backImageView: UIImageView!
    // 歌曲名称 1
    @IBOutlet weak var songNameLabel: UILabel!
    // 歌手名称 1
    @IBOutlet weak var singerNameLabel: UILabel!
    // 总时长 1
    @IBOutlet weak var totalTimeLabel: UILabel!
    /** 前景图片 1 */
    @IBOutlet weak var foreImageView: UIImageView!
    
    
    // 已经播放时长 N
    @IBOutlet weak var costTimeLabel: UILabel!
    // 按钮状态  n
    @IBOutlet weak var playOrPauseBtn: UIButton!
    /** 播放进度 n */
    @IBOutlet weak var progressSlider: UISlider!
    /** 歌词标签 n */
    @IBOutlet weak var lrcLabel: QQLrcLabel!
  
    var updateTimesTimer: NSTimer?
    
    var displayLink: CADisplayLink?
    

    lazy var lrcTVC: QQLrcTVC = {
       
        return QQLrcTVC()
        
    }()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


/// 业务逻辑
extension QQDetailVC {
    
    // 这个方法里面, 存放的都是单次操作的, 比如说添加控件, 设置控件状态
    // 注意: 不要把设置frame的方法放在这里, 因为这里获取的是xib原始的尺寸
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加了一个歌词视图
        addLrcView()
        // 设置歌词背景视图(动画使用)
        setLrcBackView()
        // 设置进度条图片
        setSlider()
        
        setUpOnce()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(nextMusic), name: kPlayerFinishNotification, object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        addDisPlayLink()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeDisPlayLink()
    }
    
    // 这里一般写设置frame的方法, 因为, 在这里, 可以获取到最终的正确尺寸
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // 调整歌词视图的frame
        setLrcFrame()
        // 设置歌词背景视图的尺寸
        setLrcBackViewFrame()
        // 设置前景图片圆形效果
        setForeImageView()
    }
    // 关闭当前控制器
    @IBAction func close() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // 上一首
    @IBAction func preMusic() {
         QQMusicOperationTool.shareInstance.preMusic()
         setUpOnce()
    }
    // 播放或者暂停
    @IBAction func playOrPause(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        if sender.selected {
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            resumeRotationAnimation()
        }else {
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            pauseRotationAnimation()
        }
        
        
    }
    // 下一首
    @IBAction func nextMusic() {
        QQMusicOperationTool.shareInstance.nextMusic()
        setUpOnce()
    }
    
    
    func addTimer() -> () {
        updateTimesTimer = NSTimer(timeInterval: 1, target: self, selector: #selector(QQDetailVC.setUpTimes), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(updateTimesTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer() -> () {
        updateTimesTimer?.invalidate()
        updateTimesTimer = nil
    }
    
    func addDisPlayLink() -> () {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLrcData))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func removeDisPlayLink() -> () {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    
    @IBAction func down(sender: UISlider) {
        removeTimer()
    }
    
    @IBAction func change(sender: UISlider) {
        // 0 - 1.0
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double(sender.value)
        costTimeLabel.text = QQTimeTool.getFormatTime(currentTime)
        
        
    }
    
    @IBAction func up(sender: UISlider) {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double(sender.value)
        
        // 让播放器, 播放给定的时间点
        QQMusicOperationTool.shareInstance.setTime(currentTime)
        
        addTimer()
    }
    
    
    
    
}

/// 数据操作(获取数据之后, 通过控件展示数据)
extension QQDetailVC {
    
    /** 当歌曲切换时, 需要更新一次的方法 */
    func setUpOnce() -> () {
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        // 背景图片 1
        if musicMessageM.musicM?.icon != nil {
             backImageView.image = UIImage(named: (musicMessageM.musicM?.icon)!)
            /** 前景图片 1 */
            foreImageView.image = UIImage(named: (musicMessageM.musicM?.icon)!)
        }
        
        // 歌曲名称 1
        songNameLabel.text = musicMessageM.musicM?.name
        // 歌手名称 1
        singerNameLabel.text = musicMessageM.musicM?.singer
        // 总时长 1
        totalTimeLabel.text = musicMessageM.totalTimeFormat
        
        // 添加播放旋转动画
        addRotationAnimation()
        if musicMessageM.isPlaying {
            resumeRotationAnimation()
        }else {
            pauseRotationAnimation()
        }
        
        
        // 更新歌词(因为当歌曲切换时, 对应歌曲的歌词内容也需要切换一次)
        
        guard let musicM = musicMessageM.musicM else {return}
        let lrcMs = QQDataTool.getLrcMData((musicM.lrcname)!)
//        print(lrcMs)
        lrcTVC.lrcMs = lrcMs
        
        // 拿到歌词数据模型,之后, 需要展示歌词, 在这里, 是交给lrcTVC控制器来展示, 没有必要放到这个控制器里面展示
        // 将白点, 这个控制器负责的就是, 拿歌词数据(具体怎么拿, 工具类) -> 展示歌词数据(具体怎么展示, 别的控制器)
        
        
        
        
    }
    
    
    /** 当歌曲切换时, 需要实时更新的方法 */
    func setUpTimes() -> () {
         let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        
        // 已经播放时长 N
        costTimeLabel.text = musicMessageM.costTimeFormat
        // 按钮状态  n
        if playOrPauseBtn.selected != musicMessageM.isPlaying
        {
            print("henduoci")
            playOrPauseBtn.selected = musicMessageM.isPlaying
            
            if musicMessageM.isPlaying {
                resumeRotationAnimation()
            }else {
                pauseRotationAnimation()
            }

        }
        
        
        /** 播放进度 n */
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        /** 歌词标签 n */
//        lrcLabel.text = nil
    }
    
    
    func updateLrcData() -> () {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()

        // 1. 拿到当前行号
        let rowLrcM = QQDataTool.getRowLrcM(lrcTVC.lrcMs, currentTime: musicMessageM.costTime)
        // 2. 滚动到对应行
        lrcTVC.scrollRow = rowLrcM.row
        
        // 3. 给歌词label, 赋值
        lrcLabel.text = rowLrcM.lrcM?.lrcContent
        
        
        // 4. 更新歌词进度
        
        if rowLrcM.lrcM != nil
        {
            
            let progressTime = CGFloat(musicMessageM.costTime - (rowLrcM.lrcM?.startTime)!)
            
            let totalTime = CGFloat((rowLrcM.lrcM?.endTime)! - (rowLrcM.lrcM?.startTime)!)
            
            lrcLabel.progress = progressTime / totalTime
            
            lrcTVC.progress = lrcLabel.progress
        }
        
       
        // 更新锁屏界面信息
//        print(UIApplication.sharedApplication().applicationState.rawValue)
        
        if UIApplication.sharedApplication().applicationState == .Background
        {
           QQMusicOperationTool.shareInstance.setUpLockMessage()
        }
        
        
        
    }
    
    
}

/// 界面操作
extension QQDetailVC {
    
    // 设置歌词背景占位视图
    func setLrcBackView() -> () {
        lrcBackView.delegate = self
        lrcBackView.pagingEnabled = true
        lrcBackView.showsHorizontalScrollIndicator = false
    }
    
    // 设置歌词背景占位的内容尺寸
    func setLrcBackViewFrame() -> () {
        lrcBackView.contentSize = CGSizeMake(lrcBackView.width * 2, 0)
    }
    
    // 添加歌词视图
    func addLrcView() -> () {
        lrcBackView.addSubview(lrcTVC.tableView)
    }
    
    // 设置歌词视图的frame
    func setLrcFrame() -> () {
        lrcTVC.tableView.frame = lrcBackView.bounds
        lrcTVC.tableView.x = lrcBackView.width
    }
    
    // 设置前景图片的圆角
    func setForeImageView() -> () {
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds = true
    }
    
    // 设置进度条的图标
    func setSlider() -> () {
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: UIControlState.Normal)
    }
    
  
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

/// 动画处理
extension QQDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
      
        let alpha = 1 - scrollView.contentOffset.x / scrollView.width
         
        foreImageView.alpha = alpha
        lrcLabel.alpha = alpha
    }
    
    func addRotationAnimation() -> () {
        foreImageView.layer.removeAnimationForKey("rotate")
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        foreImageView.layer.addAnimation(animation, forKey: "rotate")
    }
    
    
    func pauseRotationAnimation() -> () {
        foreImageView.layer.pauseAnimate()
    }
    
    func resumeRotationAnimation() -> () {
        foreImageView.layer.resumeAnimate()
    }
    
    
}


/// 远程事件
extension QQDetailVC {
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        switch (event?.subtype)! {
        case .RemoteControlPlay:
            print("播放")
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .RemoteControlPause:
            print("暂停")
             QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .RemoteControlNextTrack:
            print("下一首")
             QQMusicOperationTool.shareInstance.nextMusic()
        case .RemoteControlPreviousTrack:
            print("上一首")
             QQMusicOperationTool.shareInstance.preMusic()
        default:
            print("none")
        }
        
        setUpOnce()
    }
    
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        QQMusicOperationTool.shareInstance.nextMusic()
        setUpOnce()
    }
    
}

