//
//  SettingsView.swift
//  Skim
//
//  Created by Pedro Henriques on 04/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var wpm: Double

    var body: some View {
        VStack {
            Text("Reading Speed")
                .font(.headline)
                .padding(.top)

            Slider(value: $wpm, in: 50...1000, step: 50) {
                Text("WPM: \(Int(wpm))")
            }
            .padding()

            Text("Words Per Minute: \(Int(wpm))")
                .font(.subheadline)
                .padding(.bottom)

            Spacer()
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(wpm: .constant(300))
    }
}
