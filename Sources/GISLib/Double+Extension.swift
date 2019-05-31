//
//  Double+Extension.swift
//  GISLib
//
//  Created by GG on 2019/5/31.
//

import Foundation

extension Double{
    internal func roundOff(_ places: Int) -> Double {
        return Double(String(format: "%.\(places)f", self)) ?? 0
    }
}
