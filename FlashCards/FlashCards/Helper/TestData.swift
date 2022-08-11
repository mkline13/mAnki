//
//  TestData.swift
//  FlashCards
//
//  Created by Work on 8/11/22.
//


func loadTestData(flashCardService: FlashCardService) {
    loadGeneralTestData(flashCardService: flashCardService)
}

private func loadGeneralTestData(flashCardService: FlashCardService) {
    // Packs
    let japaneseVerbsPack = flashCardService.newContentPack(title: "Japanese Verbs", description: "日本語の動詞", author: "メイセン")!
    let japanesePhrasesPack = flashCardService.newContentPack(title: "Japanese Phrases", description: "日本語のフレーズ", author: "メイセン")!
    let organsPack = flashCardService.newContentPack(title: "Organs and Other Body Parts", description: "What is the liver", author: "Mason")!
    
    // Decks
    let japaneseDeck = flashCardService.newDeck(title: "Japanese", description: "今日はマザーファッカー", newCardsPerDay: 10, reviewCardsPerDay: 20)!
    flashCardService.set(contentPacks: [japaneseVerbsPack, japanesePhrasesPack], for: japaneseDeck)
    
    let medDeck = flashCardService.newDeck(title: "Med School", description: "I'm gonna be a Dr.", newCardsPerDay: 20, reviewCardsPerDay: 100)!
    flashCardService.set(contentPacks: [organsPack], for: medDeck)
    
    // Cards
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "歩く", backContent: "to walk", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "泳ぐ", backContent: "to swim", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "喧嘩する", backContent: "to fight", deck: japaneseDeck)
    
    _ = flashCardService.newCard(in: japanesePhrasesPack, frontContent: "喧嘩が強い", backContent: "good at fighting", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japanesePhrasesPack, frontContent: "雨がふうた", backContent: "it rained", deck: japaneseDeck)
    
    _ = flashCardService.newCard(in: organsPack, frontContent: "Liver", backContent: "it's guts", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Heart", backContent: "more guts", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Pancreas", backContent: "never heard of it but it's probably guts", deck: medDeck)
}
