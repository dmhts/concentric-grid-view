//
//  ConcentricGridViewPolygonFigure.swift
//
//  Created by Dmitry Gutsulyak on 4/2/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation
import QuartzCore

/**
The ConcentricGridViewPolygonFigure class that extends ConcentricGridViewFigure to represent a polygon figure as a part of a grid stack.

*/
class ConcentricGridViewPolygonFigure : ConcentricGridViewFigure {
    
    /// The rectangles storage. The thing is a a polygon consists of more privimitive figures - rectangles.
    lazy var rectangles = [ConcentricGridViewFigurePrimitive]()
    
    /// The number of inner rectangles. Increment is used to consider a zero index.
    var innerRectanglesCount : Int {
        get {
            return index + 1
        }
    }
    
    /**
    Gets a size (in cells) for a polygon inner rectangle with a specified index. 
    Rectangles are started counting from the middle leftmost point of a polygon and finish at the leftmost top point of a polygon.
    
    :param: index An index of an inner rectanglea
    
    :returns: An inner rectangle size in cells by a given index.
    */
    func getInnerRectangleSizeInCellsBy(index index: Int) -> CGSize {
        // Starts from the middle leftmost point of a polygon and moves to the top
        let width = getSizeInCells().width - CGFloat(index)
        let height = CGFloat(index * 2) + 1

        return CGSizeMake(width, height)
    }
    
    /**
    By default this method is used for getting a rectangle index by priority considering swingingCount in odd polygons but it can be used for even ones - just switch the inverseSwinging option.
    It means in odd rectangles swinging happens from top to bottom and in even vice versa
    
    :param: priority A priority of a rectangle
    :param: swingingCount A number of swinging
    
    :returns: An inner rectangle index using a priority and a singing count.
    */
    func getInnerRectangleIndexBy(priority priority: Int, swingingCount: Int) -> Int {
        let halfSideWithoutCenter = getHalfSideInCells()
        var innerRectangleIndex : Int!
        
        // In odd rectangles swinging happens from top to bottom and in even vice versa. By default swinging is performed for odd polygons.
        if isOdd {
            innerRectangleIndex = (priority % 2 != 0) ?
                Int(halfSideWithoutCenter + CGFloat(swingingCount)) :
                Int(halfSideWithoutCenter - CGFloat(swingingCount))
        } else if isEven {
            innerRectangleIndex = (priority % 2 != 0) ?
                Int(halfSideWithoutCenter - CGFloat(swingingCount)) :
                Int(halfSideWithoutCenter + CGFloat(swingingCount))
        }
        
        return innerRectangleIndex
    }
    
    /**
    Gets the half side (in cells) without a center item
    
    :returns: A down-rounded half value of a side cells.
    */
    func getHalfSideInCells() -> CGFloat {
        return floor(CGFloat(innerRectanglesCount / 2))
    }
    
    /**
    Adds a rectangle to the storage
    
    :param: rectangle A primitive figure to store.
    */
    func add(rectangle rectangle: ConcentricGridViewFigurePrimitive) {
        rectangles.append(rectangle)
    }
    
    /**
    Gets an inner rectangle by an index.
    
    :param: index An index of an inner rectangle.
    
    :returns: A primitive figure by a given index if one exists.
    */
    func getInnerRectangleBy(index index: Int) -> ConcentricGridViewFigurePrimitive? {
        for (innerIndex, rectangle) in rectangles.enumerate() {
            if innerIndex == index {
                return rectangle
            }
        }
        
        return nil
    }
}