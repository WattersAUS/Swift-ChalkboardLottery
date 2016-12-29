//
//  LotteryJsonHandler.swift
//  ChalkboardLottery
//
//  Created by Graham on 29/12/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// this class defines the 'protocol' used to allow the settings dialog to
// delegate the responsibility of keeping the defaults updated and including
// ensuring they are updated
//----------------------------------------------------------------------------

import Foundation

protocol LotteryDrawDelegate: class {
    // game stats
    var loadedDraws: [LotteryDraw] { get set }
}

class LotteryDrawHandler: NSObject, LotteryDrawDelegate {

    private var lotteryDraws: [String: AnyObject]!
    internal var loadedDraws: [LotteryDraw] = []
    
    override init() {
        super.init()
        self.lotteryDraws = [:]
        return
    }
    
    func getLotteryResults() {
        let filename: String = "testFilegoes here"
        do {
            let fileContents: String = try NSString(contentsOfFile: filename, usedEncoding: nil) as String
            let fileData: Data = fileContents.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            self.lotteryDraws = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
        } catch {
            print("Failed to read to file: \(filename)")
        }
        return
    }
    
    //-------------------------------------------------------------------------------
    // pick out the dictionary 'keys/value' when we load the results
    // if we don't yet have a value return a default
    //-------------------------------------------------------------------------------
    private func getLotteryStateValue(keyValue: lotteryDictionary) -> Int {
        return (self.lotteryDraws.index(forKey: keyValue.rawValue) == nil) ? 0 : self.lotteryDraws[keyValue.rawValue] as! Int
    }
    
    private func getLotteryStateValue(keyValue: lotteryDictionary) -> String {
        return (self.lotteryDraws.index(forKey: keyValue.rawValue) == nil) ? "" : self.lotteryDraws[keyValue.rawValue] as! String
    }
    
    private func getLotteryStateValue(keyValue: lotteryDictionary) -> [String: Int] {
        return (self.lotteryDraws.index(forKey: keyValue.rawValue) == nil) ? ([:]) : self.lotteryDraws[keyValue.rawValue] as! [String : Int]
    }
    
    private func getLotteryStateValue(keyValue: lotteryDictionary) -> [[String: Int]] {
        return (self.lotteryDraws.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.lotteryDraws[keyValue.rawValue] as! [[String : Int]]
    }
    
}

