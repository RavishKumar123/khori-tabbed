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

class Player: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var isPlaying = false
    var recentBhajanArray = [Recent]()
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var c: UIButton!
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
        c.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        c.setTitle(String.fontAwesomeIcon(name: .close), for: .normal)
        play.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        play.setTitle(String.fontAwesomeIcon(name: .pause), for: .normal)
        let user = recentBhajanArray[(recentBhajanArray.count - 1) - bhajanIndex]
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
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    
    }
    
    
}

