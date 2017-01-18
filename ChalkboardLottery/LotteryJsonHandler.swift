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
    var loadedDraws: History! { get set }
}

class LotteryDrawHandler: NSObject, LotteryDrawDelegate {

    private var loadedJSONData: [String: AnyObject]!
    internal var   loadedDraws: History!
    
    override init() {
        super.init()
        self.loadedJSONData = [:]
        self.loadedDraws    = History()
        return
    }

    func loadLotteryHistoryFromJSON() {
        
        func decodeValuesFromObjectArray(array: [[String: AnyObject]]) -> [Int] {
            var values: [Int] = []
            for nos: [String: AnyObject] in array {
                var number: Int = 0
                for (key,value) in nos {
                    switch key {
                    case jsonDictionary.Value.rawValue:
                        number = Int(value as! String)!
                        break
                    default:
                        break
                    }
                }
                values.append(number)
            }
            return values
        }

        func decodeDrawsFromObjectArray(array: [[String: AnyObject]]) -> [Draw] {
            var draws: [Draw] = []
            for draw: [String: AnyObject] in array {
                var instance: Draw = Draw()
                for (key,value) in draw {
                    switch key {
                    case jsonDictionary.Draw.rawValue:
                        instance.draw = Int(value as! String)!
                        break
                    case jsonDictionary.DrawDate.rawValue:
                        instance.drawDate = value as! String
                        break
                    case jsonDictionary.Numbers.rawValue:
                        instance.numbers.append(contentsOf: decodeValuesFromObjectArray(array: value as! [[String: AnyObject]]))
                        break
                    case jsonDictionary.Specials.rawValue:
                        instance.specials.append(contentsOf: decodeValuesFromObjectArray(array: value as! [[String: AnyObject]]))
                        break
                    default:
                        break
                    }
                }
                draws.append(instance)
            }
            return draws
        }

        func decodeLotteriesFromObjectArray(array: [[String: AnyObject]]) -> [LotteryInstance] {
            var lotteries: [LotteryInstance] = []
            for lottery: [String: AnyObject] in array {
                var instance: LotteryInstance = LotteryInstance()
                for (key,value) in lottery {
                    switch key {
                    case jsonDictionary.Ident.rawValue:
                        instance.ident = Int(value as! String)!
                        break
                    case jsonDictionary.Description.rawValue:
                        instance.description = value as! String
                        break
                    case jsonDictionary.Numbers.rawValue:
                        instance.numbers = Int(value as! String)!
                        break
                    case jsonDictionary.UpperNumber.rawValue:
                        instance.upperNumber = Int(value as! String)!
                        break
                    case jsonDictionary.Specials.rawValue:
                        instance.specials = Int(value as! String)!
                        break
                    case jsonDictionary.UpperSpecial.rawValue:
                        instance.upperSpecial = Int(value as! String)!
                        break
                    case jsonDictionary.LastModified.rawValue:
                        instance.lastModified = value as! String
                        break
                    case jsonDictionary.Draws.rawValue:
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
        
        loadedDraws.generated = self.extractJSONValue(keyValue: jsonDictionary.GenDate)
        loadedDraws.version   = self.extractJSONValue(keyValue: jsonDictionary.Version)
        loadedDraws.lotteries.append(contentsOf: decodeLotteriesFromObjectArray(array: self.extractJSONValue(keyValue: jsonDictionary.Lottery)))
        return
    }
    
    func loadLotteryResults() -> Bool {
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
//    private func extractJSONValue(keyValue: jsonDictionary) -> Int {
//        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? 0 : self.loadedJSONData[keyValue.rawValue] as! Int
//    }
    
    private func extractJSONValue(keyValue: jsonDictionary) -> String {
        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? "" : self.loadedJSONData[keyValue.rawValue] as! String
    }
    
//    private func extractJSONValue(keyValue: jsonDictionary) -> [String: Int] {
//        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? ([:]) : self.loadedJSONData[keyValue.rawValue] as! [String : Int]
//    }
//    
//    private func extractJSONValue(keyValue: jsonDictionary) -> [[String: Int]] {
//        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.loadedJSONData[keyValue.rawValue] as! [[String : Int]]
//    }
//    
//    private func extractJSONValue(keyValue: jsonDictionary) -> [String: String] {
//        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? ([:]) : self.loadedJSONData[keyValue.rawValue] as! [String : String]
//    }
    
    private func extractJSONValue(keyValue: jsonDictionary) -> [[String: AnyObject]] {
        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.loadedJSONData[keyValue.rawValue] as! [[String : AnyObject]]
    }
    
}

