//
//  JSONOnlineDelegate.swift
//  ChalkboardLottery
//
//  Created by Graham on 16/02/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// online downloaded results
//----------------------------------------------------------------------------

import Foundation

protocol JSONOnlineDelegate: class {
    var history: OnlineHistory! { get set }
}

class JSONOnlineDelegateHandler: NSObject, JSONOnlineDelegate {
    
    private var JSONData: [String: AnyObject]!
    internal var history: OnlineHistory!
    internal var online:  Bool = false
    
    override init() {
        super.init()
        self.JSONData = [:]
        self.history  = OnlineHistory()
        self.online   = false
        return
    }
    
    //-------------------------------------------------------------------------------
    // pick out the dictionary 'keys/value' when we load the results
    // if we don't yet have a value return a default
    //-------------------------------------------------------------------------------
    private func extractJSONValue(keyValue: jsonOnline) -> String {
        return (self.JSONData.index(forKey: keyValue.rawValue) == nil) ? "" : self.JSONData[keyValue.rawValue] as! String
    }
    
    private func extractJSONValue(keyValue: jsonOnline) -> [[String: AnyObject]] {
        return (self.JSONData.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.JSONData[keyValue.rawValue] as! [[String : AnyObject]]
    }
    
    //-------------------------------------------------------------------------------
    // parse through the downloaded JSON (in self.loadedJSONData) and extract details
    //-------------------------------------------------------------------------------
    private func loadOnlineHistoryFromJSON() {
        
        func decodeLotteriesFromObjectArray(array: [[String: AnyObject]]) -> [OnlineLottery] {

            func decodeDrawsFromObjectArray(array: [[String: AnyObject]]) -> [OnlineDraw] {
                var draws: [OnlineDraw] = []
                for draw: [String: AnyObject] in array {
                    var instance: OnlineDraw = OnlineDraw()
                    for (key,value) in draw {
                        switch key {
                        case jsonOnline.Draw.rawValue:
                            instance.draw = value as! Int
                            break
                        case jsonOnline.DrawDate.rawValue:
                            instance.date = value as! String
                            break
                        case jsonOnline.Numbers.rawValue:
                            instance.numbers.append(contentsOf: value as! [Int])
                            break
                        case jsonOnline.Specials.rawValue:
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
            
            var lotteries: [OnlineLottery] = []
            for lottery: [String: AnyObject] in array {
                var instance: OnlineLottery = OnlineLottery()
                for (key,value) in lottery {
                    switch key {
                    case jsonOnline.Ident.rawValue:
                        instance.ident = value as! Int
                        break
                    case jsonOnline.Description.rawValue:
                        instance.description = value as! String
                        break
                    case jsonOnline.Numbers.rawValue:
                        instance.numbers = value as! Int
                        break
                    case jsonOnline.UpperNumber.rawValue:
                        instance.upperNumber = value as! Int
                        break
                    case jsonOnline.Specials.rawValue:
                        instance.specials = value as! Int
                        break
                    case jsonOnline.UpperSpecial.rawValue:
                        instance.upperSpecial = value as! Int
                        break
                    case jsonOnline.Bonus.rawValue:
                        instance.bonus = value as! Bool
                        break
                    case jsonOnline.LastModified.rawValue:
                        instance.lastModified = value as! String
                        break
                    case jsonOnline.Draws.rawValue:
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
        
        self.history.generated = self.extractJSONValue(keyValue: jsonOnline.GenDate)
        self.history.version   = self.extractJSONValue(keyValue: jsonOnline.Version)
        self.history.lotteries.append(contentsOf: decodeLotteriesFromObjectArray(array: self.extractJSONValue(keyValue: jsonOnline.Lottery)))
        return
    }
    
    func loadOnlineResults() {
        do {
            let jsonFile = try String(contentsOf: URL(string: "https://www.shiny-ideas.tech/lottery/getLotteryResults.php?key=GJWKEY001")!)
            let fileData: Data = jsonFile.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            self.JSONData = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
            self.loadOnlineHistoryFromJSON()
            self.online = true
        } catch {
            self.online = false
        }
        return
    }
}
