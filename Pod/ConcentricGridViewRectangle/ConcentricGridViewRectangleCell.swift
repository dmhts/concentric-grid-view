//
//  ConcentricGridViewRectangleCell.swift
//
//  Created by Dmitry Gutsulyak on 4/2/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewRectangleCell class that extends ConcentricGridViewCell to implement a stack of concentric rectangles.
*/
class ConcentricGridViewRectangleCell : ConcentricGridViewCell {
    
    /// The side that the cell represents.
    var side: RectSide
    
    /// The position on the side. For example: a top right corner, a mid of the top side, etc.
    var positionOnSide: RectPositionOnSide
    
    /**
    Initializes an instance of the class using given params.
    
    - parameter index: An index of the cell in the figure.
    - parameter frame: A frame that describes a position and a size of the cell.
    - parameter side: A side that the cell represents.
    - parameter positionOnSide: A position on the side.
    
    - returns: An initialized instance of the class.
    */
    init(index: Int, frame: CGRect, side: RectSide, positionOnSide: RectPositionOnSide) {
        self.side = side
        self.positionOnSide = positionOnSide
        super.init(index: index, frame: frame)
    }
}