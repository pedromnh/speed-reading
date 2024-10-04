//
//  ContentView.swift
//  Skim
//
//  Created by Pedro Henriques on 27/07/2022.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var wpm = 750.0
    @State private var minWpm = 0
    @State private var maxWpm = 1500
    @State private var isShowingReadingView = false
    
    
    //The Original page
    var body: some View {
        NavigationView {
        VStack {
            NavigationLink("View Saved Articles", destination: ArticleListView())
                            .padding()
            HStack {
//                Button(
//                    action: {isUrl(text: pasteText()!)},
//                    label: {Text("Test Button")
//                            .fontWeight(.heavy)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(15)
//                })
                Button(
                    action: {isShowingReadingView = true},
                    label: {Text("Test Button")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                })
                Button(
                    action: {whatToPrint(isUrl: isUrl(text: pasteText()!), sentence: pasteText()!, wpm: wpm); isShowingReadingView = true},
                    label: {Text("+")
                            .fontWeight(.heavy)
                            .padding()
                            .background(colorScheme == .dark ? Color.white : Color.black)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                            .clipShape(Circle())
                })
            }.navigationTitle("Skim")
            
            
            
            VStack(spacing: 0) {
//                Text("WPM: \(Int(wpm))").frame(alignment: .center)
                HStack(spacing: 0) {
                    TextField("WPM: \(Int(wpm))", text: Binding(get: {
                        String(Int(wpm))
                    }, set: { newValue in
                        if let value = Double(newValue), (minWpm...maxWpm).contains(Int(value)) {
                            wpm = value
                        }
                    }))
                    .keyboardType(.numberPad)
                    .frame(alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(Font.italic(.body)())
                    .onTapGesture {
                        wpm = 0
                    }
                }.frame(alignment: .center)
                
                Slider(value: $wpm, in: Double(minWpm)...Double(maxWpm)) {
                } minimumValueLabel: {
//                    Text("\(minWpm)")
                } maximumValueLabel: {
//                    Text("\(maxWpm)")
                }.accentColor(colorScheme == .dark ? Color.white : Color.black)
                    .padding(.horizontal)
                    .scaleEffect(x: 1.0, y: 0.3, anchor: .center)
                    .background(
                        Capsule()
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                            .frame(height: 8))
            }
            
            
        }.padding()
    }
    }
    
}


func readString(sentence: String, wpm: Double) {
    let words = sentence.components(separatedBy: " ")
    
    print(sentence)
    
    var i = 0
    _ = Timer.scheduledTimer(withTimeInterval: wpm, repeats: true) { t in
        print(words[i]);
        i += 1;
        if i >= words.count {
            t.invalidate();
        }
    }
}


func getTextFromUrl(urlToRead: String) -> (String, String) {
    if let url = URL(string: urlToRead) {
        do {
            let contentOfURL = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(contentOfURL)
            
            // Extract the first header
            let title: String
            if let header = try? doc.select("h1, h2").first() {
                title = try header.text() ?? "No Title Found"
            } else {
                title = "No Title Found"
            }
            
            let bodyText = try doc.text()
            return (title, bodyText)
        } catch {
            print("Error: \(error)")
            return ("Error", "Error: \(error)")
        }
    } else {
        print("Invalid URL")
        return ("Invalid URL", "Error: Invalid URL")
    }
}



func readStringFromUrl(urlToRead: String, wpm: Double) {
    Task.init() {
        if let url = URL(string: urlToRead) {
            do {
                let contentOfURL = try String (contentsOf: url)
                
                do{
                    let html = contentOfURL
                    let doc: Document = try SwiftSoup.parse(html)
//                    try print(doc.text())
                    
//                    Gotta cut the sentence into an array of strings of single words
                    try readString(sentence: doc.text(), wpm: 50)
                }catch Exception.Error(_, _)
                {
                    print("")
                }catch{
                    print("")
                }
            }
        }
            
    }
    
//    do{
//       let html = "<html><head><title>First parse</title></head>"
//                + "<body><p>Parsed HTML into a doc.</p></body></html>"
//       let doc: Document = try SwiftSoup.parse(html)
//       try print(doc.text())
//    }catch Exception.Error(_, _)
//    {
//        print("")
//    }catch{
//        print("")
//    }
}

func wpmSpeed(wpm: Double) -> Double {
    return 1 / (wpm / 60)
}

func pasteText() -> String? {
    weak var pb: UIPasteboard? = .general
    guard let text = pb?.string else { return nil }
    
    let cleanedText = text.replacingOccurrences(of: "[\\n\\s]+", with: " ", options: .regularExpression)
    return cleanedText
}


func isUrl(text: String) -> Bool {
    return text.hasPrefix("http") || text.hasPrefix("www")
}


//func whatToPrint(isUrl: Bool, sentence: String, wpm: Double) {
//    if isUrl {
//        readString(sentence: getTextFromUrl(urlToRead: pasteText() ?? "Error pasting"), wpm: wpmSpeed(wpm: wpm))
//    } else{
//        readString(sentence: pasteText() ?? "Error", wpm: wpmSpeed(wpm: wpm))
//    }
//}

func whatToPrint(isUrl: Bool, sentence: String, wpm: Double) {
    let contentAndTitle: (title: String, body: String)
    
    if isUrl {
        contentAndTitle = getTextFromUrl(urlToRead: pasteText() ?? "Error pasting")
    } else {
        contentAndTitle = ("Pasted Text", pasteText() ?? "Error")
    }
    
    let (title, body) = contentAndTitle
    
    let newArticle = Article(title: title, body: body)
    
    var articles = FileStorageManager.shared.loadArticles()
    
    articles.append(newArticle)
    
    FileStorageManager.shared.saveArticles(articles)
    
    readString(sentence: body, wpm: wpmSpeed(wpm: wpm))
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ForEach(ColorScheme.allCases, id: \.self) {
                 ContentView().preferredColorScheme($0)
            }
        }
}
