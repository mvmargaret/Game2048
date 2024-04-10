//
//  TileView.swift
//  Game2048
//
//  Created by Margarita Mayer on 06/04/24.
//

import SwiftUI

struct TileView: View {
	let value: Int
	
	var body: some View {
		if value != 0 {
			Text("\(value)")
				.frame(width: Constants.cellSize, height: Constants.cellSize)
				.background(setColor(value: value))
				.cornerRadius(Constants.cornerRadius)
				.font(.title)
		} else {
			RoundedRectangle(cornerRadius: Constants.cornerRadius)
				.fill(Color.offWhite.opacity(0))
				.frame(width: Constants.cellSize, height: Constants.cellSize)
		}
	}
	
	func setColor(value: Int) -> Color {
		switch value {
		case 2:
			return Color.white
		case 4:
			return Color.lightSand
		case 8:
			return Color.lightPurple
		case 16:
			return Color.lightPink
		case 32:
			return Color.lightMint
		case 64:
			return Color.lightBlue
		case 128:
			return Color.grayBlue
		case 256:
			return Color.mediumPurple
		case 512:
			return Color.mediumOrange
		case 1024:
			return Color.brightPurple
		case 2048:
			return Color.brightBlue
		default:
			return Color.brightPink
			
		}
	}
}

#Preview {
	TileView(value: 8)
}
