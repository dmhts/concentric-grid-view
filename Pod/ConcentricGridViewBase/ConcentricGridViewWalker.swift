//
//  ConcentricGridViewWalker.swift
//
//  Created by Gutsulyak Dmitry on 3/17/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewWalker class implements a Walker abstraction and basic methods for moving through the grid.
The entity is used for walking around the grid starting from the central cell and memorizing passed ones. 
It might be also used for walking around any grid and not only by spirally concentric algorithm.
*/
class ConcentricGridViewWalker {
    
    /// The ongoing figure that is used for walking around.
    var figure: ConcentricGridViewFigure
    
    /// The ongoing cell of the figure on which Walker is standing.
    var cell: ConcentricGridViewCell
    
    // The central cell of the grid - usually is used only for the first step.
    var centralCell: CGRect
    
    // The peripheral cell of the grid.
    var peripheralCell: CGRect
    
    // The size of the grid in pts.
    var grid: CGSize
    
    /**
    Inits the Walker instance that is already standning on the central cell of the grid. And this cell is already stored into the ongoing figure.

    - parameter figure: A figure that Walker uses for storing passed cells.
    - parameter centralCell: A centrall cell of the grid.
    - parameter peripheralCell: A peripheral cell of the grid.
    - parameter grid: A grid instance that Walker is used for bypassing.
    
    - returns: An initialized instance of the class.
    */
    init(figure: ConcentricGridViewFigure, centralCell: CGRect, peripheralCell: CGRect, grid: CGSize) {
        self.figure = figure
        self.centralCell = centralCell
        self.peripheralCell = peripheralCell
        self.grid = grid

        // Init the central cell
        self.cell = ConcentricGridViewCell(
            index: 0,
            frame: CGRectMake(
                centralCell.origin.x,
                centralCell.origin.y,
                centralCell.width,
                centralCell.height
            )
        )

        addToFigure(self.cell)
        changeCellOn(figure.getLastCell()!)
    }
    
    /**
    Allows Walker to step onto a given cell.
    
    - parameter frame: A frame of a cell for the next step.
    - parameter memorize: Whether a cell should be memorized. The default value is `true`.
    */
    func stepToCellWith(frame: CGRect, memorize: Bool = true) {
        
        if let expectedCell = figure.getCellBy(frame) {
            changeCellOn(expectedCell)
        } else {
            // Set the default index to zero in case if this is the central cell
            var nextIndex: Int = 0
            let gridRectangle = CGRectMake(
                0, 0,
                grid.width,
                grid.height
            )
            let doesGridContainFullCell = CGRectContainsRect(gridRectangle, frame)
            
            // Get the next index always from the last cell in a rectangle or go to a previous to get one.
            if let lastCell = figure.getLastCell() {
                nextIndex = lastCell.index + 1
            } else if let previous = figure.previous {
                if let lastPreviousCell = previous.getLastCell() {
                    nextIndex = lastPreviousCell.index + 1
                }
            }
            
            let newCell = ConcentricGridViewCell(
                index: nextIndex,
                frame: frame
            )
            
            if (memorize && doesGridContainFullCell) {
                addToFigure(newCell)
                changeCellOn(figure.getLastCell()!)
            } else {
                changeCellOn(newCell)
            }
            
        }
    }
    
    /**
    Adds a given cell to the figure.
    
    - parameter newCell: A cell to add to the figure.
    */
    func addToFigure(newCell: ConcentricGridViewCell) {
        figure.addCell(newCell)
    }
    
    /**
    Changes the cell to given one.
    
    - parameter newOne: A cell to change.
    */
    func changeCellOn(newOne: ConcentricGridViewCell) {
        cell = newOne
    }
    
    /**
    Allows Walker to jump onto the opposite side.
    
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func jumpToOppositeBottomCell(memorize: Bool = true) {
         moveRelativeTo(0, -figure.frame.height + cell.frame.height, memorize)
    }
    
    /**
    Allows Walker to jump to the top left corner of the current rect.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func jumpToTopLeftCornerIn(rectangle rectangle: CGRect?, memorize: Bool = true) {
        let frame = (rectangle != nil) ? rectangle! : figure.frame
        
        moveAbsoluteTo(
            CGRectGetMinX(frame),
            CGRectGetMinY(frame),
            memorize
        )
    }
    
    /**
    Allows Walker to jump onto a top right corner of the current figure.

    - parameter rectangle: A rectangle to jump.
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func jumpToTopRightCornerIn(rectangle rectangle: CGRect?, memorize: Bool = true) {
        let frame = (rectangle != nil) ? rectangle! : figure.frame
        
        moveAbsoluteTo(
            CGRectGetMaxX(frame) - peripheralCell.width,
            CGRectGetMinY(frame),
            memorize
        )
    }
    
    /**
    Allows Walker to jump onto a bottom right corner of the current figure.

    - parameter rectangle: A rectangle to jump.
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func jumpToBottomRightCornerIn(rectangle rectangle: CGRect?, memorize: Bool = true) {
        let frame = (rectangle != nil) ? rectangle! : figure.frame
        
        moveAbsoluteTo(
            CGRectGetMaxX(frame) - peripheralCell.width,
            CGRectGetMaxY(frame) - peripheralCell.height,
            memorize
        )
    }
    
    /**
    Allows Walker to jump onto a bottom left corner of the current rect.

    - parameter rectangle: A rectangle to jump.
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func jumpToBottomLeftCornerIn(rectangle rectangle: CGRect?, memorize: Bool = true) {
        let frame = (rectangle != nil) ? rectangle! : figure.frame
        
        moveAbsoluteTo(
            CGRectGetMinX(frame),
            CGRectGetMaxY(frame) - peripheralCell.height,
            memorize
        )
    }
    
    /**
    Allows Walker to make one step in the right direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func halfStepToRight(memorize: Bool = true) {
        moveRelativeTo(peripheralCell.width / 2, 0, memorize)
    }
    
    /**
    Allows Walker to make one step in the right direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func stepToRight(memorize: Bool = true) -> Void {
        moveRelativeTo(peripheralCell.width, 0, memorize)
    }
    
    /**
    Allows Walker to make one step in the bottom direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func stepToBottom(memorize: Bool = true) {
        moveRelativeTo(0, peripheralCell.height, memorize)
    }
    
    /**
    Allows Walker to make a half-step in the bottom direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func halfStepToBottom(memorize: Bool = true) {
        moveRelativeTo(0, peripheralCell.height / 2, memorize)
    }
    
    /**
    Allows Walker to make one step in the left direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func stepToLeft(memorize: Bool = true) {
        moveRelativeTo(-peripheralCell.width, 0, memorize)
    }
    
    /**
    Allows Walker to make a half-step in the left direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func halfStepToLeft(memorize: Bool = true) {
        moveRelativeTo(-peripheralCell.width / 2, 0, memorize)
    }
    
    /**
    Allows Walker to make one step in the top direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func stepToTop(memorize: Bool = true) {
        moveRelativeTo(0, -peripheralCell.height, memorize)
    }
    
    /**
    Allows Walker to make a half-step in the top direction. This method is used for convenience as a wrapper.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func halfStepToTop(memorize: Bool = true) {
        moveRelativeTo(0, -peripheralCell.height / 2, memorize)
    }
    
    /**
    Moves Walker to a given cell relatively to the current one.
    
    - parameter dx: A delta of x-coordinate to go.
    - parameter dy: A delta of y-coordinate to go.
    - parameter memorize: Whether it should memorize a new cell.
    */
    func moveRelativeTo(dx: CGFloat, _ dy: CGFloat, _ memorize: Bool = true) {
        let frame = CGRectOffset(
            CGRectMake(
                cell.frame.origin.x,
                cell.frame.origin.y,
                peripheralCell.width,
                peripheralCell.height
            ), dx, dy
        )
        
        stepToCellWith(frame, memorize: memorize)
    }
    
    /**
    Moves Walker to a given cell relatively to a device screen.
    
    - parameter x: An x-coordinate to go
    - parameter y: An y-coordinate to go
    - parameter memorize: Whether it shoud memorize a new cell.
    */
    func moveAbsoluteTo(x: CGFloat, _ y: CGFloat, _ memorize: Bool = true) {
        let frame = CGRectMake(
            x, y,
            peripheralCell.width,
            peripheralCell.height
        )
        
        stepToCellWith(frame, memorize: memorize)
    }
}
