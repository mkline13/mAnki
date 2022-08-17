//
//  TestData.swift
//  FlashCards
//
//  Created by Work on 8/11/22.
//


private func loadGeneralTestData(flashCardService: FlashCardService) {
    print("Loading general testing data...")
    
    // Packs
    let japaneseVerbsPack = flashCardService.newContentPack(title: "Japanese Verbs", description: "日本語の動詞", author: "メイセン")!
    let japanesePhrasesPack = flashCardService.newContentPack(title: "Japanese Phrases", description: "日本語のフレーズ", author: "メイセン")!
    let organsPack = flashCardService.newContentPack(title: "Organs and Other Body Parts", description: "What is the liver", author: "Mason")!
    
    // Decks
    let japaneseDeck = flashCardService.newDeck(title: "Japanese", description: "今日はマザーファッカー", newCardsPerDay: 3, reviewCardsPerDay: 10)!
    flashCardService.set(contentPacks: [japaneseVerbsPack, japanesePhrasesPack], for: japaneseDeck)
    
    let medDeck = flashCardService.newDeck(title: "Med School", description: "I'm gonna be a Dr.", newCardsPerDay: 5, reviewCardsPerDay: 12)!
    flashCardService.set(contentPacks: [organsPack], for: medDeck)
    
    // Cards
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "歩く", backContent: "to walk", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "泳ぐ", backContent: "to swim", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "喧嘩する", backContent: "to fight", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "上る", backContent: "to climb", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "上げる", backContent: "to give", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "入れる", backContent: "to add / put into", deck: nil)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "入る", backContent: "to enter", deck: nil)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "なくなる", backContent: "to disappear", deck: nil)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "つける", backContent: "to attach", deck: nil)
    _ = flashCardService.newCard(in: japaneseVerbsPack, frontContent: "助かる", backContent: "to be saved/helped/spared", deck: nil)
    
    _ = flashCardService.newCard(in: japanesePhrasesPack, frontContent: "喧嘩が強い", backContent: "good at fighting", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japanesePhrasesPack, frontContent: "雨がふうた", backContent: "it rained", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japanesePhrasesPack, frontContent: "おはようございます", backContent: "good morning", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japanesePhrasesPack, frontContent: "ピアノが弾けるようになりたい", backContent: "I want to be able to play the piano", deck: japaneseDeck)
    _ = flashCardService.newCard(in: japanesePhrasesPack, frontContent: "どの果物が好きですか", backContent: "which fruit do you like?", deck: nil)
    
    _ = flashCardService.newCard(in: organsPack, frontContent: "Liver", backContent: "it's guts", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Heart", backContent: "more guts", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Pancreas", backContent: "never heard of it but it's probably guts", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Skin", backContent: "meat wrapper", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Pelvis", backContent: "bone", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Elbow", backContent: "arm knee", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Spleen", backContent: "who cares", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Gall Bladder", backContent: "CONTAINS GALL", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Colon", backContent: "colon powell", deck: medDeck)
    _ = flashCardService.newCard(in: organsPack, frontContent: "Lung", backContent: "hhhhhhhhh", deck: medDeck)
}


private func loadDataForDeletionTests(flashCardService: FlashCardService) {
    let deck = flashCardService.newDeck(title: "TeskDeck", description: "Delete Me Deck", newCardsPerDay: 20, reviewCardsPerDay: 30)
    let pack = flashCardService.newContentPack(title: "TestContentPack", description: "Delete Me Pack", author: "Me")
//    let _ = flashCardService.newCard(in: pack!, frontContent: "Front of the card to be deleted", backContent: "Back of that same card", deck: deck)
}

typealias TestDataLoader = (FlashCardService) -> Void

let testDataLoaders: [String: TestDataLoader] = [
    "loadGeneralTestData": loadGeneralTestData,
    "loadDataForDeletionTests": loadDataForDeletionTests
]
