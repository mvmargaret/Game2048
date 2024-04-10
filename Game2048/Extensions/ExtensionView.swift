//
//  ExtensionView.swift
//  Game2048
//
//  Created by Margarita Mayer on 10/04/24.
//

import Foundation
import SwiftUI

extension View {
	func scoreStyle() -> some View {
		modifier(ScoreStyleModifier())
	}
}
