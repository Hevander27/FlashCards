//
//  ContentView.swift
//  Flashcard
//
//  Created by Admin on 3/16/24.
//

import SwiftUI

// Define the ContentView structure, which conforms to the View protocol
struct ContentView: View {
    // Define the body property, required by the View protocol
    // Return any object that conforms to the View protocol
    
    @State private var cards: [Card] = Card.mockedCards
    
    @State private var cardsToPractice: [Card] = [] // <-- Store cards removed from cards array
    @State private var cardsMemorized: [Card] = [] // <--
    @State private var createCardViewPresented = false
    @State private var deckId: Int = 0
    
    var body: some View {
        // Vertical stack (VStack) to arrange views vertically
        // Card text
        ZStack {

            // Reset buttons
            VStack { // <-- VStack to show buttons arranged vertically behind the cards
               Button("Reset") { // <-- Reset button with title and action
                   cards = cardsToPractice + cardsMemorized // <-- Reset the cards array with cardsToPractice and cardsMemorized
                   cardsToPractice = [] // <-- set both cardsToPractice and cardsMemorized to empty after reset
                   cardsMemorized = [] // <--
                   deckId += 1 // <-- Increment the deck id
               }
               .disabled(cardsToPractice.isEmpty && cardsMemorized.isEmpty)

               Button("More Practice") { // <-- More Practice button with title and action
                   cards = cardsToPractice // <-- Reset the cards array with cardsToPractice
                   cardsToPractice = [] // <-- Set cardsToPractice to empty after reset
                   deckId += 1 // <-- Increment the deck id

               }
               .disabled(cardsToPractice.isEmpty)
           }

           // Cards
            
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(card: cards[index])
                    .rotationEffect(.degrees(Double(cards.count - 1 - index) * -5))
                CardView(card: cards[index], onSwipedLeft: { // <-- Add swiped left property
                    let removedCard = cards.remove(at: index) // <-- Remove the card from the cards array
                    cardsToPractice.append(removedCard)
                }, onSwipedRight: { // <-- Add swiped right property
                    let removedCard = cards.remove(at: index)
                    cards.remove(at: index) // <-- Remove the card from the cards array
                })
            }
            
            // Card background
            RoundedRectangle(cornerRadius: 25.0)
            
                .fill(Color.blue)
                .shadow(color: .black, radius: 4, x: -2, y: 2)

            // Card text
            VStack(spacing: 20) {

                // Card type (question vs answer)
                Text("Question")
                    .bold()

                // Separator
                Rectangle()
                    .frame(height: 1)
                
                // Card text
                Text("Located at the southern end of Puget Sound, what is the capitol of Washington?")
            }
            .animation(.bouncy, value: cards)
            .font(.title)
            .foregroundStyle(.white)
            .padding()
            .id(deckId)
            .sheet(isPresented: $createCardViewPresented, content: {
                CreateFlashcardView { card in
                    cards.append(card)
                }
            })

        }
        .frame(width: 300, height: 500)
        

    }
    
    
}

// Preview the ContentView in the canvas
#Preview {
    ContentView()
}
