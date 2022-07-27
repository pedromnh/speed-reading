//
//  ContentView.swift
//  Skim
//
//  Created by Pedro Henriques on 27/07/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ForEach(ColorScheme.allCases, id: \.self) {
                 ContentView().preferredColorScheme($0)
            }
        }
}
