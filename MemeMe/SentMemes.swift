//
//  SentMemes.swift
//  MemeMe
//
//  Created by Chi Zhang on 10/23/15.
//  Copyright © 2015 cz. All rights reserved.
//

import UIKit

// Singleton object to keep saved/sent memes
class SentMemes: NSObject {
    
    // define static Class variable
    static let sharedInstance = SentMemes()
    
    // Memes is an array of Meme struct keeping sent memes
    private var Memes: [Meme]
    
    // Initialize the single object
    private override init(){
        Memes = [Meme]()
        super.init()
    }
    
    // get all Memes
    func getMemes() -> [Meme] {
        return Memes
    }
    
    // add new Meme at index
    func addMeme(meme: Meme, index: Int) {
        if (Memes.count >= index) {
            Memes.insert(meme, atIndex: index)
        } else {
            Memes.append(meme)
        }
    }
    
    // append new Meme at the end
    func appendMeme(meme: Meme) {
        Memes.append(meme)
    }
    
    // delete Meme at index
    func deleteMemeAtIndex(index: Int) {
        Memes.removeAtIndex(index)
    }
    
    // retreive meme at index
    func memeAtIndex(index: Int) -> Meme {
        return Memes[index]
    }
    
    // return total number of sent memes
    func numberOfMemes() -> Int {
        return Memes.count
    }
    
}
