//
//  RecentlyBhajansCollectionViewCell.swift
//  tabbed
//
//  Created by Ravish Kumar on 09/02/2018.
//  Copyright © 2018 Ravish Kumar. All rights reserved.
//

import UIKit

class RecentlyBhajansCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recentLabel: UILabel!
    
    @IBOutlet weak var recentyBhajanButton: UIButton!
    @IBAction func recentyBhajanButtonAction(_ sender: Any) {
        print((sender as AnyObject).tag)
    }
}

