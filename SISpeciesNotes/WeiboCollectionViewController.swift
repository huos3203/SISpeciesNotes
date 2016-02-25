//
//  WeiboCollectionViewController.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/2/25.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

class WeiboCollectionViewController: UICollectionViewController,UICollectionViewDataSource
{
    private var timeLine:[String]? = []
   
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeLine?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("weibocell", forIndexPath: indexPath)
        cell.backgroundView?.backgroundColor = UIColor.yellowColor()
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController.init(title: "点击单元格", message: "提示成功", preferredStyle:UIAlertControllerStyle.Alert)
        alert.showDetailViewController(self, sender: nil)
    }
    
    
}
