//
//  ConcentricGridViewPolygonWalker.swift
//
//  Created by Dmitry Gutsulyak on 4/2/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewPolygonWalker class extends ConcentricGridViewWalker to walk through a concentric polygon stack.
Walker always goes around a polygon uniformly filling the space starting from a center cell.
It progressively moves from a zero figure to the last one.
*/
class ConcentricGridViewPolygonWalker : ConcentricGridViewWalker {
    
    /**
    Walker steps over to the outer polygon depending on a current position.
    
    - parameter polygon: The outer polygon to move.
    */
    func moveToOuter(polygon polygon: ConcentricGridViewPolygonFigure) {
        moveCellToRectangleEntrance()
        
        if (ConcentricGridViewUtils.isOdd(self.figure.index)) {
            stepToTop(false)
            halfStepToLeft(false)
        } else if (ConcentricGridViewUtils.isEven(self.figure.index)) {
            stepToLeft(false)
        }
        
        self.figure = polygon
    }
    
    /**
    Moves Walker to the initial point of the outer polygon rectangle.
    */
    func moveCellToRectangleEntrance() {
        let polygon = figure as! ConcentricGridViewPolygonFigure
        
        if let firstRectangle = polygon.getInnerRectangleBy(index: 0) {
            jumpToTopLeftCornerIn(rectangle: firstRectangle.frame, memorize: false)
        }
    }
    
    /**
    Adds an initial rectangle for a polygon.
    */
    private func addFirstInnerRectangle() {
        let polygon = figure as! ConcentricGridViewPolygonFigure
        
        // Get the starting index on a rectangle side from that the swinging starts.
        let startIndex = polygon.isEven ?
            polygon.getHalfSideInCells() :
            polygon.getHalfSideInCells() - 1
        
        let currentRectangle = ConcentricGridViewFigurePrimitive(
            cell: peripheralCell.size,
            sizeInCells: polygon.getInnerRectangleSizeInCellsBy(index: Int(startIndex)),
            // Get the first cell in rectangle to determine the top left corner.
            origin: cell.frame.origin
        )
        polygon.add(rectangle: currentRectangle)
    }
    
    /**
    Calculates a number of primitive rectangles inside the polygon.
    */
    func calculateRectanglesForPolygon() {
        addFirstInnerRectangle()
        
        let polygon = figure as! ConcentricGridViewPolygonFigure
        
        // Walker walks swing-wise from a middle point of the polygon's upper half (from top to bottom like a hanging sit with constantly increased amplitude) and this parameter counts the number of these swingings.
        // Actually swinging it's just a process of picking an index by priority.
        // The parameter is increased by one after a one full swinging.
        var swingingCount = 1
        
        // Starts with the second rectangle because the first one has been already added by addFirstInnderRectangle method (first is zero), and decrement is used because of index starts with zero.
        for priority in 1...polygon.innerRectanglesCount - 1 {
            // Convert the rectangle priority to the real index.
            // Hint: Rectangles are started counting from the middle leftmost point of a polygon and finish at the leftmost top point of a polygon.
            var innerRectangleIndex = polygon.getInnerRectangleIndexBy(
                    priority: priority,
                    swingingCount: swingingCount
                )
            
            // For lack of the center item in odd polygons (they have the even number of item on their side) the resulting index has to be decreased during the swinging to level a central item absence.
            if polygon.isOdd {
                --innerRectangleIndex
            }
            
            // Move the cell either in the top or bottom direction considering the priority. It also depends on parity of a polygon.
            moveSwingingCellBy(priority: priority)
            
            polygon.add(rectangle: ConcentricGridViewFigurePrimitive(
                cell: peripheralCell.size,
                sizeInCells: polygon.getInnerRectangleSizeInCellsBy(index: innerRectangleIndex),
                origin: cell.frame.origin)
            )
            
            // Increment the parameter after a one full swinging.
            if ConcentricGridViewUtils.isEven(priority) {
                ++swingingCount
            }
        }

    }
    
    /**
    Moves Walker in a swinging way by a given priority.
    
    - parameter priority: A priority of a current cell to calculate the next position.
    */
    private func moveSwingingCellBy(priority priority: Int) {
        let polygon = figure as! ConcentricGridViewPolygonFigure
        
        if polygon.isOdd {
            ConcentricGridViewUtils.isOdd(priority) ?
                runToTopRightDiagonallyOn(stepsNumber: priority, memorize: false) :
                runToBottomLeftDiagonallyOn(stepsNumber: priority, memorize: false)
        } else if polygon.isEven {
            ConcentricGridViewUtils.isOdd(priority) ?
                runToBottomLeftDiagonallyOn(stepsNumber: priority, memorize: false) :
                runToTopRightDiagonallyOn(stepsNumber: priority, memorize: false)
        }
    }
    
    /**
    Starts walking through polygon's rectangles.
    */
    func walkThroughPolygonRectangles() {
        let polygon = figure as! ConcentricGridViewPolygonFigure
        
        for (index, rectangle) in polygon.rectangles.enumerate() {
            // A walking algorithm is different for the last rectangle.
            if index == polygon.rectangles.count - 1 {
                walkThroughLastInner(rectangle: rectangle)
                break;
            }
            
            walkThroughCorners(rectangle: rectangle)
        }
    }
    
    /**
    Starts walking through the last polygon's rectangle. The last rectangle requires different bypass logic.
    
    - parameter rectangle: A primitive rectangle to bypass.
    */
    func walkThroughLastInner(rectangle rectangle: ConcentricGridViewFigurePrimitive) {
        let innerRectanglesToWalk = splitRectangleIntoInnerPrimitives(rectangle: rectangle)
        
        for rectangle in innerRectanglesToWalk {
            walkThroughCorners(rectangle: rectangle)
        }
    }
    
    /**
    Allows Walker to jump through all rectangles' corners starting from the top left one.
    
    - parameter rectangle: A primitive rectangle to bypass.
    */
    func walkThroughCorners(rectangle rectangle: ConcentricGridViewFigurePrimitive) {
        jumpToTopLeftCornerIn(rectangle: rectangle.frame)
        jumpToBottomRightCornerIn(rectangle: rectangle.frame)
        jumpToTopRightCornerIn(rectangle: rectangle.frame)
        jumpToBottomLeftCornerIn(rectangle: rectangle.frame)
    }
    
    /**
    Splits a rectangle into inner primitives to implement unifrom bypass logic.
    
    - parameter rectangle: A primitive rectangle to split.
    */
    func splitRectangleIntoInnerPrimitives(rectangle rectangle: ConcentricGridViewFigurePrimitive) -> [ConcentricGridViewFigurePrimitive] {
        var innerPrimitives = [ConcentricGridViewFigurePrimitive]()
        let rectangleWidthInCells = rectangle.splitIntoCellsUsing(cell: peripheralCell.size).width
        // Including a center item if number of cells is odd
        let numberOfCellsToGoLeft = Int(ceil(rectangleWidthInCells / 2))
        // Exclude a first cell on which Walker is already standing for rectangles with the odd number of width in cells.
        let numberOfCellsToGoRight = Int(floor(rectangleWidthInCells / 2))
        
        // Jump to the top left corner
        jumpToTopLeftCornerIn(rectangle: rectangle.frame, memorize: false)
        
        // Go right up to the middle top point
        for _ in 1...numberOfCellsToGoRight {
            stepToRight(false)
        }
        
        let parentRectangleSizeInCells = rectangle.splitIntoCellsUsing(cell: peripheralCell.size)
        // Increase the width of a first even inner rectangle because it doesn't have a center item.
        var childRectangleWidth = ConcentricGridViewUtils.isEven(Int(rectangleWidthInCells)) ? 2 : 1
        
        // Go left, right down to the left corner memorizing inner rectangles on the way.
        for index in 1...numberOfCellsToGoLeft {
            
            // If rectangle is odd and the index is first just stay on the same place in all other cases move left.
            if ConcentricGridViewUtils.isOdd(Int(rectangleWidthInCells)) && index == 1 {
                addToFigure(cell)
            } else {
                stepToLeft(false)
            }

            // Add a primitive rectangle to the output array.
            innerPrimitives.append(ConcentricGridViewFigurePrimitive(
                    cell: peripheralCell.size,
                    sizeInCells: CGSizeMake(
                        CGFloat(childRectangleWidth),
                        parentRectangleSizeInCells.height
                    ),
                    origin: cell.frame.origin
                )
            )
            
            // Make width of the next inner rectangle.
            childRectangleWidth = childRectangleWidth + 2
        }
        
        return innerPrimitives
    }
    
    /**
    Allows Walker to make a top right step diagonally.
    
    - parameter memorize: Whether it should memorize a new cell.
    */
    func stepToTopRightDiagonally(memorize: Bool = true) {
        stepToTop(false)
        halfStepToRight(memorize)
    }
    
    /**
    Walker makes one step in the top direction diagonally.

    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func stepToBottomLeftDiagonally(memorize: Bool = true) {
        stepToBottom(false)
        halfStepToLeft(memorize)
    }
    
    /**
    Walker runs in the top direction diagonally and memorizes only the last cell of its running. It should be used only for the top half of a polygonal.

    - parameter stepsNumber: The number of steps to run
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func runToTopRightDiagonallyOn(stepsNumber stepsNumber: Int, memorize: Bool = true) {
        for index in 1...stepsNumber {
            if index == stepsNumber {
                stepToTopRightDiagonally(memorize)
                break
            }
            
            stepToTopRightDiagonally(false)
        }
    }
    
    /**
    Walker runs in the bottom direction diagonally and memorizes only the last cell of its running. It should be used only for the top half of a polygonal.

    - parameter stepsNumber: The number of steps to run.
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    */
    func runToBottomLeftDiagonallyOn(stepsNumber stepsNumber: Int, memorize: Bool = true) {
        for index in 1...stepsNumber {
            if index == stepsNumber {
                stepToBottomLeftDiagonally(memorize)
                break
            }
            
            stepToBottomLeftDiagonally(false)
        }
    }
}
