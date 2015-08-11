//
//  CircleViewLayoutController.swift
//  stickchat
//
//  Created by Dmitry Gutsulyak on 3/5/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import UIKit
import ConcentricGridView

class CBaseCollectionViewLayout : UICollectionViewLayout {
    var concentricGridView: ConcentricGridView!
    var cellCount: Int!
    var center: CGPoint!
    var gridSize: CGSize!
    lazy private var insertIndexPaths = [NSIndexPath]()
    
    override func prepareLayout() {
        super.prepareLayout()
        
        if let _collectionView = collectionView {
            gridSize = _collectionView.frame.size
            center = _collectionView.center
            cellCount = _collectionView.numberOfItemsInSection(0)
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return gridSize
    }
    
    private func getPoint(indexPath: NSIndexPath) -> CGPoint {
        return concentricGridView.getPointAt(indexPath.item)!
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.center = getPoint(indexPath)
        attributes.size = CGSizeMake(50, 50)
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesList = [UICollectionViewLayoutAttributes]()
        
        if cellCount > 0 {
            for index in 0...cellCount - 1 {
                let indexPath: NSIndexPath = NSIndexPath(forItem: index, inSection: 0)
                
                if let attributeForIndexPath = layoutAttributesForItemAtIndexPath(indexPath)
                    where (CGRectContainsRect(rect, attributeForIndexPath.frame)) {
                        attributesList.append(attributeForIndexPath)
                }
            }
        }
        
        return attributesList
    }
    
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        for updateItem in updateItems {
            if (updateItem.updateAction == UICollectionUpdateAction.Insert) {
                insertIndexPaths.append(updateItem.indexPathAfterUpdate)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertIndexPaths = []
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes? = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if (insertIndexPaths.contains(itemIndexPath)) {
            if (attributes == nil) {
                attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            
            attributes?.alpha = 0
            attributes?.zIndex = 10
            attributes?.center = CGPointMake(center.x, center.y)
            attributes?.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0)
        }
        
        return attributes
    }
}
