//
//  ContentView.swift
//  Flag Quiz
//
//  Created by Jesutofunmi Adewole on 12/02/2024.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.rect(cornerRadius: 5))
    }
}

struct Watermark: ViewModifier {
    var text: String
    var background: Color

    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(background)
        }
    }
}

extension View {
    func watermarked(with text: String, background color: Color) -> some View {
        modifier(Watermark(text: text, background: color))
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "Monaco", "Russia", "UK", "US"]
    
    @State private var correctAnswer = Int.random(in: 0..<3)
    @State private var alertTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    @State private var gameOverTitle = ""
    @State private var alertMessage = ""
    
    @State private var alertShowing = false
    @State private var gameOverShowing = false
    @State private var flagTapped = ""
    @State private var opacity = 1.0
    @State private var showCorrect = false
    @State private var showWrong = false
    @State private var correctColor = Color.clear
    @State private var wrongColor = Color.clear
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0.9, green: 0.4, blue: 0.2), location: 0.3),
                    .init(color: Color(red: 0.3, green: 0.1, blue: 0.4), location: 0.3)
                ], center: .bottom, startRadius: 300, endRadius: 400)
                
                VStack {
                    Spacer()
                    Spacer()
                    Text("Play Flag Game")
                        .font(.title.weight(.heavy))
                        .foregroundColor(.white)
                    VStack(spacing: 30) {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.light))
                                .foregroundStyle(.white)
                        }
                        .padding()
                        
                        ForEach(0..<3) { number in
                            ZStack {
                                Button {
                                    withAnimation() {
                                        flagAnswer(number)
                                        flagTapped = countries[number]
                                        opacity = 0.25
                                        showCorrect = true
                                        correctColor = .green
                                        wrongColor = .red
                                    }
                                } label: {
                                    FlagImage(imageName: countries[number])
                                }
                                .watermarked(with: flagTapped == countries[number] && showWrong ? "Wrong Answer": "", background: wrongColor)
                                .watermarked(with: correctAnswer == number && showCorrect ? "Correct Answer" : "", background: correctColor)
                                
                                .shadow(radius: 50)
                                .overlay(
                                    Rectangle()
                                        .stroke(correctAnswer == number ? correctColor : wrongColor, lineWidth: 4)
                                        .clipShape(.rect(cornerRadius: 5))
                                )
                                .rotation3DEffect(.degrees(flagTapped == countries[number] ? 360 : 0), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                                .opacity(flagTapped == countries[number] || correctAnswer == number ? 1 : opacity)
                            }
                            .animation(.interpolatingSpring(duration: 1, bounce: 0.9), value: wrongColor)
                        }
                        
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 50)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding()
                    Text("Score: \(score)")
                        .font(.title.weight(.bold))
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            //        .alert(alertTitle, isPresented: $alertShowing) {
            //            Button ("Continue") {
            //                newQuestion()
            //            }
            //        } message: {
            //            Text(alertMessage)
            //        }
            .alert(gameOverTitle,isPresented: $gameOverShowing) {
                Button ("End Game") { }
                Button ("Replay") {
                    questionCount = 0
                    score = 0
                    newQuestion()
                }
            } message: {
                Text("Total Score: \(score)")
            }
            .toolbar {
                Button ("Next") {
                    newQuestion()
                }
                .foregroundStyle(.white)
            }
        }
    }
    
    func flagAnswer(_ number: Int) {
        if correctAnswer == number {
            alertTitle = "Correct"
            alertMessage = "You're correct, that's the flag of \(countries[correctAnswer])"
            score += 1
        } else {
            alertTitle = "Wrong"
            alertMessage = "That's the flag of \(countries[number])"
            showWrong = true
        }
        alertShowing = true
        questionCount += 1
    }
    
    func newQuestion() {
        if questionCount < 5 {
            countries.shuffle()
            correctAnswer = Int.random(in: 0..<3)
        } else {
            gameOverTitle = "Game Over"
            gameOverShowing = true
        }
        opacity = 1.0
        correctColor = .clear
        wrongColor = .clear
        showCorrect = false
        showWrong = false
    }

}

#Preview {
    ContentView()
}
