//
//  JSONConfigDelegate.swift
//  ChalkboardLottery
//
//  Created by Graham on 16/02/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// this class defines the 'protocol' used to allow the settings dialog to
// delegate the responsibility of keeping the defaults updated and including
// ensuring they are updated
//----------------------------------------------------------------------------

import Foundation

protocol JSONConfigDelegate: class {
    var loadedConfigs: ConfigLotteryInstance! { get set }
}

class JSONConfigDelegateHandler: NSObject, JSONConfigDelegate {
    
    private var loadedJSONData: [String: AnyObject]!
    internal var loadedConfigs: ConfigLotteryInstance!
    
    override init() {
        super.init()
        self.loadedJSONData = [:]
        self.loadedConfigs    = ConfigLotteryInstance()
        return
    }
    
    func loadLotteryConfigFromJSON() {
        
        func decodeDrawsFromObjectArray(array: [[String: AnyObject]]) -> [UserDraw] {
            var draws: [UserDraw] = []
            for draw: [String: AnyObject] in array {
                var instance: UserDraw = UserDraw()
                for (key,value) in draw {
                    switch key {
                    case jsonConfigDictionary.DrawDate.rawValue:
                        instance.drawDate = value as! String
                        break
                    case jsonConfigDictionary.Numbers.rawValue:
                        instance.numbers.append(contentsOf: value as! [Int])
                        break
                    case jsonConfigDictionary.Specials.rawValue:
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
        
        func decodeLotteriesFromObjectArray(array: [[String: AnyObject]]) -> [ConfigLotteryInstance] {
            var lotteries: [ConfigLotteryInstance] = []
            for lottery: [String: AnyObject] in array {
                var instance: ConfigLotteryInstance = ConfigLotteryInstance()
                for (key,value) in lottery {
                    switch key {
                    case jsonConfigDictionary.Ident.rawValue:
                        instance.ident = value as! Int
                        break
                    case jsonConfigDictionary.Description.rawValue:
                        instance.description = value as! String
                        break
                    case jsonConfigDictionary.Numbers.rawValue:
                        instance.numbers = value as! Int
                        break
                    case jsonConfigDictionary.UpperNumber.rawValue:
                        instance.upperNumber = value as! Int
                        break
                    case jsonConfigDictionary.Specials.rawValue:
                        instance.specials = value as! Int
                        break
                    case jsonConfigDictionary.UpperSpecial.rawValue:
                        instance.upperSpecial = value as! Int
                        break
                    case jsonConfigDictionary.LastModified.rawValue:
                        instance.lastModified = value as! String
                        break
                    case jsonConfigDictionary.Draws.rawValue:
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
        
        loadedConfigs.lotteries.append(contentsOf: decodeLotteriesFromObjectArray(array: self.extractJSONValue(keyValue: jsonConfigDictionary.Lottery)))
        return
    }
    
    func loadUserResults(source: String) -> Bool {
        do {
            let jsonFile = try String(contentsOf: URL(string: "https://www.shiny-ideas.tech/lottery/lotteryresults.json")!)
            let fileData: Data = jsonFile.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            self.loadedJSONData = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
            self.loadLotteryConfigFromJSON()
        } catch {
            return false
        }
        return true
    }
    
    //-------------------------------------------------------------------------------
    // pick out the dictionary 'keys/value' when we load the results
    // if we don't yet have a value return a default
    //-------------------------------------------------------------------------------
    private func extractJSONValue(keyValue: jsonConfigDictionary) -> String {
        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? "" : self.loadedJSONData[keyValue.rawValue] as! String
    }
    
    private func extractJSONValue(keyValue: jsonConfigDictionary) -> [[String: AnyObject]] {
        return (self.loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.loadedJSONData[keyValue.rawValue] as! [[String : AnyObject]]
    }
    
}
