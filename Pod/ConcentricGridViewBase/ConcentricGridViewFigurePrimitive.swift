//
//  ConcentricGridViewFigurePrimitive.swift
//
//  Created by Dmitry Gutsulyak on 4/3/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewFigurePrimitive class is a base class for all types of figures in the grid. It is a rectangle form but multiple instances of this class might organize more complex figures - polygons. In its turn a primitive figure class consits of cells.
*/
class ConcentricGridViewFigurePrimitive {
    
    /// The frame rectangle that describes a position and a size of the figure in the grid.
    var frame: CGRect
    
    /**
    Initializes an instance of the class using a given frame.
    
    - parameter frame: A frame rectangle that describes a position and a size of the figure in the grid.
    
    - returns: An initialized instance of the class.
    */
    init(frame: CGRect) {
        self.frame = frame
    }
    
    /**
    A wrapper for the designated constructor to simplify the initialization.
    
    - parameter cell: A size of a cell. A primitive figure consists of cells.
    - parameter sizeInCells: A primitive figure size in cells.
    - parameter origin: An origin point of a primitive figure. It means a top left corner.
    
    - returns: An initialized instance of the class.
    */
    convenience init(cell: CGSize, sizeInCells: CGSize, origin: CGPoint) {
        let figureSizeInPts = CGSizeMake(
            cell.width * sizeInCells.width,
            cell.height * sizeInCells.height
        )
        
        let frame = CGRectMake(
                origin.x,
                origin.y,
                figureSizeInPts.width,
                figureSizeInPts.height
            )
        
        self.init(frame: frame)
    }
    
    /**
    Gets a size of the figure in cells. A size in pts is always known.
    
    - parameter cell: A size of a cell that is used in the splitting.
    */
    func splitIntoCellsUsing(cell cell: CGSize) -> CGSize {
        return CGSizeMake(
            frame.width / cell.width,
            frame.height / cell.height
        )
    }
}
