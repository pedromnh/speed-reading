//
//  ContentView.swift
//  Skim
//
//  Created by Pedro Henriques on 27/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var phrase = "As @Paul and @John have suggested, you can use a Timer to do this. However, if the code does need to be asynchronous for some reason, you can reimplement the loop asynchronously by making it recursive:"
    
    
    var body: some View {
        VStack {
            Button(
                action: {readString(sentence: phrase, wpm: 0.1)},
                label: {Text("Click me!")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
            })
        }
    }
    
}


func readString(sentence: String, wpm: Double) {
    let words = sentence.components(separatedBy: " ")
    
    var i = 0
    _ = Timer.scheduledTimer(withTimeInterval: wpm, repeats: true) { t in
        print(words[i]);
        i += 1;
        if i >= words.count {
            t.invalidate();
        }
    }
}

func calculateWpmSpeed(wpm: Double) -> Double {
    let wordsPerSecond = wpm / 60
    return 1 / wordsPerSecond
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ForEach(ColorScheme.allCases, id: \.self) {
                 ContentView().preferredColorScheme($0)
            }
        }
}
