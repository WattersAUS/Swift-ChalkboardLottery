//
//  JSONLocalDelegate.swift
//  ChalkboardLottery
//
//  Created by Graham on 01/03/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// stored local user results
//----------------------------------------------------------------------------

import Foundation

protocol JSONLocalDelegate: class {
    var history: LocalHistory! { get set }
}

class JSONLocalDelegateHandler: NSObject, JSONLocalDelegate {
    
    private var JSONData: [String: AnyObject]!
    internal var history: LocalHistory!
    
    override init() {
        super.init()
        self.JSONData = [:]
        self.history  = LocalHistory()
        return
    }
    
    //-------------------------------------------------------------------------------
    // location of the JSON is.....
    //-------------------------------------------------------------------------------
    private func getDocumentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    private func getFilename() -> String {
        let directory: String = getDocumentDirectory() + "/" + "chalkboardlottery.json"
        return directory
    }
    
    //-------------------------------------------------------------------------------
    // parse through the downloaded JSON (in self.loadedJSONData) and extract details
    //-------------------------------------------------------------------------------
    private func extractJSONValue(keyValue: jsonLocal) -> String {
        return (self.JSONData.index(forKey: keyValue.rawValue) == nil) ? "" : self.JSONData[keyValue.rawValue] as! String
    }
    
    private func extractJSONValue(keyValue: jsonLocal) -> Int {
        return (self.JSONData.index(forKey: keyValue.rawValue) == nil) ? 0 : self.JSONData[keyValue.rawValue] as! Int
    }
    
    private func extractJSONValue(keyValue: jsonLocal) -> [[String: AnyObject]] {
        return (self.JSONData.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.JSONData[keyValue.rawValue] as! [[String : AnyObject]]
    }
    
    private func loadLocalHistoryFromJSON() {
        
        func decodeLotteriesFromObjectArray(array: [[String: AnyObject]]) -> [LocalLottery] {
            
            func decodeDrawsFromObjectArray(array: [[String: AnyObject]]) -> [LocalDraw] {
                var draws: [LocalDraw] = []
                for draw: [String: AnyObject] in array {
                    var instance: LocalDraw = LocalDraw()
                    for (key,value) in draw {
                        switch key {
                        case jsonLocal.DrawDate.rawValue:
                            instance.date = value as! String
                            break
                        case jsonLocal.Numbers.rawValue:
                            instance.numbers.append(contentsOf: value as! [Int])
                            break
                        case jsonLocal.Specials.rawValue:
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
            
            var lotteries: [LocalLottery] = []
            for lottery: [String: AnyObject] in array {
                var instance: LocalLottery = LocalLottery()
                for (key,value) in lottery {
                    switch key {
                    case jsonLocal.Ident.rawValue:
                        instance.ident = lotteryIdent(rawValue: value as! Int)!
                        break
                    case jsonLocal.Description.rawValue:
                        instance.description = value as! String
                        break
                    case jsonLocal.Numbers.rawValue:
                        instance.numbers = value as! Int
                        break
                    case jsonLocal.UpperNumber.rawValue:
                        instance.upperNumber = value as! Int
                        break
                    case jsonLocal.Specials.rawValue:
                        instance.specials = value as! Int
                        break
                    case jsonLocal.UpperSpecial.rawValue:
                        instance.upperSpecial = value as! Int
                        break
                    case jsonLocal.Modified.rawValue:
                        instance.lastModified = value as! String
                        break
                    case jsonLocal.Bonus.rawValue:
                        instance.bonus = value as! Bool
                        break
                    case jsonLocal.Days.rawValue:
                        instance.days = []
                        instance.days.append(contentsOf: value as! [Int])
                        break
                    case jsonLocal.Active.rawValue:
                        instance.active = value as! Bool
                        break
                    case jsonLocal.Draws.rawValue:
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
        
        self.history.version   = self.extractJSONValue(keyValue: jsonLocal.Version)
        self.history.activetab = self.extractJSONValue(keyValue: jsonLocal.ActiveTab)
        self.history.lotteries.append(contentsOf: decodeLotteriesFromObjectArray(array: self.extractJSONValue(keyValue: jsonLocal.Lottery)))
        return
    }
    
    func loadLocalResults() {
        let filename: String = self.getFilename()
        do {
            let fileContents: String = try NSString(contentsOfFile: filename, usedEncoding: nil) as String
            let fileData: Data       = fileContents.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            self.JSONData            = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
            self.loadLocalHistoryFromJSON()
        } catch {
            print("Failed to read Local JSON file: \(filename)")
        }
        return
    }
    
    //-------------------------------------------------------------------------------
    // build the JSON format file for our results and save it!
    //-------------------------------------------------------------------------------
    private func buildLocalHistoryDictionary() {

        func buildLotteryArray() -> [[String: AnyObject]] {
            
            func buildDrawsArray(lotteryDraws: [LocalDraw]) -> [[String: AnyObject]] {
                var draws: [[String: AnyObject]] = []
                for i: LocalDraw in lotteryDraws {
                    var draw: [String: AnyObject] = [:]
                    draw[jsonLocal.DrawDate.rawValue] = i.date as AnyObject?
                    draw[jsonLocal.Numbers.rawValue]  = i.numbers as AnyObject?
                    draw[jsonLocal.Specials.rawValue] = i.specials as AnyObject?
                    draws.append(draw)
                }
                return draws
            }
            
            var lotteries: [[String: AnyObject]] = []
            for i: LocalLottery in self.history.lotteries {
                var lottery: [String: AnyObject] = [:]
                lottery[jsonLocal.Ident.rawValue]        = i.ident as AnyObject?
                lottery[jsonLocal.Description.rawValue]  = i.description as AnyObject?
                lottery[jsonLocal.Numbers.rawValue]      = i.numbers as AnyObject?
                lottery[jsonLocal.UpperNumber.rawValue]  = i.upperNumber as AnyObject?
                lottery[jsonLocal.Specials.rawValue]     = i.specials as AnyObject?
                lottery[jsonLocal.UpperSpecial.rawValue] = i.upperSpecial as AnyObject?
                lottery[jsonLocal.Modified.rawValue]     = i.lastModified as AnyObject?
                lottery[jsonLocal.Bonus.rawValue]        = i.bonus as AnyObject?
                lottery[jsonLocal.Days.rawValue]         = i.days as AnyObject?
                lottery[jsonLocal.Active.rawValue]       = i.active as AnyObject?
                lottery[jsonLocal.Draws.rawValue]        = buildDrawsArray(lotteryDraws: i.draws) as AnyObject?
                lotteries.append(lottery)
            }
            return lotteries
        }
        
        self.JSONData = [:]
        self.JSONData[jsonLocal.Version.rawValue]   = self.history.version as AnyObject?
        self.JSONData[jsonLocal.ActiveTab.rawValue] = self.history.activetab as AnyObject?
        self.JSONData[jsonLocal.Lottery.rawValue]   = buildLotteryArray() as AnyObject?
        return
    }
    
    func saveLocalResults() {
        self.buildLocalHistoryDictionary()
        if JSONSerialization.isValidJSONObject(self.JSONData) { // True
            do {
                let rawData: Data        = try JSONSerialization.data(withJSONObject: self.JSONData)
                let resultString: String = String(data: rawData as Data, encoding: String.Encoding.utf8)! as String
                let filename: String     = self.getFilename()
                do {
                    try resultString.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                } catch {
                    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                    print("Failed to write to file: \(filename)")
                }
            } catch {
                // Handle Error
            }
        }
        return
    }
}
