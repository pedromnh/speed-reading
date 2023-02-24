//
//  ContentView.swift
//  Skim
//
//  Created by Pedro Henriques on 27/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var phrase = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ultricies augue quis lectus facilisis posuere. Quisque vel tempus ante. Vivamus molestie arcu vitae lacus pharetra pharetra. Sed nec ligula sit amet purus consequat mollis. Duis tristique massa sed vestibulum tincidunt. Fusce ultricies, neque id tincidunt consequat, velit sapien malesuada mi, in vulputate nulla tellus vitae elit. Pellentesque scelerisque vitae justo sed volutpat. Duis sodales dictum eleifend. Nunc a massa dictum, vulputate urna non, porttitor magna. Fusce convallis quam sed hendrerit viverra. Mauris hendrerit urna ac fringilla aliquet. Aenean lacinia viverra efficitur. Ut sollicitudin, purus ac fermentum tincidunt, urna turpis condimentum orci, eget dictum quam sapien euismod risus."
    
    
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
