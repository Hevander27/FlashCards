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
                 CardView(card: cards[index], onSwipedLeft: { // <-- Add swiped left property
                     let removedCard = cards.remove(at: index) // <-- Remove the card from the cards array
                     cardsToPractice.append(removedCard)
                     
                 }, onSwipedRight: { // <-- Add swiped right property
                     let removedCard = cards.remove(at: index)
                     cardsMemorized.append(removedCard) // <-- Remove the card from the cards array
                 })
                   .rotationEffect(.degrees(Double(cards.count - 1 - index) * -5))
             }

             .animation(.bouncy, value: cards)
             .font(.title)
             .foregroundStyle(.white)
             .padding()
            
        }      
        .frame(maxWidth: .infinity, maxHeight: .infinity) // <-- Force the ZStack frame to expand as much as possible (the whole screen in this case)
        .overlay(alignment: .topTrailing) { // <-- Add an overlay modifier with top trailing alignment for its contents
            Button("Add Flashcard", systemImage: "plus") {  // <-- Add a button to add a flashcard
                createCardViewPresented.toggle() // <-- Toggle the createCardViewPresented value to trigger the sheet to show
            }
        }
        .id(deckId)
        .sheet(isPresented: $createCardViewPresented, content: {
            CreateFlashcardView { card in
                cards.append(card)
            }
        })
        
        
    }
    
    
    
}

// Preview the ContentView in the canvas
#Preview {
    ContentView()
}
