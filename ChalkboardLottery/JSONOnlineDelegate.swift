//
//  JSONOnlineDelegate.swift
//  ChalkboardLottery
//
//  Created by Graham on 16/02/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// defines the 'protocol' used to allow access to the downloaded results
//----------------------------------------------------------------------------

import Foundation

protocol JSONOnlineDelegate: class {
    var loadedDraws: OnlineHistory! { get set }
}

class JSONOnlineDelegateHandler: NSObject, JSONOnlineDelegate {
    
    private var loadedJSONData: [String: AnyObject]!
    internal var   loadedDraws: OnlineHistory!
    
    override init() {
        super.init()
        self.loadedJSONData = [:]
        self.loadedDraws    = OnlineHistory()
        return
    }
    
    func loadLotteryHistoryFromJSON() {
        
        func decodeDrawsFromObjectArray(array: [[String: AnyObject]]) -> [OnlineDraw] {
            var draws: [OnlineDraw] = []
            for draw: [String: AnyObject] in array {
                var instance: OnlineDraw = OnlineDraw()
                for (key,value) in draw {
                    switch key {
                    case jsonOnlineDictionary.Draw.rawValue:
                        instance.draw = value as! Int
                        break
                    case jsonOnlineDictionary.DrawDate.rawValue:
                        instance.drawDate = value as! String
                        break
                    case jsonOnlineDictionary.Numbers.rawValue:
                        instance.numbers.append(contentsOf: value as! [Int])
                        break
                    case jsonOnlineDictionary.Specials.rawValue:
                        instance.specials.append(contentsOf: value as! [Int])
                        break
                    default:
                        break
                    }
                }
                draws.append(instance)
            }
            return draws
        }
        
        func decodeLotteriesFromObjectArray(array: [[String: AnyObject]]) -> [OnlineLotteryInstance] {
            var lotteries: [OnlineLotteryInstance] = []
            for lottery: [String: AnyObject] in array {
                var instance: OnlineLotteryInstance = OnlineLotteryInstance()
                for (key,value) in lottery {
                    switch key {
                    case jsonOnlineDictionary.Ident.rawValue:
                        instance.ident = value as! Int
                        break
                    case jsonOnlineDictionary.Description.rawValue:
                        instance.description = value as! String
                        break
                    case jsonOnlineDictionary.Numbers.rawValue:
                        instance.numbers = value as! Int
                        break
                    case jsonOnlineDictionary.UpperNumber.rawValue:
                        instance.upperNumber = value as! Int
                        break
                    case jsonOnlineDictionary.Specials.rawValue:
                        instance.specials = value as! Int
                        break
                    case jsonOnlineDictionary.UpperSpecial.rawValue:
                        instance.upperSpecial = value as! Int
                        break
                    case jsonOnlineDictionary.LastModified.rawValue:
                        instance.lastModified = value as! String
                        break
                    case jsonOnlineDictionary.Draws.rawValue:
                        instance.draws = decodeDrawsFromObjectArray(array: value as! [[String: AnyObject]])
                        break
                    default:
                        break
                    }
                }
                lotteries.append(instance)
                
            }
            return lotteries
        }
        
        loadedDraws.generated = self.extractJSONValue(keyValue: jsonOnlineDictionary.GenDate)
        loadedDraws.version   = self.extractJSONValue(keyValue: jsonOnlineDictionary.Version)
        loadedDraws.lotteries.append(contentsOf: decodeLotteriesFromObjectArray(array: self.extractJSONValue(keyValue: jsonOnlineDictionary.Lottery)))
        return
    }
    
    func loadOnlineResults() -> Bool {
        do {
            let jsonFile = try String(contentsOf: URL(string: "https://www.shiny-ideas.tech/lottery/lotteryresults.json")!)
            let fileData: Data = jsonFile.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            self.loadedJSONData = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
            self.loadLotteryHistoryFromJSON()
        } catch {
            return false
        }
        return true
    }
    
    //-------------------------------------------------------------------------------
    // pick out the dictionary 'keys/value' when we load the results
    // if we don't yet have a value return a default
    //-------------------------------------------------------------------------------
    private func extractJSONValue(keyValue: jsonOnlineDictionary) -> String {
        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? "" : self.loadedJSONData[keyValue.rawValue] as! String
    }
    
    private func extractJSONValue(keyValue: jsonOnlineDictionary) -> [[String: AnyObject]] {
        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.loadedJSONData[keyValue.rawValue] as! [[String : AnyObject]]
    }
    
}
