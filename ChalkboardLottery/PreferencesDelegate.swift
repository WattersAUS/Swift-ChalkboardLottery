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
    var soundOn:             Bool { get set }
    var keepDraws:           Int  { get set }
    var lotteries: [LocalLottery] { get set }
    //
    // allow a user to be able to save the prefs into the delegate via a helper function
    //
    var saveFunctions: [(Void) -> ()] { get set }
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var soundOn:                 Bool = false
    var keepDraws:                Int = 50
    var lotteries:     [LocalLottery] = []
    var saveFunctions: [(Void) -> ()] = []
    //
    var firstTime:            Bool = false
    let userDefaults: UserDefaults = UserDefaults.standard
    //
    // JSON string is extracted from the preferences and converted to dictionary from where we extract the setup of the draws
    //
    var loadedConfigs:  [LocalLottery]!

    override init() {
        super.init()
        self.firstTime   = self.userDefaults.bool(forKey: "firstTime")
        if self.firstTime == true {
            self.soundOn   = true
            self.keepDraws = 50
            self.lotteries = []
        } else {
            self.soundOn   = self.userDefaults.bool(forKey: "soundOn")
            self.keepDraws = self.userDefaults.integer(forKey: "keepDraws")
            //
            // should include all configured lotteries 1-3 default, plus any user defined
            //
            self.lotteries = []
        }
        self.saveFunctions = [ self.savePreferences ]
        return
    }
    
    func savePreferences() -> (Void) {
        self.userDefaults.set(true,             forKey: "firstTime")
        self.userDefaults.set(self.soundOn,     forKey: "soundOn")
        self.userDefaults.set(self.keepDraws,   forKey: "keepDraws")
        return
    }
    
}
