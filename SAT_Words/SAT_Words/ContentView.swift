//
//  ContentView.swift
//  SAT_Words
//
//  Created by Naomi H on 4/17/24.
//

import SwiftUI

struct WordMemorizationCard: View {
    // Properties for the English word and its meaning
    let word: String
    let meaning: String
    let onNext: () -> Void  // A closure that will be called when moving to the next card
    let onPrevious: () -> Void // A closure that will be called when moving to the previous card
    
    // State variable to track whether the card is flipped
    @State private var isFlipped: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var offsetWhenGestureStarted: CGSize = .zero
    
    var body: some View {
        VStack {
            // Display either the word or meaning based on the flip state
            if isFlipped {
                Text(meaning)
                    .font(.body)
                    .padding()
            } else {
                Text(word)
                    .font(.title)
                    .padding()
            }
        }
        .frame(width: 300, height: 150)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        // Use DragGesture for swipe interaction
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Update drag offset only when gesture starts
                    if offsetWhenGestureStarted == .zero {
                        offsetWhenGestureStarted = dragOffset
                    }
                    dragOffset = CGSize(width: value.translation.width + offsetWhenGestureStarted.width, height: 0)
                }
                .onEnded { value in
                    if dragOffset.width < -100 {
                        // Swiped left , move to the next card
                        onNext()
                    } else if dragOffset.width > 100 {
                        // Swiped right, move to the previous card
                        onPrevious()
                    }
                    // Reset drag offset and offsetWhenGestureStarted
                    dragOffset = .zero
                    offsetWhenGestureStarted = .zero
                }
        )
        // Apply rotation and offset based on drag offset
        .rotationEffect(.degrees(Double(dragOffset.width) / 20))
        .offset(x: dragOffset.width, y: 0)
        // Flip the card on tap
        .onTapGesture {
            withAnimation {
                isFlipped.toggle()
            }
        }
    }
}


struct WordCardsView: View {
    // Define the list of words and meanings
    let cards: [(word: String, meaning: String)] = [
        ("Aberration", "A departure from what is normal"),
        ("Benevolent", "Well-meaning and kindly"),
        ("Capricious", "Given to sudden and unaccountable changes of mood or behavior"),
        ("Deleterious", "Causing harm or damage"),
        ("Ephemeral", "Lasting for a very short time"),
        ("Intrepid", "Fearless; adventurous"),
        ("Mundane", "Lacking interest or excitement; dull; ordinary"),
        ("Ostentatious", "Characterized by vulgar or pretentious display; designed to impress or attract notice"),
        ("Pragmatic", "Dealing with things sensibly and realistically in a way that is based on practical rather than theoretical considerations"),
        ("Superfluous", "Unnecessary, especially through being more than enough")
    ]
    
    // State variable to track the current card index
    @State private var currentCardIndex = 0
    
    var body: some View {
        VStack() {
            // Display the current card
            WordMemorizationCard(
                word: cards[currentCardIndex].word,
                meaning: cards[currentCardIndex].meaning,
                onNext: moveToNextCard, // Pass a function to handle moving to the next card
                onPrevious: moveToPreviousCard // Pass a function to handle moving to the previous card
            )
            
            
            // Display the current card index and total number of cards
            Text("Card \(currentCardIndex + 1) of \(cards.count)")
                .padding(.top, 15)
                .padding(.bottom, 50)
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Tap on the card to show the meaning.")
                        .foregroundColor(.gray)
                        .italic()
                    Text("Swipe left to go to the next card.")
                        .foregroundColor(.gray)
                        .italic()
                    Text("Swipe right to go back to the previous card.")
                        .foregroundColor(.gray)
                        .italic()
                }
            }
        }
    }
    
    // Function to move to the next card
    func moveToNextCard() {
        // Move to the next card when the function is called
        if currentCardIndex < cards.count - 1 {
            currentCardIndex += 1
        } else {
            // Optionally, you can reset to the first card when the last card is reached
            currentCardIndex = 0
        }
    }
    
    // Function to move to the previous card
    func moveToPreviousCard() {
        // Move to the previous card when the function is called
        if currentCardIndex > 0 {
            currentCardIndex -= 1
        } else {
            // Optionally, you can loop back to the last card when the first card is reached
            currentCardIndex = cards.count - 1
        }
    }
}

struct ContentView: View {
    var body: some View {
        WordCardsView()
    }
}

#Preview {
    ContentView()
    // EnglishMemorizationCard(word: "Apple", meaning: "Fruit")
}
