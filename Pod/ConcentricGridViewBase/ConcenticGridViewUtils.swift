//
//  Utils.swift
//
//  Created by Gutsulyak Dmitry on 3/25/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation

/**
The ConcentricGridViewUtils class is used to store common grid functionality.
*/
class ConcentricGridViewUtils {
    
    /**
    Checks whether a number is even.
    
    - parameter number: A number to check.
    
    - returns: Whether a number is even.
    */
    class func isEven(number: Int) -> Bool {
        return number % 2 == 0
    }
    
    /**
    Checks whether a number is odd.
    
    - parameter number: A number to check.
    
    - returns: Whether a number is odd.
    */
    class func isOdd(number: Int) -> Bool {
        return !isEven(number)
    }
}


