//
//  ConcentricPolygonGridView.swift
//
//  Created by Dmitry Gutsulyak on 3/20/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcetricGridViewPolygon extends ConcentricGridView to implement a grid that consists of a stack  of concentric polygons.
Each cell of the grid including a central one must be an equal size to prevent intersection.
*/
public class ConcentricGridViewPolygon : ConcentricGridView, ConcentricGridViewProtocol{
    
    /**
    Initializes an instance of the class using given params.
    
    :param: grid A grid size in points.
    :param: centralCell A centrall cell size of the grid in points.
    :param: peripheralCell A peripheral cell size of the grid in points.
    :param: cellMargin A margin between peripheral cells.
    
    :returns: An initialized instance of the class.
    */
    public override init(grid: CGSize, centralCell: CGSize, peripheralCell: CGSize, cellMargin: CGFloat) {
        super.init(grid: grid, centralCell: centralCell, peripheralCell: peripheralCell, cellMargin: cellMargin)
    }
    
    /**
    Creates a grid (the sum of figures) to go for an appropriate class Walker.
    */
    public override func createGrid() {
        // Make the first polygon with the only center cell inside (a central cell will be added by Walker in its constructor) and add it to the grid storage
        var currentPolygon = ConcentricGridViewPolygonFigure(
                index: 0,
                previous: nil,
                sizeInCells: CGSizeMake(centralCellBoxInBlocks.width, centralCellBoxInBlocks.height),
                gridView: self
            )
        self.add(figure: currentPolygon)
        
        // Create the walker instance with previous created polygon and put it onto the central cell
        let walker = ConcentricGridViewPolygonWalker (
                figure: currentPolygon,
                centralCell: self.centralCell,
                peripheralCell: self.peripheralCell,
                grid: self.size
            )
        
        // Init the remaining number of rows and columns in the grid considering the central cell
        var remainingRows: CGFloat = gridInBlocks.height - 1
        var remainingColumns: CGFloat = gridInBlocks.width - 1
        
        // The next polygon variable
        var outerRectanglesizeInCells: CGSize!
        
        // Add the sufficient number of polygons to fit the grid
        while(currentPolygon.isLast != true) {
            remainingRows = remainingRows == 0 ? 0 : remainingRows - 2
            remainingColumns = remainingColumns == 0 ? 0 : remainingColumns - 2
            
            outerRectanglesizeInCells = CGSizeMake(currentPolygon.getSizeInCells().width + 2, currentPolygon.getSizeInCells().height + 2)
            
            currentPolygon = ConcentricGridViewPolygonFigure(
                index: currentPolygon.index + 1,
                previous: currentPolygon,
                sizeInCells: CGSizeMake(
                    outerRectanglesizeInCells.width,
                    outerRectanglesizeInCells.height
                ),
                gridView: self
            )
            self.add(figure: currentPolygon)
            
            if remainingRows.isZero && remainingColumns.isZero {
                currentPolygon.isLast = true
                break
            }
        }
        
        for (index, figure) in figures.enumerate() {
            let polygon = figure as! ConcentricGridViewPolygonFigure
            
            // Skip the central cell (that is equals to the first polygon) because Walker has already processed it
            if index == 0 { continue }
            
            walker.moveToOuter(polygon: polygon)
            walker.calculateRectanglesForPolygon()
            walker.walkThroughPolygonRectangles()
        }
    }

}
