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
import AVFoundation

class FirstViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    var playerXib = Bundle.main.loadNibNamed("Player", owner: self, options: nil)?.first as? Player
    var recentBhajanArray = [Recent]()
    let localSource = [ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveRecentAddedBhajans()
        imagesliderShow()
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
                    self.playerXib?.recentBhajanArray = self.recentBhajanArray
                }
            }
            
        })
       
     }
    func imagesliderShow () {
        imageSlideShow.backgroundColor = UIColor.white
        imageSlideShow.slideshowInterval = 2.0
        imageSlideShow.pageControlPosition = PageControlPosition.insideScrollView
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.white
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.currentPageChanged = { page in
        }
        imageSlideShow.setImageInputs(localSource)
    }
    @IBAction func show(_ sender: UIButton) {
        playerXib?.close()
        playerXib = Bundle.main.loadNibNamed("Player", owner: self, options: nil)?.first as? Player
        playerXib?.frame = CGRect(x: 0, y: self.view.frame.height - 120, width: self.view.frame.width, height: 75)
        playerXib?.recentBhajanArray = recentBhajanArray
        playerXib?.displayPlayerXib(bhajanIndex: sender.tag)
        self.navigationController?.view.addSubview(playerXib!)
        
    }
    
    @IBAction func testBtn(_ sender: Any) {
        playerXib?.updateVideoPlayerSlider()
        
    }
}



