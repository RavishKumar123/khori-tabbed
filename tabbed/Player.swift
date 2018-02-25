//
//  Player.swift
//  tabbed
//
//  Created by Ravish Kumar on 16/02/2018.
//  Copyright © 2018 Ravish Kumar. All rights reserved.
//

import UIKit
import FontAwesome_swift
import AVFoundation
import MediaPlayer

class Player: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var miniPlayerProgress: UISlider!
    var timer: Timer?
    var timer2: Timer?
    
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var currentMinandSec: UILabel!
    var isPlaying = false
    var recentBhajanArray = [Recent]()
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var globalBhajanIndex:Int = 0
    var playing = false
    
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var c: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBAction func closeAction(_ sender: Any) {
    close()
    }
    @IBAction func playAction(_ sender: Any) {
        playPause()
    }
    func returnCount() -> Int {
        return recentBhajanArray.count
    }
    func displayPlayerXib(bhajanIndex:Int){
        
        globalBhajanIndex = bhajanIndex + 1
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateVideoPlayerSlider),
                                     userInfo: nil,
                                     repeats: true)
       
        c.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        c.setTitle(String.fontAwesomeIcon(name: .close), for: .normal)
        nextBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        nextBtn.setTitle(String.fontAwesomeIcon(name: .backward), for: .normal)
        prevBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        prevBtn.setTitle(String.fontAwesomeIcon(name: .forward), for: .normal)
        play.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        play.setTitle(String.fontAwesomeIcon(name: .pause), for: .normal)
        playFirstBhajan(firstBhajan: bhajanIndex)
        disp()
        
        
    }
    
    func disp(){
        timer2 = Timer.scheduledTimer(timeInterval: 0.1,
                                      target: self,
                                      selector: #selector(doItFast),
                                      userInfo: nil,
                                      repeats: true)
    }
    @objc func doItFast(){
        
        if(playerItem?.isPlaybackLikelyToKeepUp)!{
            
            if (playing == false){
                play.setTitle(String.fontAwesomeIcon(name: .pause), for: .normal)
                playing = true
            }
            if(isPlaying){
                play.setTitle(String.fontAwesomeIcon(name: .play), for: .normal)
                playing = true
            }
        }else{
            play.setTitle(String.fontAwesomeIcon(name: .circleO), for: .normal)
            playing = false
            
        }
        
        
     
        
    }
    func playFirstBhajan(firstBhajan : Int){
        let user = recentBhajanArray[(recentBhajanArray.count - 1) - firstBhajan]
        //playerXib?.songName.text = user.bhajanName
        songName.text = user.bhajanName
        playBhajan(bhajanUrl: user.bhajanUrl!)
    }
    func close(){
        player = nil
        self.isHidden = true
    }
    func playPause(){
        isPlaying = !isPlaying
        if(isPlaying){
            player?.pause()
            play.setTitle(String.fontAwesomeIcon(name: .play), for: .normal)
        }else {
            player?.play()
            play.setTitle(String.fontAwesomeIcon(name: .pause), for: .normal)
        }
        
    }
    func playBhajan(bhajanUrl:String){
        let url = URL(string: bhajanUrl)
        playerItem = AVPlayerItem(url: url!)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        player = AVPlayer(playerItem: playerItem)
        

        player?.play()
    
    }
    @objc func playerDidFinishPlaying(sender: Notification) {
        playFirstBhajan(firstBhajan: globalBhajanIndex)
        
    }
    
    func getCurrentTimeAsString(){
       
        print(player?.currentTime() ?? " ")
    }
    
    @objc func updateVideoPlayerSlider() {
        // 1 . Guard got compile error because `videoPlayer.currentTime()` not returning an optional. So no just remove that.
        if player != nil {
            let currentTimeInSeconds = CMTimeGetSeconds((player?.currentTime())!)
            
            
            
            // 2 Alternatively, you could able to get current time from `currentItem` - videoPlayer.currentItem.duration
            
            let mins = currentTimeInSeconds / 60
            let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
            let timeformatter = NumberFormatter()
            timeformatter.minimumIntegerDigits = 2
            timeformatter.minimumFractionDigits = 0
            timeformatter.roundingMode = .down
            guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
                return
            }
            currentMinandSec.text = "\(minsStr):\(secsStr)"
            //miniPlayerProgress.value = Float(currentTimeInSeconds) // I don't think this is correct to show current progress, however, this update will fix the compile error
            
            // 3 My suggestion is probably to show current progress properly
            if let currentItem = player?.currentItem {
                let duration = currentItem.duration
                if (CMTIME_IS_INVALID(duration)) {
                    // Do sth
                    return;
                }
                let DurationInSeconds = CMTimeGetSeconds(duration)
//                print(DurationInSeconds)
                let durMins = DurationInSeconds / 60
                let durSecs = DurationInSeconds.truncatingRemainder(dividingBy: 60)
                //miniPlayerProgress.maximumValue = Float(DurationInSeconds)
                guard let durMinsStr = timeformatter.string(from: NSNumber(value: durMins)), let durSecsStr = timeformatter.string(from: NSNumber(value: durSecs)) else {
                    return
                }
                totalDuration.text = "\(durMinsStr):\(durSecsStr)"
                let currentTime = currentItem.currentTime()
                //miniPlayerProgress.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
//                print(miniPlayerProgress.value)
            }

            
        }
        

        
        
        
    }
    
    @IBAction func changeAudioTime(_ sender: Any) {
        
        let seconds : Int64 = Int64(miniPlayerProgress.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        //print("seconds :\(seconds)  TargetTime: \(targetTime)" )
        
        player!.seek(to: targetTime)
        
       
        
    }
    

   
            
    
    
    
}

