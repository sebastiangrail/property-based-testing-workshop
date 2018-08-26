//
//  Example.swift
//  Property Based Testing Workshop
//
//  Created by Sebastian Grail on 18/8/18.
//  Copyright © 2018 Sebastian Grail. All rights reserved.
//

import Foundation

func max (_ x: Int, _ y: Int) -> Int {
    return x > y ? x : y
}

func min(_ x: Int, _ y: Int) -> Int {
    return x < y ? x : y
}

func min2 <T: Comparable> (_ x: T, _ y: T) -> T {
    return x < y ? x : y
}
