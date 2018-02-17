//
//  FirstViewController.swift
//  tabbed
//
//  Created by Ravish Kumar on 06/02/2018.
//  Copyright © 2018 Ravish Kumar. All rights reserved.
//

import UIKit
import ImageSlideshow
import Firebase
import FontAwesome_swift
import AVFoundation


class FirstViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    let playerRef = Player()
    var playerActive = false
    var playerXib = Bundle.main.loadNibNamed("Player", owner: self, options: nil)?.first as? Player
    //var player:AVAudioPlayer!
    var recentBhajanArray = [Recent]()
    let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var playButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveRecentAddedBhajans()
        imagesliderShow()
//        let urlstring = "http://radio.spainmedia.es/wp-content/uploads/2015/12/tailtoddle_lo4.mp3"
//        let url = NSURL(string: urlstring)
//
//
//
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url! as URL)
//            player.prepareToPlay()
//
//            player.play()
//        } catch let error as NSError {
//            //self.player = nil
//            print(error.localizedDescription)
//        } catch {
//            print("AVAudioPlayer init failed")
//        }
//
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recentBhajanArray.count
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentBhajans", for: indexPath) as! RecentlyBhajansCollectionViewCell
        let user = recentBhajanArray[(recentBhajanArray.count - 1) - indexPath.row]
        cell.recentLabel.text = user.bhajanName
        cell.recentyBhajanButton.tag = indexPath.row
        return cell
    }

    func retrieveRecentAddedBhajans(){
        let ref = Database.database().reference().child("bhajans").queryLimited(toLast: 10)
        ref.observe(DataEventType.value,with: {(snapshot) in
            
            if snapshot.childrenCount > 0 {
                self.recentBhajanArray.removeAll()
                for bhajans in snapshot.children.allObjects as! [DataSnapshot]{
                    let bhajanObject = bhajans.value as? [String:AnyObject]
                    let bhajanName = bhajanObject?["name"]
                    let bhajanUrl = bhajanObject?["url"]
                    let recentBhajansObject = Recent(bhajanName: bhajanName as! String?, bhajanUrl: bhajanUrl as! String?)
                    self.recentBhajanArray.append(recentBhajansObject)
                    print(self.recentBhajanArray.count)
                    self.collectionView.reloadData()
                }
            }
            
        })
       
     }
    func imagesliderShow () {
        // Do any additional setup after loading the view, typically from a nib.
        imageSlideShow.backgroundColor = UIColor.white
        imageSlideShow.slideshowInterval = 2.0
        imageSlideShow.pageControlPosition = PageControlPosition.insideScrollView
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.white
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.currentPageChanged = { page in
            // print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        imageSlideShow.setImageInputs(localSource)
        
        //        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        //        slideshow.addGestureRecognizer(recognizer)
    }
    func displayPlayerXib(bhajanIndex:Int){
        playerXib?.close()
        playerXib = Bundle.main.loadNibNamed("Player", owner: self, options: nil)?.first as? Player
        playerXib?.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: self.view.frame.width, height: 50)
        playerXib?.c.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        playerXib?.c.setTitle(String.fontAwesomeIcon(name: .close), for: .normal)
        playerXib?.play.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        playerXib?.play.setTitle(String.fontAwesomeIcon(name: .play), for: .normal)
            let user = recentBhajanArray[(recentBhajanArray.count - 1) - bhajanIndex]
        playerXib?.songName.text = user.bhajanName
        playBhajan(bhajanUrl: user.bhajanUrl!)
        
        self.navigationController?.view.addSubview(playerXib!)
        
    }
    @IBAction func show(_ sender: UIButton) {
        
        displayPlayerXib(bhajanIndex: sender.tag)
        
    }
    func playBhajan(bhajanUrl:String){
        player?.pause()
        let url = URL(string: bhajanUrl)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        
    }
    func Playpause(){
        player?.pause()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/khori-3a84d.appspot.com/o/bhajans%2FBeat%20Pe%20Booty.mp3?alt=media&token=1e2bb54a-46c4-4f61-9959-aa4931ee0f81")
//        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
//        player = AVPlayer(playerItem: playerItem)
//
//        let playerLayer=AVPlayerLayer(player: player!)
//        playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
//        self.view.layer.addSublayer(playerLayer)
//
//        playButton = UIButton(type: UIButtonType.system) as UIButton
//        let xPostion:CGFloat = 50
//        let yPostion:CGFloat = 100
//        let buttonWidth:CGFloat = 150
//        let buttonHeight:CGFloat = 45
//
//        playButton!.frame = CGRect(x: xPostion, y: yPostion, width: buttonWidth, height: buttonHeight)
//        playButton!.backgroundColor = UIColor.lightGray
//        playButton!.setTitle("Play", for: UIControlState.normal)
//        playButton!.tintColor = UIColor.black
//        playButton!.addTarget(self, action: #selector(FirstViewController.playButtonTapped(_:)), for: .touchUpInside)
//
//        self.view.addSubview(playButton!)
//    }
//
//    @objc func playButtonTapped(_ sender:UIButton)
//    {
//        if player?.rate == 0
//        {
//            player!.play()
//            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
//            playButton!.setTitle("Pause", for: UIControlState.normal)
//        } else {
//            player!.pause()
//            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
//            playButton!.setTitle("Play", for: UIControlState.normal)
//        }
//    }
//
    
}


