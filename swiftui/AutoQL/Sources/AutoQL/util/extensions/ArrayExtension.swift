//
//  File.swift
//  
//
//  Created by Vicente Rincon on 04/02/22.
//

import Foundation
extension Array {
    func removeElements(_ elements: [Int]) -> Array{
        let newArray = self
            .enumerated()
            .filter { !elements.contains($0.offset) }
            .map { $0.element }
        return newArray
    }
}

