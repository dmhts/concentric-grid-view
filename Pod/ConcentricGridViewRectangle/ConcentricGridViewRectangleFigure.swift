//
//  ConcentricGridViewRectangleFigure.swift
//
//  Created by Dober on 3/17/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewRectangleFigure class that extends ConcentricGridViewFigure to represent a rectagle figure as a part of a grid stack.
*/
class ConcentricGridViewRectangleFigure : ConcentricGridViewFigure {
    
    /// Whether the figure is cut horizontally from both sides (because the figure always is symmetric).
    var isCutHorizontally = false
    
    /// Whether the figure is cut vertically from both sides (because the figure always is symmetric).
    var isCutVertically = false
    
    /// Whether the figure is the last horizontally uncut.
    var isLastHorizontallyUncut = false
    
    /**
    The wrapper of the designated initializer.
    
    :param: index An index of the figure in the grid storage.
    :param: previous A previous figure in the stack.
    :param: sizeInCells A size of the figure in cells.
    :param: isCutHorizontally Whether the figure is cut horizontally.
    :param: isCutVertically Whether the figure is cut vertically.
    :param: gridView A parent grid view.
    */
    convenience init(index: Int, previous: ConcentricGridViewRectangleFigure?, sizeInCells: CGSize, isCutHorizontally: Bool, isCutVertically: Bool, gridView: ConcentricGridViewRectangle){
        self.init(index: index, previous: previous, sizeInCells: sizeInCells, gridView: gridView)
        
        self.previous = previous
        self.isCutHorizontally = isCutHorizontally
        self.isCutVertically = isCutVertically
    }
    
    /**
    Makes a shift for a cell at given index.
    
    :param: index An index of a cell to shift.
    
    :returns: Whether a cell has been shifted.
    */
    func makeShiftForCellAt(index: Int) -> Bool {
        // Shift to the right
        if let cell = getCellBy(index) {
            cell.frame = CGRectOffset(cell.frame, gridView.peripheralCell.width / 2, 0)
            
            return true
        }
        
        return false
    }
}

enum RectSide {
    case top
    case right
    case bottom
    case left
    case none
    
    static func getMidPointBySide(side: RectSide) -> RectPositionOnSide {
        var positionOnSide: RectPositionOnSide!
        
        switch side {
        case .top : return RectPositionOnSide.topMiddle
        case .right : return RectPositionOnSide.rightMiddle
        case .bottom : return RectPositionOnSide.bottomMiddle
        case .left : return RectPositionOnSide.leftMiddle
        case .none : return .none
        default: return .none
        }
    }

}

enum RectPositionOnSide {
    case topLeft
    case topMiddle
    case topRight
    case rightMiddle
    case bottomRight
    case bottomMiddle
    case bottomLeft
    case leftMiddle
    case none
}
