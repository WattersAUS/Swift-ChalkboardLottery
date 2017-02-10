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

protocol PreferencesDelegate: class {
    // what we use to populate the pref dialog
    var soundOn:                   Bool { get set }
    // allow a user to be able to save the prefs into the delegate via a helper function
    var saveFunctions: [(Void) -> ()] { get set }
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var firstTime:               Bool = false
    var soundOn:                 Bool = false
    var saveFunctions: [(Void) -> ()] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    override init() {
        super.init()
        self.firstTime   = self.userDefaults.bool(forKey: "firstTime")
        if self.firstTime == false {
            self.soundOn = self.userDefaults.bool(forKey: "soundOn")
        } else {
            self.soundOn = true
        }
        self.saveFunctions = [ self.savePreferences ]
        return
    }
    
    func savePreferences() -> (Void) {
        self.userDefaults.set(true,         forKey: "firstTime")
        self.userDefaults.set(self.soundOn, forKey: "soundOn")
        return
    }
    
}


