//
//  SettingsPopupView.swift
//  Skim
//
//  Created by Pedro Henriques on 04/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var wpm: Double
    @Binding var isShowingSettings: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowingSettings = false
                }

            VStack {
                Text("Adjust Reading Speed")
                    .font(.headline)
                    .padding(.top)
                    .foregroundColor(Color.black)

                Slider(value: $wpm, in: 50...1000, step: 50)
                    .padding()
                    .accentColor(Color.black)
                    .tint(Color.black)

                Text("Words Per Minute: \(Int(wpm))")
                    .font(.subheadline)
                    .padding(.bottom)
                    .foregroundColor(Color.black)

                Button(action: {
                    isShowingSettings = false
                }) {
                    Text("Close")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .frame(width: 300, height: 300)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
}
struct SettingsPopupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(wpm: .constant(300), isShowingSettings: .constant(true))
                .preferredColorScheme(.light)
            SettingsView(wpm: .constant(300), isShowingSettings: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}
