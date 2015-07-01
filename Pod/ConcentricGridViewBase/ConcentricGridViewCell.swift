//
//  ConcentricGridViewCell.swift
//
//  Created by Gutsulyak Dmitry on 3/17/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewCell class is an abstract base class that incorporates common functionality of a grid cell.
*/
class ConcentricGridViewCell : Equatable {
    
    /// The index of a cell in the grid.
    let index: Int
    
    /// The frame rectangle that describes a position and a size of the cell in the grid.
    var frame: CGRect
    
    /** 
    Initializes an instance of the class using a given index and a frame.
    
    :param: index An index of a cell in the grid.
    :param: frame A frame rectangle that describes a position and a size of the cell in the grid.
    
    :returns: An initialized instance of the class.
    */
    init(index: Int, frame: CGRect) {
        self.index = index
        self.frame = frame
    }
    
    /**
    Gets a center point of the cell instead of the origin one (origin-like coordinates are used by CG classes).
    
    :returns: A center point.
    */
    func getCenterPoint() -> CGPoint {
        return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
    }
}

/**
Enables ConcentricGridViewCell instances to equal each other.
*/
func ==(lhs: ConcentricGridViewCell, rhs: ConcentricGridViewCell) -> Bool {
    return CGRectEqualToRect(lhs.frame, rhs.frame)
}
