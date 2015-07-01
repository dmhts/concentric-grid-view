//
//  ConcentricGridViewProtocol.swift
//
//  Created by Dmitry Gutsulyak on 3/20/15.
//  Copyright (c) 2015 SHAPE GmbH. All rights reserved.
//

import Foundation

/**
The ConcentricGridViewProtocol describes all methods that must be implement by all
ConcentricGridView subclasses.
*/
public protocol ConcentricGridViewProtocol : class {
    func createGrid() -> Void
}
