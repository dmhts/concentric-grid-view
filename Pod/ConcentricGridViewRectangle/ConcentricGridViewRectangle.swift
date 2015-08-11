//
//  ConcentricRectangleGridViewRectangle.swift
//
//  Created by Dmitry Gutsulyak on 3/20/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewRectangle extends the ConcentricGridView class to implement a grid that consists of a stack of concetric rectangles.
If central and peripheral cells have different sizes - central cell of the grid must be normalized (see the
normalizeCentralCell method) in order to make the grid symmetrical and consistent.
*/
public class ConcentricGridViewRectangle : ConcentricGridView, ConcentricGridViewProtocol {
    
    /// Wheter the grid should be shifted. See a visualization on a github page to figure it out.
    private let isShifted: Bool
    
    /**
    Initializes an instance of the class using given params.
    
    - parameter grid: A grid size in points.
    - parameter isShifted: Whether the grid should be shifted.
    - parameter centralCell: A centrall cell size of the grid in points.
    - parameter peripheralCell: A peripheral cell size of the grid in points.
    - parameter cellMargin: A margin between peripheral cells.

    - returns: An initialized instance of the class.
    */
    public init(grid: CGSize, isShifted: Bool, centralCell: CGSize, peripheralCell: CGSize, cellMargin: CGFloat) {
        self.isShifted = isShifted
        super.init(grid: grid, centralCell: centralCell, peripheralCell: peripheralCell, cellMargin: cellMargin)
    }
    
    /**
    Validates the grid on central and peripheral cell sizes considerins the shift option.
    */
    override func validateGrid() {
        super.validateGrid()
        
        if !CGSizeEqualToSize(centralCell.size, peripheralCell.size) {
            normalizeCentralCell()
        }
        
        if !CGSizeEqualToSize(centralCell.size, peripheralCell.size) && !isShifted {
            assert(false, "A shifted grid cannot be used with the different sizes of central and peripheral cells. They must be equal")
        }
    }
    
    /**
    Creates a grid (the sum of figures) to go for an appropriate class Walker.
    */
    public override func createGrid() {
        var currentRect = ConcentricGridViewRectangleFigure(
                index: 0,
                previous: nil,
                sizeInCells: CGSizeMake(centralCellBoxInBlocks.width, centralCellBoxInBlocks.height),
                gridView: self
            )
        self.add(figure: currentRect)
        
        let walker = ConcentricGridViewRectangleWalker(
                figure: currentRect,
                centralCell: self.centralCell,
                peripheralCell: self.peripheralCell,
                grid: self.size
            )
        
        var remainingRows: CGFloat!
        var remainingColumns: CGFloat!
        var outerRectsizeInCells: CGSize!
        var isCutHorizontally = false
        var isCutVertically = false
        
        
        while(currentRect.isLast != true) {
            
            remainingRows = gridInBlocks.width - currentRect.getSizeInCells().width
            remainingColumns = gridInBlocks.height - currentRect.getSizeInCells().height
            
            isCutHorizontally = (remainingRows == 0 || remainingRows == 1) ? true : false
            isCutVertically = (remainingColumns == 0 || remainingColumns == 1) ? true : false
            
            // This flag is used by Walker to consider the last .left and .right sides
            if (isCutHorizontally && !currentRect.isCutHorizontally) {
                currentRect.isLastHorizontallyUncut = true
            }
            
            if isCutHorizontally && isCutVertically {
                currentRect.isLast = true
                break
            } else if !isCutHorizontally && isCutVertically {
                outerRectsizeInCells = CGSizeMake(currentRect.getSizeInCells().width + 2, currentRect.getSizeInCells().height)
            } else if isCutHorizontally && !isCutVertically {
                outerRectsizeInCells = CGSizeMake(currentRect.getSizeInCells().width, currentRect.getSizeInCells().height + 2)
            } else if !isCutHorizontally && !isCutVertically {
                outerRectsizeInCells = CGSizeMake(currentRect.getSizeInCells().width + 2, currentRect.getSizeInCells().height + 2)
            }
            
            currentRect = ConcentricGridViewRectangleFigure(
                index: currentRect.index + 1,
                previous: currentRect,
                sizeInCells: CGSizeMake(outerRectsizeInCells.width, outerRectsizeInCells.height),
                isCutHorizontally: isCutHorizontally,
                isCutVertically: isCutVertically,
                gridView: self
            )
            self.add(figure: currentRect)
        }
        
        for (index, figure) in figures.enumerate() {
            if (index > 0) {
                let rectangle = figure as! ConcentricGridViewRectangleFigure
                
                walker.moveToOuter(rectangle: rectangle)
                isShifted ? walker.startWalkingAroundRectConsideringShift() : walker.startWalkingAroundRect()
            }
        }
        
        if (isShifted) {
            makeShift()
        }
    }
    
    /** 
    Checks whether a cell should be shifted in odd rectangles.
    
    - parameter cell: A cell to check.
    
    - returns: Whether a cell should be shifted.
    */
    private func isCellNecessaryToShiftInOddRect(cell: ConcentricGridViewRectangleCell) -> Bool {
        let rectangleCell = cell as ConcentricGridViewRectangleCell
        
        return ConcentricGridViewUtils.isOdd(cell.index) && (rectangleCell.side == RectSide.left || rectangleCell.side == RectSide.right)
    }
    
    /**
    Checks whether a cell should be shifted in even rectangles.
    
    - parameter cell: A cell to check.
    
    - returns: Whether a cell should be shifed.
    */
    private func isCellNecessaryToShiftInEvenRect(cell: ConcentricGridViewRectangleCell) -> Bool {
        let rectangleCell = cell as ConcentricGridViewRectangleCell
        
        return ConcentricGridViewUtils.isEven(cell.index) && (rectangleCell.side == RectSide.left)
    }
    
    /**
    Makes the shift on the right using the half-size of a cell.
    */
    private func makeShift() {
        var evenRects = [ConcentricGridViewRectangleFigure]()
        var oddRects = [ConcentricGridViewRectangleFigure]()
        
        // Separate rectangles into even and odd
        oddRects = figures.filter({ ConcentricGridViewUtils.isOdd($0.index) }) as! [ConcentricGridViewRectangleFigure]
        evenRects = figures.filter({ ConcentricGridViewUtils.isEven($0.index) && ($0.index != 0) }) as! [ConcentricGridViewRectangleFigure]
        
        // Shift all top and bottom cells including corners in odd rectangles except the middle ones
        for oddRect in oddRects {
            oddRect.cells
                .filter({
                    let rectangleCell = $0 as! ConcentricGridViewRectangleCell
                    
                    return (
                        rectangleCell.side == RectSide.top ||
                        rectangleCell.side == RectSide.bottom ||
                        rectangleCell.positionOnSide != RectPositionOnSide.none ||
                        self.isCellNecessaryToShiftInOddRect(rectangleCell)
                    ) &&
                    (
                        rectangleCell.positionOnSide != RectPositionOnSide.leftMiddle &&
                        rectangleCell.positionOnSide != RectPositionOnSide.rightMiddle)
                })
                .map({ oddRect.makeShiftForCellAt($0.index) })
        }
        
        // Shift all even cells on left and right sides in even rectangles
        for evenRect in evenRects {
            evenRect.cells
                .filter({ ($0.index % 2 == 0 ) && (($0 as! ConcentricGridViewRectangleCell).side == RectSide.left) })
                .map({ evenRect.makeShiftForCellAt($0.index) })
        }
    }
    
    /**
    Normalizes the central cell. It is called only in case if the central and peripheral cells have different sizes.
    */
    func normalizeCentralCell() {
        let remainingCellsInCentralRow = gridInBlocks.width - centralCellBoxInBlocks.width
        let remainingCellsInCentralColumn = gridInBlocks.height - centralCellBoxInBlocks.height
        
        if (remainingCellsInCentralRow != 0) && (remainingCellsInCentralRow % 2 != 0) {
            centralCellBoxInBlocks.width++
        }
        
        if (remainingCellsInCentralColumn != 0) && (remainingCellsInCentralColumn % 2 != 0) {
            centralCellBoxInBlocks.height++
        }
    }
}
