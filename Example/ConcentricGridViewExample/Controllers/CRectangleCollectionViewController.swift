//
//  SecondViewController.swift
//  CULayout
//
//  Created by Dmitry Gutsulyak on 5/30/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import UIKit
import Foundation

class CRectangleCollectionViewController: CBaseCollectionViewController {
    
    override func viewDidLoad() {
        collectionView?.collectionViewLayout = CRectangleCollectionViewLayout()
        super.viewDidLoad()
    }
    
}

extension CRectangleCollectionViewController : UICollectionViewDataSource {
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("RoundCell", forIndexPath: indexPath) as! CRectangleCollectionViewCell
        
        cell.label.text = "\(indexPath.item)"
        
        return cell
    }
    
}
