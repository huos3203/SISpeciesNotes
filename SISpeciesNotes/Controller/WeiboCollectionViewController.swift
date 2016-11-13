//
//  WeiboCollectionViewController.swift
//  SISpeciesNotes
//
//  Created by pengyucheng on 16/2/25.
//  Copyright © 2016年 益行人. All rights reserved.
//

import UIKit

class WeiboCollectionViewController: UICollectionViewController
{
    fileprivate var timeLine:[String]? = []
   
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeLine?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weibocell", for: indexPath)
        cell.backgroundView?.backgroundColor = UIColor.yellow
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let alert = UIAlertController.init(title: "点击单元格", message: "提示成功", preferredStyle:UIAlertControllerStyle.alert)
        alert.showDetailViewController(self, sender: nil)
    }
    
    
}
