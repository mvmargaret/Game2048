//
//  ExtensionsArray.swift
//  Game2048
//
//  Created by Margarita Mayer on 07/04/24.
//

import Foundation

extension Array where Element == Tile {
	mutating func shiftLeft(from index: Int) {
		guard index < count && index >= 0 else { return }
		
		for i in index..<count-1 {
			self[i] = self[i + 1]
		}
	
		self[count - 1] = Tile(value: 0)

	}
}



extension Array where Element == Tile {
	mutating func moveTiles(score: inout Int) {
		var index = 0
		
		for _ in 0...2 {
			if self[index].value == 0 {
				
				self.shiftLeft(from: index)
				
			} else {
				
				if self[index + 1].value == 0 {
					
					self.shiftLeft(from: index + 1)
					
				} else {
					if self[index].value == self[index + 1].value {
						self[index].value *= 2
						score += self[index].value
						self.shiftLeft(from: index + 1)
						index += 1
						
					} else {
						index += 1
					}
				}
			}
		}
	}
}
