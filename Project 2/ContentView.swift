//
//  ContentView.swift
//  Project 2
//
//  Created by Friedrich Vorländer on 09.03.24.
//

import SwiftUI

struct FlagImage : View{
    var number : Int
    var countries = [String]()
    
    var body: some View{
            Image(countries[number])
                .clipShape(.buttonBorder)
                .shadow(radius: 20)
                .tint(.red)
    }
}
struct TitleModifier : ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
    }
}

extension View {
    func titleModifier() -> some View{
        modifier(TitleModifier())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var HighScore = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameWon = false
    @State private var animationAmounts = Array(repeating: 0.0, count: 3)
    @State private var guessed = false
    
    var body: some View {
        ZStack(alignment: .top){
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.3, green: 0.1, blue: 0.5), location: 0.1),
                .init(color: .purple, location: 0.1),
            ], center: .bottom, startRadius: 550, endRadius: 360)
                .ignoresSafeArea()
            VStack{
                VStack(spacing: 50){
                    Spacer()
                    Text("Guess the flag")
                        .titleModifier()

                    VStack(spacing: 10){
                        
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.semibold))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                }
                        
                    VStack(spacing: 50){
                            ForEach(0..<3) { number in
                                Button {
                                    withAnimation {
                                        self.animationAmounts[number] += 180
                                        guessed = true
                                    }
                                    flagTapped(number)
                                    
                                }label: {
                                    FlagImage(number: number, countries: countries)
                                        .opacity(guessed == true && number != correctAnswer ? 0.75 : 1)
                                        .animation(.easeIn, value: animationAmounts[number])
                                }
                                
                                .rotation3DEffect(.degrees(animationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                                .animation(.linear, value: animationAmounts[number])
                                .alert(scoreTitle, isPresented: $showingScore){
                                    Button("Continue", action: askQuestion)
                                } message: {
                                    Text("Score: \(HighScore)")
                                }
                                .alert("You Win!", isPresented: $gameWon){
                                    Button("Continue", action: askQuestion)
                                } message:{
                                    Text("You Won with: \(HighScore)")
                                }
                                
                            }
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding(50)
                
            }
        }
    }
    func flagTapped(_ number: Int){
        showingScore = true
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
            HighScore = score
            
            
        } else{
            scoreTitle = "Wrong, it's the \(correctAnswer + 1). one"
            HighScore = score
            score = 0
        }
        if score == 8{
            showingScore = false
            resetGame()
            gameWon = true
        }
        
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmounts = [0.0, 0.0, 0.0]
        guessed = false
    }
    func resetGame(){
        score = 0
        askQuestion()
        gameWon = false
    }
        
}

#Preview {
    ContentView()
}
