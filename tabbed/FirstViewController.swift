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


class FirstViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
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
        cell.recentImage.image = UIImage(named: "img2")
        let user = recentBhajanArray[(recentBhajanArray.count - 1) - indexPath.row]
        cell.recentLabel.text = user.bhajanName
 
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
    

}


