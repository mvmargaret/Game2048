//
//  ContentView.swift
//  Game2048
//
//  Created by Margarita Mayer on 06/04/24.
//

import SwiftUI

struct ContentView: View {
	
	@State private var viewModel = ViewModel()
	
	var body: some View {
		VStack {
			gameLabel
			
			Spacer()
			
			scorePanels
			
			ZStack {
				backgroundGrid
				
				grid
					.onAppear {
						viewModel.addNewNumber()
						viewModel.addNewNumber()
					}
			}
			.gesture(
				DragGesture(minimumDistance: Constants.minimumDistance, coordinateSpace: .global)
					.onEnded { value in
						viewModel.handleGestures(value: value)
					}
			)
			Spacer()
			Spacer()
			
			buttonNewGame

		}
		.alert("Игра закончена!", isPresented: $viewModel.isGameOver) {
			Button("OK") {
				viewModel.isAlertGameOverShown = true
			}
		} message: {
			Text("Ваши очки: \(viewModel.score)")
		}
		.alert("Вы выиграли!", isPresented: $viewModel.isGameWon) {
			Button("OK") {
				viewModel.isAlertUserWonShown = true
			}
		} message: {
			Text("Ваши очки: \(viewModel.score)")
		}
	}
	
	
	
	private var backgroundGrid: some View {
		Rectangle()
			.fill(Color.lightGray)
			.frame(width: Constants.backgroundSize, height: Constants.backgroundSize)
			.cornerRadius(Constants.cornerRadius)
			.overlay(
				HStack {
					LazyVGrid(columns: Array(repeating: GridItem(.fixed(Constants.cellSize), spacing: Constants.spacing), count: Constants.count), spacing: Constants.spacing, content: {
						ForEach(0..<16, id: \.self) { _ in
							RoundedRectangle(cornerRadius: Constants.cornerRadius)
								.fill(Color.offWhite)
								.frame(width: Constants.cellSize, height: Constants.cellSize)
						}
					})
				}
			)
	}
	
	private var grid: some View {
		LazyVGrid(columns: Array(repeating: GridItem(.fixed(Constants.cellSize), spacing: Constants.spacing), count: Constants.count), spacing: Constants.spacing, content: {
			ForEach(viewModel.grid.tiles, id: \.id) { tile in
				TileView(value: tile.value)
					.transition(.opacity)
			}
			
		})
	}
	
	private var scorePanels: some View {
		HStack {
			VStack {
				Text("Счет")
					.font(.title3)
				Text("\(viewModel.score)")
					.font(.title)
			}
			.containerRelativeFrame(.horizontal, count: 4, span: 1, spacing: 2.0)
			.scoreStyle()
			
			Spacer()
			
			VStack {
				Text("Лучший счет")
					.font(.title3)
				Text("\(viewModel.bestScore)")
					.font(.title)
			}
			.containerRelativeFrame(.horizontal, count: 4, span: 2, spacing: 2.0)
			.scoreStyle()
		}
		.padding(.horizontal)
		.padding(.bottom)
		
	}
	
	private var gameLabel: some View {
		Text("2048")
			.font(.largeTitle)
			.foregroundStyle(Color.mediumPurple)
			.bold()
			.padding()
	}
	
	private var buttonNewGame: some View {
		Button("Новая игра", action: viewModel.startNewGame)
			.buttonBorderShape(.roundedRectangle(radius: Constants.cornerRadius))
			.buttonStyle(.borderedProminent)
			.tint(.indigo)
			.bold()
			.controlSize(.large)
	}
	
}

#Preview {
    ContentView()
}
