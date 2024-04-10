//
//  ScoreStyleModifier.swift
//  Game2048
//
//  Created by Margarita Mayer on 10/04/24.
//

import Foundation
import SwiftUI

struct ScoreStyleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(.all, 7)
			.background(Color.mediumPurple.opacity(0.8))
			.clipShape(.rect(cornerRadius: Constants.cornerRadius))
			.foregroundStyle(.white)
			.bold()
			.animation(nil)
	}
	
	
}
