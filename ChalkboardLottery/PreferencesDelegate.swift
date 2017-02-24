//
//  PreferencesHandler.swift
//  SudokuTest
//
//  Created by Graham Watson on 10/07/2016.
//  Copyright © 2017 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// this class defines the 'protocol' used to allow the settings dialog to
// delegate the responsibility of keeping the defaults updated and including
// ensuring they are updated through the NSUserDefaults interface
//----------------------------------------------------------------------------
// no previous defaults is detected by using 'firstTime'
// using this we can set prefs for the first run of the app
//----------------------------------------------------------------------------

import Foundation

//
// Stores:
//
// Sound Off/On
// How many draws for the user will we store
// JSON string defining the draws the app will support
// - including Lotto, euro, Thunderball (ident 1-3) shipped and user configured draws (ident > 3)
// Allow retrieval of draw history (shiny-idea JSON)
// - this allows draw cfg to stay updated
//

protocol PreferencesDelegate: class {
    //
    // what we use to populate the pref dialog
    //
    var soundOn:              Bool { get set }
    var keepDraws:            Int  { get set }
    var lotteries: [ConfigLottery] { get set }
    //
    // allow a user to be able to save the prefs into the delegate via a helper function
    //
    var saveFunctions: [(Void) -> ()] { get set }
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var soundOn:                 Bool = false
    var keepDraws:                Int = 50
    var lotteries:    [ConfigLottery] = []
    var saveFunctions: [(Void) -> ()] = []
    //
    var firstTime:               Bool = false
    let userDefaults:    UserDefaults = UserDefaults.standard
    //
    // JSON string is extracted from the preferences and converted to dictionary from where we extract the setup of the draws
    //
    var loadedConfigs:  [ConfigLottery]!

    override init() {
        super.init()
        self.firstTime   = self.userDefaults.bool(forKey: "firstTime")
        if self.firstTime == true {
            self.soundOn   = true
            self.keepDraws = 50
            self.lotteries = []
            //
            // for first time load, we need to mock up set for initial draws. Euro = 1, Lotto = 2, ThunderBall = 3
            //
            self.lotteries.append(ConfigLottery(newIdent: 1, newDescription: "Euro Millions", newNumbers: 5, newUpperNumber: 50, newSpecials: 2, newUpperSpecial: 12, newBonus: false, newDays: [2, 5], newLimit: 50, newStart: "TODAYS-DATE", newReadOnly: true, newActive: true))
            self.lotteries.append(ConfigLottery(newIdent: 2, newDescription: "Lotto", newNumbers: 6, newUpperNumber: 59, newSpecials: 1, newUpperSpecial: 59, newBonus: true, newDays: [3, 6], newLimit: 50, newStart: "TODAYS-DATE", newReadOnly: true, newActive: true))
            self.lotteries.append(ConfigLottery(newIdent: 3, newDescription: "Thunderball", newNumbers: 5, newUpperNumber: 39, newSpecials: 1, newUpperSpecial: 14, newBonus: false, newDays: [3, 5, 6], newLimit: 50, newStart: "TODAYS-DATE", newReadOnly: true, newActive: true))
        } else {
            self.soundOn   = self.userDefaults.bool(forKey: "soundOn")
            self.keepDraws = self.userDefaults.integer(forKey: "keepDraws")
            self.lotteries = []
            //
            // should include all configured lotteries 1-3 default, plus any user defined
            //
            //self.lotteries.append(contentsOf: self.parseUserConfig(userPrefsJSON: self.userDefaults.string(forKey: "lotteries")!))
        }
        self.saveFunctions = [ self.savePreferences ]
        return
    }
    
    func savePreferences() -> (Void) {
        self.userDefaults.set(true,           forKey: "firstTime")
        self.userDefaults.set(self.soundOn,   forKey: "soundOn")
        self.userDefaults.set(self.keepDraws, forKey: "keepDraws")
        return
    }
    
    //-------------------------------------------------------------------------------
    // we store setup for the individual lottery draws in a JSON string within a pref
    //-------------------------------------------------------------------------------
    func decodeLotteriesFromObjectArray(array: [[String: AnyObject]]) -> [ConfigLottery] {
        var lotteries: [ConfigLottery] = []
        for lottery: [String: AnyObject] in array {
            var instance: ConfigLottery = ConfigLottery()
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
                case jsonConfigDictionary.Bonus.rawValue:
                    instance.bonus = value as! Bool
                    break
                case jsonConfigDictionary.Days.rawValue:
                    instance.days.append(contentsOf: value as! [Int])
                    break
                case jsonConfigDictionary.Limit.rawValue:
                    instance.limit = value as! Int
                    break
                case jsonConfigDictionary.Start.rawValue:
                    instance.start = value as! String
                    break
                case jsonConfigDictionary.Readonly.rawValue:
                    instance.readonly = value as! Bool
                    break
                case jsonConfigDictionary.Active.rawValue:
                    instance.active = value as! Bool
                    break
                default:
                    break
                }
            }
            lotteries.append(instance)
            
        }
        return lotteries
    }
    
    func parseUserConfig(userPrefsJSON: String) -> [ConfigLottery] {
        var loadedJSONData: [String: AnyObject]!

        func extractJSONValue(keyValue: jsonConfigDictionary) -> [[String: AnyObject]] {
            return (loadedJSONData.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : loadedJSONData[keyValue.rawValue] as! [[String : AnyObject]]
        }
        
        do {
            let fileData: Data  = userPrefsJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            loadedJSONData = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
            self.loadedConfigs  = []
            return decodeLotteriesFromObjectArray(array: extractJSONValue(keyValue: jsonConfigDictionary.Lottery))
        } catch {
            return []
        }
    }
    
}
