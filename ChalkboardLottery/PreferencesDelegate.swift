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
    var soundOn:   Bool { get set }
    var keep:      Int  { get set }
    var draws:   String { get set }
    //
    // allow a user to be able to save the prefs into the delegate via a helper function
    //
    var saveFunctions: [(Void) -> ()] { get set }
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var soundOn:                 Bool = false
    var keep:                     Int = 50
    var draws:                 String = ""
    var saveFunctions: [(Void) -> ()] = []
    //
    var firstTime:               Bool = false
    let userDefaults:    UserDefaults = UserDefaults.standard
    
    override init() {
        super.init()
        self.firstTime   = self.userDefaults.bool(forKey: "firstTime")
        if self.firstTime == true {
            self.soundOn = true
            self.keep    = 50
            self.draws   = ""
        } else {
            self.soundOn = self.userDefaults.bool(forKey: "soundOn")
            self.keep    = self.userDefaults.integer(forKey: "keep")
// COME BACK TO THIS!!!            self.draws   = self.userDefaults.string(forKey: "draws")!
        }
        self.saveFunctions = [ self.savePreferences ]
        return
    }
    
    func savePreferences() -> (Void) {
        self.userDefaults.set(true,         forKey: "firstTime")
        self.userDefaults.set(self.soundOn, forKey: "soundOn")
        self.userDefaults.set(self.keep,    forKey: "keep")
        self.userDefaults.set(self.draws,   forKey: "draws")
        return
    }
    
}
