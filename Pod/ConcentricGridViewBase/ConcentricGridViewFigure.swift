//
//  ConcentricGridViewFigure.swift
//
//  Created by Dmitry Gutsulyak on 3/17/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewFigure class is an abstract base class for all figures. Figure can be for example a rectangle or
a polygon. The sum of all figures organizes the grid. Certainly a figure can override and extend a base class implementation.
*/
class ConcentricGridViewFigure : ConcentricGridViewFigurePrimitive {
    
    /// The index of the figure in the grid.
    let index: Int
    
    /// The parent grid view.
    var gridView: ConcentricGridView
    
    /// The number of the figure's cells.
    var cellsCount: Int {
        get {
            return cells.count
        }
    }
    
    /// Whether the figure is last in the grid.
    var isLast = false
    
    /// Whether the figure is odd in the grid.
    var isOdd: Bool {
        get {
            return ConcentricGridViewUtils.isOdd(index)
        }
    }
    
    /// Whether the figure is even in the grid.
    var isEven: Bool {
        return !isOdd
    }
    
    /// Whether the figure has a previous one.
    var previous: ConcentricGridViewFigure?
    
    /// The cell storage.
    lazy var cells = [ConcentricGridViewCell]()
    
    /**
    Initializes an instance of the class using a given index, frame and a parent grid.
    
    - parameter index: An index of the figure in the grid.
    - parameter frame: A frame that describes a position and a size of the figure.
    - parameter gridView: A parent grid.
    
    - returns: An initialized instance of the class.
    */
    init(index: Int, frame: CGRect, gridView: ConcentricGridView) {
        self.index = index
        self.gridView = gridView
        
        super.init(frame: frame)
    }
    
    /**
    A wrapper for the designated constructor to simplify the initialization.
    
    - parameter index: An index of the figure in the grid.
    - parameter previous:  Whether a the figure has a previous one.
    - parameter sizeInCells: A size of the figure in cells.
    - parameter gridView: A parent grid.
    
    - returns: An initialized instance of the class.
    */
    convenience init(index: Int, previous: ConcentricGridViewFigure?, sizeInCells: CGSize, gridView: ConcentricGridView) {
        let rectangleSizeInPts = CGSizeMake(
            sizeInCells.width * gridView.peripheralCellBox.width,
            sizeInCells.height * gridView.peripheralCellBox.height
        )
        let frame = CGRectMake(
            // Set coordinates for an outer rectangle
            gridView.centralCellOrigin.x - CGFloat(index) * gridView.peripheralCell.width,
            gridView.centralCellOrigin.y - CGFloat(index) * gridView.peripheralCell.height,
            rectangleSizeInPts.width,
            rectangleSizeInPts.height
        )
        
        self.init(index: index, frame: frame, gridView: gridView)
        self.previous = previous
    }
    
    /**
    Checks whether a given cell is inside the figure.
    
    - parameter cell: A cell to check.
    
    - returns: Whether a given cell is inside the figure.
    */
    func doesCellAlreadyInside(cell: ConcentricGridViewCell) -> Bool {
        if cells.count > 0 {
            for index in 0...cells.count - 1 {
                if cells[index] == cell {
                    return true
                }
            }
        }
        
        return false
    }
    
    /**
    Adds a cell to the cell storage.
    
    - parameter cell: A cell to add.
    
    - returns: Returns false if a given cell is already in the storage and vice versa.
    */
    func addCell(cell: ConcentricGridViewCell) -> Bool {
        if !doesCellAlreadyInside(cell) {
            cells.append(cell)
            
            return true
        }
        
        return false
    }
    
    /**
    Gets the cell by an index.
    
    - parameter index: An index to fetch a cell by.
    
    "returns: An instance of the found cell or nil.
    */
    func getCellBy(index: Int) -> ConcentricGridViewCell? {
        for cell in cells {
            if cell.index == index {
                return cell
            }
        }
        
        return nil
    }
    
    /**
    Gets a cell by a frame.
    
    - parameter frame: A frame to find by.
    
    - returns: An instance of the found cell or nil.
    */
    func getCellBy(frame: CGRect) -> ConcentricGridViewCell? {
        if cells.count > 0 {
            for index in 0...cells.count - 1 {
                if CGRectEqualToRect(cells[index].frame, frame){
                    return cells[index]
                }
            }
        }
        
        return nil
    }
    
    /**
    Gets the last cell of the figure.
    
    - returns: An instance of the found cell or nil if there are no cells yet.
    */
    func getLastCell() -> ConcentricGridViewCell? {
        if cells.count > 0 {
            return cells[cells.count - 1]
        }
        
        return nil
    }
    
    /**
    Gets size of the figure in cells.
    */
    func getSizeInCells() -> CGSize {
        return CGSizeMake(
            self.frame.width / gridView.peripheralCellBox.width,
            self.frame.height / gridView.peripheralCellBox.height
        )
    }
}
