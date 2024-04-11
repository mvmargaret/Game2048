//
//  ViewModel.swift
//  Game2048
//
//  Created by Margarita Mayer on 08/04/24.
//

import Foundation
import SwiftUI

@Observable
class ViewModel {
	
	let randomNumbers = [2, 4]
	var grid = Grid()
	var score: Int = 0 {
		didSet {
			updateAndSaveBestScore()
		}
	}
	var bestScore: Int = 0
	var isGameOver = false
	var isGameWon = false
	var isAlertUserWonShown = false
	var isAlertGameOverShown = false
	let savePath = URL.documentsDirectory.appending(path: "bestScore")
	
	
	init() {
		do {
			let data = try Data(contentsOf: savePath)
			bestScore = try JSONDecoder().decode(Int.self, from: data)
		} catch {
			print("Failed to load data")
		}
	}
	
	func handleDirections(direction: Directions) {
		let currentTiles = grid.tiles.map({ $0.value })
		
		withAnimation(.linear(duration: 0.2)) {
			switch direction {
			case .right:
				moveTilesRight()
			case .left:
				moveTilesLeft()
			case .up:
				moveTilesUp()
			case .down:
				moveTilesDown()
			}
		}
		
		if currentTiles != grid.tiles.map({ $0.value }) {
			withAnimation(.linear.delay(0.3)) {
				addNewNumber()
			}
		}
		
		if grid.tiles.contains(where: {$0.value == 2048 }) && isAlertUserWonShown == false {
			isGameWon = true
		}
		
		if checkIfGameOver() && isAlertGameOverShown == false {
			isGameOver = true
		}
	}
	
	func addNewNumber() {
		
		var emptyTilesIndices: [(row: Int, column: Int)] = []
		
		for row in 0..<grid.rows {
			for column in 0..<grid.columns {
				if grid[row, column].value == 0 {
					emptyTilesIndices.append((row, column))
				}
			}
		}
		
		if let randomTileIndex = emptyTilesIndices.randomElement() {
			let randomValue = randomNumbers.randomElement()
			grid[randomTileIndex.row, randomTileIndex.column].value = randomValue ?? 0
			print("Randomly selected tile at row \(randomTileIndex.row), column \(randomTileIndex.column) with value \(randomValue ?? 0)")
		} else {
			print("No empty cells")
		}
	}
	
	func moveTilesLeft() {
		for row in 0..<grid.rows {
			var currentRow = [Tile]()
			for column in 0..<grid.columns {
				currentRow.append(grid[row, column])
			}
			currentRow.moveTiles(score: &score)
			for column in 0..<grid.columns {
				grid[row, column] = currentRow[column]
			}
		}
	}
	
	func moveTilesRight() {
		
		for row in 0..<grid.rows {
			var currentRow = [Tile]()
			for column in 0..<grid.columns {
				currentRow.append(grid[row, column])
			}
			currentRow.reverse()
			currentRow.moveTiles(score: &score)
			currentRow.reverse()
			for column in 0..<grid.columns {
				grid[row, column] = currentRow[column]
			}
		}
		
	}
	
	
	func moveTilesUp() {
		var newGrid = grid
		for row in 0..<grid.rows {
			for column in 0..<grid.columns {
				newGrid[row, column] = grid[column, row]
			}
		}
		
		for row in 0..<newGrid.rows {
			var currentRow = [Tile]()
			for column in 0..<newGrid.columns {
				currentRow.append(newGrid[row, column])
			}
			currentRow.moveTiles(score: &score)
			for column in 0..<newGrid.columns {
				newGrid[row, column] = currentRow[column]
			}
		}
		
		for row in 0..<newGrid.rows {
			for column in 0..<newGrid.columns {
				grid[row, column] = newGrid[column, row]
				
			}
		}
	}
	
	
	func moveTilesDown() {
		var newGrid = grid
		for row in 0..<grid.rows {
			for column in 0..<grid.columns {
				newGrid[row, column] = grid[column, row]
			}
		}
		
		for row in 0..<newGrid.rows {
			var currentRow = [Tile]()
			for column in 0..<newGrid.columns {
				currentRow.append(newGrid[row, column])
			}
			currentRow.reverse()
			currentRow.moveTiles(score: &score)
			currentRow.reverse()
			for column in 0..<newGrid.columns {
				newGrid[row, column] = currentRow[column]
			}
		}
		
		for row in 0..<newGrid.rows {
			for column in 0..<newGrid.columns {
				grid[row, column] = newGrid[column, row]
				
			}
		}
	}
	
	func handleGestures(value: DragGesture.Value) {
		let horizontalAmount = value.translation.width
		let verticalAmount = value.translation.height
		
		if abs(horizontalAmount) > abs(verticalAmount) {
			horizontalAmount < 0 ? self.handleDirections(direction: .left) : self.handleDirections(direction: .right)
		} else {
			verticalAmount < 0 ? self.handleDirections(direction: .up) : self.handleDirections(direction: .down)
		}
	}
	
	func checkIfGameOver() -> Bool {
		guard grid.tiles.allSatisfy({ $0.value != 0}) else { return false }
		
		for row in 0..<grid.rows - 1 {
			for column in 0..<grid.columns {
				print("first check: \(grid[row, column].value), \(grid[row + 1, column].value)")
				if grid[row, column].value == grid[row + 1, column].value {
					return false
				}
			}
		}
		
		for row in 0..<grid.rows {
			for column in 0..<grid.columns - 1 {
				print("second check: \(grid[row, column].value), \(grid[row, column + 1].value)")
				if grid[row, column].value == grid[row, column + 1].value {
					return false
				}
			}
		}
		return true
	}
	
	func startNewGame() {
		grid = Grid()
		score = 0
		addNewNumber()
		addNewNumber()
		isAlertUserWonShown = false
		isAlertGameOverShown = false
	}
	
	func updateAndSaveBestScore() {
		if score > bestScore {
			bestScore = score
			do {
				let data = try JSONEncoder().encode(score)
				try data.write(to: savePath, options: [.atomic, .completeFileProtection])
			} catch {
				print("Unable to save data")
			}
		}
	}
	
	
}


enum Directions {
	case up
	case down
	case right
	case left
}
