//
//  CUBaseCollectionViewController.swift
//  CULayout
//
//  Created by Dmitry Gutsulyak on 5/31/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import UIKit
import Foundation

class CBaseCollectionViewController: UICollectionViewController {
    lazy var cells = [NSIndexPath]()
    var timer: NSTimer!
    
    override func viewDidLoad() {
        startCellAdding()
        super.viewDidLoad()
    }
    
    func startCellAdding() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "addCell", userInfo: nil, repeats: true)
    }
    
    func startCellAddingWithDelay(delay: NSTimeInterval) {
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "startCellAdding", userInfo: nil, repeats: false)
    }
    
    func stopCellAdding(shouldRepeat: Bool = true, clearCollection: Bool = true) {
        timer.invalidate()
        
        if let _collectionView = collectionView where clearCollection {
            
            _collectionView.performBatchUpdates({
                    _collectionView.deleteItemsAtIndexPaths(self.cells)
                    self.cells.removeAll(keepCapacity: false)
                }, completion: { isCompleted in
                    if shouldRepeat {
                        self.startCellAddingWithDelay(3)
                    }
                }
            )
            
        }
    }
    
    func addCell() {
        if cells.count == 45 {
            stopCellAdding()
            return
        }
        
        if let _collectionView = collectionView {
            
            _collectionView.performBatchUpdates({
                var item = NSIndexPath(forItem: self.cells.count, inSection: 0)
                
                self.cells.append(item)
                _collectionView.insertItemsAtIndexPaths([item])
                
                }, completion: nil
            )
            
        }
    }
}

extension CBaseCollectionViewController : UICollectionViewDataSource {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("RoundCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        return cell
    }
    
}