//
//  ConcentricGridView.swift
//
//  Created by Gutsulyak Dmitry on 3/17/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridView class is an abstract base class that is used by subclass to build a virtual concentric grid
that consists of a central cell and peripheral cells around it. 
Cells indexes located spirally clockwise starting with 0 at the central cell. 
Also it implements a methods which allows to get coordinates of any cell in thе grid.
In turn, all cells consist of blocks. Peripheral cells always have the same size and
it equals 1x1 block by default. Thе size can be overriden by a subclass. A central
cell might have either the same or different from a peripheral cell size, also it might be
overriden by a descendant. To understand all this stuff just watch a visualization on the github page.
*/
public class ConcentricGridView {
    
    /// The array of nested concentric figures with a common central point.
    lazy var figures = [ConcentricGridViewFigure]()
    
    /// The center point of a gridview.
    let center: CGPoint
    
    /// Vertical and horizontal margins of a grid cell (top, right, bottom, left) i.e. additional space along all the perimeter.
    let cellMargin: CGFloat
    
    /// The peripheral grid cell frame.
    var peripheralCell: CGRect {
        get {
            return CGRectMake(
                centralCellOrigin.x,
                centralCellOrigin.y,
                peripheralCellBox.width,
                peripheralCellBox.height
            )
        }
    }
    
    /// The peripheral grid cell size in points.
    let peripheralCellBox: CGSize
    
    /// The peripheral grid cell size in blocks. It always equals to 1x1 due to the concetric view algorithm. See more about blocks in the class description.
    let peripheralCellBoxInBlocks = CGSizeMake(1, 1)
    
    /// The central grid cell.
    var centralCell: CGRect {
        get {
            return CGRectMake(
                centralCellOrigin.x,
                centralCellOrigin.y,
                centralCellBox.width,
                centralCellBox.height
            )
        }
    }
    
    /// Origin-like coordinates of the centralCell.
    var centralCellOrigin: CGPoint {
        get {
            return CGPointMake(
                center.x - centralCellBox.width / 2,
                center.y - centralCellBox.height / 2
            )
        }
    }
    
    /// The central grid cell size in blocks. See more about blocks in the class description.
    var centralCellBoxInBlocks: CGSize
    
    /// The central grid cell size in points.
    var centralCellBox: CGSize {
        get {
            return CGSizeMake(
                self.centralCellBoxInBlocks.width * peripheralCellBox.width,
                self.centralCellBoxInBlocks.height * peripheralCellBox.height
            )
        }
    }
    
    /// The size of the grid view in blocks
    var gridInBlocks: CGSize
    
    /// The size of the grid view in points
    let size: CGSize
    
    /**
    Initializes and calculates a new grid view object with the provided parameters.

    :param: grid The area size in points to be splitted into cells
    :param: centralCell The central cell size in points
    :param: peripheralCell The peripheral cell size in points
    :param: cellMargin Vertical and horizontal margins of a grid cell in points
    
    :returns: An initialized instance of the class.
    */
    init(grid: CGSize, centralCell: CGSize, peripheralCell: CGSize, cellMargin: CGFloat){
        self.cellMargin = cellMargin
        
        peripheralCellBox = CGSizeMake(
            2 * cellMargin + peripheralCell.width,
            2 * cellMargin + peripheralCell.height
        )
        
        centralCellBoxInBlocks =  CGSizeMake(
            ceil((2 * cellMargin + centralCell.width) / peripheralCellBox.width),
            ceil((2 * cellMargin + centralCell.height) / peripheralCellBox.height)
        )
        
        size = grid
        gridInBlocks = CGSizeMake(
            floor(self.size.width / self.peripheralCellBox.width),
            floor(self.size.height / self.peripheralCellBox.height)
        )
        
        center = CGPointMake(self.size.width / 2, self.size.height / 2)
        
        validateGrid()
        normalizeGrid()
    }
    
    /**
    Must be implemented by descendant. It uses grid params to create one.
    */
    public func createGrid() {
        assert(false, "This method must be implemented")
    }
    
    /**
    It gives out point coordinates by the certain index on the grid.

    :returns: Central point coordinates of the requested cell.
    */
    public func getPointAt(index: Int) -> CGPoint? {
        for i in 0...figures.count - 1 {
            if let cell = figures[i].getCellBy(index) {
                return cell.getCenterPoint()
            }
        }
        
        return nil
    }
    
    /**
    Adds a figure to to the grid storage

    :param: figure A figure to add to the grid storage
    */
    func add(#figure: ConcentricGridViewFigure) {
        figures.append(figure)
    }
    
    /** 
    Validates incoming parameters of a grid and its cells. In case of overriding by descendant must be called the parent implementation.
    */
    func validateGrid() {
        if gridInBlocks.width < centralCellBoxInBlocks.width {
            assert(false, "width of the central cell is more than the width of the collection view")
        } else if gridInBlocks.height < centralCellBoxInBlocks.height {
            assert(false, "height of the central cell is more than the height of the collection view")
        }
    }
    
    /** 
    Normalizes the grid in other words makes it symmetric relatively to the central cell (number of peripheral cells beginning from the central one has to be equal in left-right and top-bottom directions).
    */
    func normalizeGrid() {
        if gridInBlocks.width % 2 == 0 {
            gridInBlocks.width--
        }
        
        if gridInBlocks.height % 2 == 0 {
            gridInBlocks.height--
        }
    }
}
