//
//  Matrix.swift
//  Game2048
//
//  Created by Margarita Mayer on 09/04/24.
//

import Foundation

struct Grid {
	let rows: Int, columns: Int
	var tiles: [Tile]
	init() {
		self.rows = 4
		self.columns = 4
		tiles = [Tile]()
		for _ in 0..<rows * columns {
			var tile = Tile(value: 0)
			tiles.append(tile)
		}
	}
	func indexIsValid(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	subscript(row: Int, column: Int) -> Tile {
		get {
			assert(indexIsValid(row: row, column: column), "Index out of range")
			return tiles[(row * columns) + column]
		}
		set {
			assert(indexIsValid(row: row, column: column), "Index out of range")
			tiles[(row * columns) + column] = newValue
		}
	}
}
