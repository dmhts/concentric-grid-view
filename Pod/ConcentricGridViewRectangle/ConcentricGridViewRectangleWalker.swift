//
//  ConcentricRectangleGridViewWalker.swift
//
//  Created by Dmitry Gutsulyak on 3/22/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewRectangleWalker class extends ConcentricGridViewWalker to walk through a concentric rectangles stack. 
Walker always goes clock-wise starting from a central cell. Progressively moving from a zero figure to the last one. 
All class methods related to moving return an ongoing class instance to provide chaining.
*/
class ConcentricGridViewRectangleWalker : ConcentricGridViewWalker {
    
    /**
    Allows Walker to walk clock-wise progressevily from a zero figure to the last one.
    
    - returns: An ongoing instance of the class.
    */
    func startWalkingAroundRect() -> ConcentricGridViewRectangleWalker {
        let rectangle = figure as! ConcentricGridViewRectangleFigure
        
        if rectangle.isCutHorizontally {
            walkAlongTopSide()
            jumpToOppositeSide()
            walkAlongBottomSide()
            jumpToOppositeSide()
        } else if rectangle.isCutVertically {
            jumpToOppositeSide()
            walkAlongRightSide()
            jumpToOppositeSide()
            walkAlongLeftSide()
        } else {
            walkAlongTopSide()
            walkAlongRightSide()
            walkAlongBottomSide()
            walkAlongLeftSide()
        }
        
        return self
    }
    
    /**
    Allows Walker to walk clock-wise considering shift.
    
    - returns: An ongoing instance of the class.
    */
    func startWalkingAroundRectConsideringShift() -> ConcentricGridViewRectangleWalker {
        let rectangle = figure as! ConcentricGridViewRectangleFigure

        if rectangle.isLastHorizontallyUncut && figure.isOdd {
            walkAlongTopSide(1)
            self.stepToRight(false, side: RectSide.none, positionOnSide: RectPositionOnSide.none)
            walkAlongRightSideDoNotMemorizeOddCells()
            walkAlongBottomSide(1)
            walkAlongLeftSide()
        } else if rectangle.isLastHorizontallyUncut && figure.isEven {
            walkAlongTopSide()
            walkAlongRightSideDoNotMemorizeOddCells()
            walkAlongBottomSide()
            walkAlongLeftSide()
        } else if rectangle.isCutHorizontally && figure.isOdd {
            walkAlongTopSide(1)
            self.stepToRight(false, side: RectSide.none, positionOnSide: RectPositionOnSide.none)
            jumpToOppositeSide(false)
            walkAlongBottomSide()
            jumpToOppositeSide()
        } else if rectangle.isCutHorizontally {
            walkAlongTopSide()
            jumpToOppositeSide()
            walkAlongBottomSide()
            jumpToOppositeSide()
        } else if rectangle.isCutVertically {
            jumpToOppositeSide()
            walkAlongRightSide()
            jumpToOppositeSide()
            walkAlongLeftSide()
        } else {
            walkAlongTopSide()
            walkAlongRightSide()
            walkAlongBottomSide()
            walkAlongLeftSide()
        }
        
        return self
    }
    
    /**
    Walker steps over to the outer rect depending on the current position.
    
    - parameter rect: The outer rect to move
    
    - returns: An ongoing instance of the class.
    */
    func moveToOuter(rectangle rectangle: ConcentricGridViewRectangleFigure) -> ConcentricGridViewRectangleWalker {
        self.figure = rectangle
        
        if rectangle.isCutHorizontally {
            stepToTop(side: .top, positionOnSide: .none)
        } else if rectangle.isCutVertically {
            stepToLeft(side: .left, positionOnSide: .none)
        } else {
            jumpToTopLeftCorner()
        }
        
        return self
    }
    
    /**
    Allows Walker to jump to the top left corner of the current rect.
    
    - returns: An ongoing instance of the class.
    */
    func jumpToTopLeftCorner() -> ConcentricGridViewRectangleWalker {
        moveAbsoluteTo(
            CGRectGetMinX(figure.frame),
            CGRectGetMinY(figure.frame),
            .none,
            .topLeft
        )
        
        return self
    }
    
    /**
    Allows Walker to jump to the bottom right corner of the current rect.
    
    - returns: An ongoing instance of the class.
    */
    func jumpToBottomRightCorner() -> ConcentricGridViewRectangleWalker {
        moveAbsoluteTo(
            CGRectGetMaxX(figure.frame),
            CGRectGetMaxY(figure.frame),
            .none,
            .topLeft
        )
        
        return self
    }
    
    /**
    Allows Walker to jump to the opposite side.
    
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    
    - returns: An ongoing instance of the class.
    */
    func jumpToOppositeSide(memorize: Bool = true) -> ConcentricGridViewRectangleWalker {
        let rectangleCell = cell as! ConcentricGridViewRectangleCell
        
        switch(rectangleCell.side) {
            case .top:
                moveRelativeTo(0, figure.frame.height - cell.frame.height, .bottom, .none, memorize)
            case .right:
                moveRelativeTo(-figure.frame.width + cell.frame.height, 0, .left, .none, memorize)
            case .bottom:
                moveRelativeTo(0, -figure.frame.height + cell.frame.height, .top, .none, memorize)
            case .left:
                moveRelativeTo(-figure.frame.width + cell.frame.height, 0, .right, .none, memorize)
            case .none: break
        }
        
        return self
    }
    
    /**
    Allows Walker to move along a side with specified options.
    
    - parameter stepFunc: A function that is used for walking.
    - parameter side: A side of the current rect which Walker is walking down. The default value is `RectSide.none`.
    - parameter endingCorner: A last cell of the side is a corner. The default value is `RectPositionOnSide.none`.
    - parameter notReachingEnd: Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    - parameter doNotMemorizeOddCells: Tells Walker to not memorize odd cells. The default value is `false`.
    - parameter doNotMemorizeEventCells: Tells Walker to not memorize even cells. The defult value is `false`.
    
    - returns: An ongoing instance of the class.
    */
    func walkAlongSide(
        side: RectSide = .none,
        endingCorner: RectPositionOnSide = .none,
        notReachingEnd: Int = 0,
        doNotMemorizeOddCells : Bool = false,
        doNotMemorizeEvenCells: Bool = false,
        stepFunc: (Bool, RectSide, RectPositionOnSide) -> Void
    ) -> ConcentricGridViewRectangleWalker {
            let rectangle = figure as! ConcentricGridViewRectangleFigure
            
            // The decrement here is used because the walker is already staying on the first cell of the given side before starting walking
            let numberOfCellsOnSideToGo = (Int(rectangle.getSizeInCells().width) - 1) - notReachingEnd
            
            for index in 1...numberOfCellsOnSideToGo  {
                if ConcentricGridViewUtils.isOdd(index) && doNotMemorizeOddCells {
                    stepFunc(false, RectSide.none, RectPositionOnSide.none)
                } else if ConcentricGridViewUtils.isEven(index) && doNotMemorizeEvenCells {
                    stepFunc(false, RectSide.none, RectPositionOnSide.none)
                } else if index == numberOfCellsOnSideToGo && !rectangle.isCutHorizontally {
                    stepFunc(true, side, endingCorner)
                } else {
                    // Check whether a cell located in the middle of the side
                    if (index == numberOfCellsOnSideToGo / 2) {
                        let midPoint = RectSide.getMidPointBySide(side)
                        
                        stepFunc(true, side, midPoint)
                    } else {
                        stepFunc(true, side, endingCorner)
                    }
                }
            }
            
            return self
    }
    
    /**
    Allows Walker to walk down the top side of the rect. This method is used for convenience as a wrapper.
    
    - parameter notReachingEnd: Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    - returns: An ongoing instance of the class.
    */
    func walkAlongTopSide(notReachingEnd: Int = 0) -> ConcentricGridViewRectangleWalker {
        walkAlongSide(
            RectSide.top,
            endingCorner: RectPositionOnSide.topRight,
            notReachingEnd: notReachingEnd,
            stepFunc: stepToRight
        )
        
        return self
    }
    
    /**
    Allows Walker to walk down the right side of the rect. This method is used for convenience as a wrapper.
    
    - parameter notReachingEnd: Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    - returns: An ongoing instance of the class.
    */
    func walkAlongRightSide(notReachingEnd: Int = 0) -> ConcentricGridViewRectangleWalker {
        walkAlongSide(
            RectSide.right,
            endingCorner: RectPositionOnSide.bottomRight,
            notReachingEnd: notReachingEnd,
            stepFunc: stepToBottom
        )
        
        return self
    }
    
    /**
    Allows Walker to walk down the bottom side of the rect. This method is used for convenience as a wrapper.
    
    - parameter notReachingEnd: Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    - returns: An ongoing instance of the class.
    */
    func walkAlongBottomSide(notReachingEnd: Int = 0) -> ConcentricGridViewRectangleWalker {
        walkAlongSide(
            RectSide.bottom,
            endingCorner: RectPositionOnSide.bottomLeft,
            notReachingEnd: notReachingEnd,
            stepFunc: stepToLeft
        )
        
        return self
    }
    
    /**
    Allows Walker to walk down the left side of the rect. This method is used for convenience as a wrapper.
    
    - parameter notReachingEnd: Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    - returns: An ongoing instance of the class.
    */
    func walkAlongLeftSide(notReachingEnd: Int = 0) -> ConcentricGridViewRectangleWalker {
        walkAlongSide(
            RectSide.left,
            endingCorner: RectPositionOnSide.topLeft,
            notReachingEnd: notReachingEnd,
            stepFunc: stepToTop
        )
        
        return self
    }
    
    /**
    Allows Walker to walk down the right side of the rect without memorizing odd cells. This method is used for convenience as a wrapper.
    
    - parameter notReachingEnd: Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    - returns: An ongoing instance of the class.
    */
    func walkAlongRightSideDoNotMemorizeOddCells() -> ConcentricGridViewRectangleWalker {
        walkAlongSide(
            RectSide.right,
            endingCorner: RectPositionOnSide.bottomRight,
            notReachingEnd: 0,
            doNotMemorizeOddCells: true,
            stepFunc: stepToBottom
        )
        
        return self
    }
    
    /**
    Allows Walker to make one step in the right direction. This method is used for convenience as a wrapper.
    
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    - parameter side: A side of the current rect which Walker is walking down. The default value is `RectSide.none`.
    - parameter positionOnSide: Indicates on which position Walker is stepping. It might be a middle point or a corner one.
    */
    func stepToRight(memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(peripheralCell.width, 0, side, positionOnSide, memorize)
    }
    
    /**
    Allows Walker to make one step in the bottom direction. This method is used for convenience as a wrapper.
    
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    - parameter side: A side of the current rect which Walker is walking down. The default value is `RectSide.none`. The default value is `RectPositionOnSide.none`.
    - parameter positionOnSide: Indicates on which position Walker is stepping. It might be a middle point or a corner one. The default value is `RectPositionOnSide.none`.
    */
    func stepToBottom(memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(0, peripheralCell.height, side, positionOnSide, memorize)
    }
    
    /**
    Allows Walker to make one step in the left direction. This method is used for convenience as a wrapper.
    
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    - parameter side: A side of the current rect which Walker is walking down. The default value is `RectSide.none`. The default value is `RectPositionOnSide.none`.
    - parameter positionOnSide: Indicates on which position Walker is stepping. It might be a middle point or a corner one. The default value is `RectPositionOnSide.none`.
    */
    func stepToLeft(memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(-peripheralCell.width, 0, side, positionOnSide, memorize)
    }
    
    /**
    Allows Walker to make one step in the top direction. This method is used for convenience as a wrapper.
    
    - parameter memorize: Whether need to memorize the destination cell. The default value is `true`.
    - parameter side: A side of the current rect which Walker is walking down. The default value is `RectSide.none`. The default value is `RectPositionOnSide.none`.
    - parameter positionOnSide: Indicates on which position Walker is stepping. It might be a middle point or a corner one. The default value is `RectPositionOnSide.none`.
    */
    func stepToTop(memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(0, -peripheralCell.height, side, positionOnSide, memorize)
    }
    
    /**
    Moves Walker to a given cell relatively to the current one.
    
    - parameter dx: A delta of x-coordinate to go.
    - parameter dy: A delta of y-coordinate to go.
    - parameter side: A side that the cell represents.
    - parameter positionOnSide:  A cell position on the side.
    - parameter memorize: Whether it should memorize a new cell.
    
    - returns: An ongoing instance of the class.
    */
    func moveRelativeTo(dx: CGFloat, _ dy: CGFloat, _ side: RectSide, _ positionOnSide: RectPositionOnSide, _ memorize: Bool = true) -> ConcentricGridViewRectangleWalker {
        let frame = CGRectOffset(
            CGRectMake(
                cell.frame.origin.x,
                cell.frame.origin.y,
                peripheralCell.width,
                peripheralCell.height
            ), dx, dy
        )
        
        stepToCellWith(frame, side: side, positionOnSide: positionOnSide, memorize: memorize)
        
        return self
    }
    
    /**
    Moves Walker to a given cell relatively to a device screen.
    
    - parameter x: An x-coordinate to go.
    - parameter y: An y-coordinate to go.
    - parameter side: A side that the cell represents.
    - parameter positionOnSide:  A cell position on the side.
    - parameter memorize: Whether it shoud memorize a new cell.
    
    - returns: An ongoing instance of the class.
    */
    func moveAbsoluteTo(x: CGFloat, _ y: CGFloat, _ side: RectSide, _ positionOnSide: RectPositionOnSide, _ memorize: Bool = true) -> ConcentricGridViewRectangleWalker {
        let frame = CGRectMake(
            x, y,
            peripheralCell.width,
            peripheralCell.height
        )
        
        stepToCellWith(frame, side: side, positionOnSide: positionOnSide, memorize: memorize)
        
        return self
    }
    
    /**
    Steps to an anrbitrary cell of the figure.
    
    - parameter frame: A rectangle that describes a new Walker position. A size of the frame might be equal to a peripheral cell.
    - parameter side: A side that the cell represents.
    - parameter positionOnSide:  A cell position on the side.
    - parameter memorize: Whether it shoud memorize a new cell in the storage.
    
    - returns: self
    */
    func stepToCellWith(frame: CGRect, side: RectSide, positionOnSide: RectPositionOnSide, memorize: Bool = true) -> ConcentricGridViewRectangleWalker {
        if let expectedCell = figure.getCellBy(frame) {
            cell = expectedCell
        } else {
            // Set the default index to zero in case if this is the central cell
            var nextIndex: Int = 0
            
            // Get the next index always from the last cell in a rectangle or go to a previous to get one
            if let lastCell = figure.getLastCell() {
                nextIndex = lastCell.index + 1
            } else if let previous = figure.previous {
                if let lastPreviousCell = previous.getLastCell() {
                    nextIndex = lastPreviousCell.index + 1
                }
            }
            
            let newCell = ConcentricGridViewRectangleCell(
                index: nextIndex,
                frame: frame,
                side: side,
                positionOnSide: positionOnSide
            )
            
            if (memorize) {
                addToFigure(newCell)
                changeCellOn(figure.getLastCell()!)
            } else {
                changeCellOn(newCell)
            }
            
        }
        
        return self
    }
}
