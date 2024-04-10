//
//  Tile.swift
//  Game2048
//
//  Created by Margarita Mayer on 06/04/24.
//

import Foundation

struct Tile: Identifiable, Equatable, Hashable {
	let id = UUID()
	var value: Int
}
