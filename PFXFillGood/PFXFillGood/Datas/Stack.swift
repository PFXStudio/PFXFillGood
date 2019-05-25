//
//  Stack.swift
//  PFXLeetCodeTests
//
//  Created by PFXStudio on 2019. 2. 10..
//  Copyright © 2019년 PFXStudio. All rights reserved.
//

import UIKit

public struct Stack<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
}
