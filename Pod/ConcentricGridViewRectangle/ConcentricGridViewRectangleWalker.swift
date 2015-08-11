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
    
    :returns: An ongoing instance of the class.
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
    
    :returns: An ongoing instance of the class.
    */
    func startWalkingAroundRectConsideringShift() -> ConcentricGridViewRectangleWalker {
        let rectangle = figure as! ConcentricGridViewRectangleFigure

        if rectangle.isLastHorizontallyUncut && figure.isOdd {
            walkAlongTopSide(notReachingEnd: 1)
            self.stepToRight(memorize: false, side: RectSide.none, positionOnSide: RectPositionOnSide.none)
            walkAlongRightSideDoNotMemorizeOddCells()
            walkAlongBottomSide(notReachingEnd: 1)
            walkAlongLeftSide()
        } else if rectangle.isLastHorizontallyUncut && figure.isEven {
            walkAlongTopSide()
            walkAlongRightSideDoNotMemorizeOddCells()
            walkAlongBottomSide()
            walkAlongLeftSide()
        } else if rectangle.isCutHorizontally && figure.isOdd {
            walkAlongTopSide(notReachingEnd: 1)
            self.stepToRight(memorize: false, side: RectSide.none, positionOnSide: RectPositionOnSide.none)
            jumpToOppositeSide(memorize: false)
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
    
    :param: rect The outer rect to move
    
    :returns: An ongoing instance of the class.
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
    
    :returns: An ongoing instance of the class.
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
    
    :returns: An ongoing instance of the class.
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
    
    :param: memorize Whether need to memorize the destination cell. The default value is `true`.
    
    :returns: An ongoing instance of the class.
    */
    func jumpToOppositeSide(memorize memorize: Bool = true) -> ConcentricGridViewRectangleWalker {
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
    
    :param: stepFunc A function that is used for walking.
    :param: side A side of the current rect which Walker is walking down. The default value is `RectSide.none`.
    :param: endingCorner A last cell of the side is a corner. The default value is `RectPositionOnSide.none`.
    :param: notReachingEnd Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    :param: doNotMemorizeOddCells Tells Walker to not memorize odd cells. The default value is `false`.
    :param: doNotMemorizeEventCells Tells Walker to not memorize even cells. The defult value is `false`.
    
    :returns: An ongoing instance of the class.
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
    
    :param: notReachingEnd Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    :returns: An ongoing instance of the class.
    */
    func walkAlongTopSide(notReachingEnd notReachingEnd: Int = 0) -> ConcentricGridViewRectangleWalker {
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
    
    :param: notReachingEnd Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    :returns: An ongoing instance of the class.
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
    
    :param: notReachingEnd Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    :returns: An ongoing instance of the class.
    */
    func walkAlongBottomSide(notReachingEnd notReachingEnd: Int = 0) -> ConcentricGridViewRectangleWalker {
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
    
    :param: notReachingEnd Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    :returns: An ongoing instance of the class.
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
    
    :param: notReachingEnd Over how many cells Walker needed to stop not reaching the end. The default value is `0`.
    
    :returns: An ongoing instance of the class.
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
    
    :param: memorize Whether need to memorize the destination cell. The default value is `true`.
    :param: side A side of the current rect which Walker is walking down. The default value is `RectSide.none`.
    :param: positionOnSide Indicates on which position Walker is stepping. It might be a middle point or a corner one.
    */
    func stepToRight(memorize memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(peripheralCell.width, 0, side, positionOnSide, memorize)
    }
    
    /**
    Allows Walker to make one step in the bottom direction. This method is used for convenience as a wrapper.
    
    :param: memorize Whether need to memorize the destination cell. The default value is `true`.
    :param: side A side of the current rect which Walker is walking down. The default value is `RectSide.none`. The default value is `RectPositionOnSide.none`.
    :param: positionOnSide Indicates on which position Walker is stepping. It might be a middle point or a corner one. The default value is `RectPositionOnSide.none`.
    */
    func stepToBottom(memorize memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(0, peripheralCell.height, side, positionOnSide, memorize)
    }
    
    /**
    Allows Walker to make one step in the left direction. This method is used for convenience as a wrapper.
    
    :param: memorize Whether need to memorize the destination cell. The default value is `true`.
    :param: side A side of the current rect which Walker is walking down. The default value is `RectSide.none`. The default value is `RectPositionOnSide.none`.
    :param: positionOnSide Indicates on which position Walker is stepping. It might be a middle point or a corner one. The default value is `RectPositionOnSide.none`.
    */
    func stepToLeft(memorize memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(-peripheralCell.width, 0, side, positionOnSide, memorize)
    }
    
    /**
    Allows Walker to make one step in the top direction. This method is used for convenience as a wrapper.
    
    :param: memorize Whether need to memorize the destination cell. The default value is `true`.
    :param: side A side of the current rect which Walker is walking down. The default value is `RectSide.none`. The default value is `RectPositionOnSide.none`.
    :param: positionOnSide Indicates on which position Walker is stepping. It might be a middle point or a corner one. The default value is `RectPositionOnSide.none`.
    */
    func stepToTop(memorize memorize: Bool = true, side: RectSide = .none, positionOnSide: RectPositionOnSide = .none) {
        moveRelativeTo(0, -peripheralCell.height, side, positionOnSide, memorize)
    }
    
    /**
    Moves Walker to a given cell relatively to the current one.
    
    :param: dx A delta of x-coordinate to go.
    :param: dy A delta of y-coordinate to go.
    :param: side A side that the cell represents.
    :param: positionOnSide  A cell position on the side.
    :param: memorize Whether it should memorize a new cell.
    
    :returns: An ongoing instance of the class.
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
    
    :param: x An x-coordinate to go.
    :param: y An y-coordinate to go.
    :param: side A side that the cell represents.
    :param: positionOnSide  A cell position on the side.
    :param: memorize Whether it shoud memorize a new cell.
    
    :returns: An ongoing instance of the class.
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
    
    :param: frame A rectangle that describes a new Walker position. A size of the frame might be equal to a peripheral cell.
    :param: side A side that the cell represents.
    :param: positionOnSide  A cell position on the side.
    :param: memorize Whether it shoud memorize a new cell in the storage.
    
    :returns: self
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
