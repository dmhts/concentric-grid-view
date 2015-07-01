//
//  CUPolygonCollectionViewCell.swift
//  CULayout
//
//  Created by Dmitry Gutsulyak on 5/31/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import UIKit

class CPolygonCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func layoutSubviews() {
        label.sizeToFit()
    }
}
