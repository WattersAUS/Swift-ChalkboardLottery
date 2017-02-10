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

import Foundation

protocol PreferencesDelegate: class {
    // what we use to populate the pref dialog
    var soundOn:                   Bool { get set }
    // allow a user to be able to save the prefs into the delegate via a helper function
    var saveFunctions: [(Void) -> ()] { get set }
}

class PreferencesHandler: NSObject, PreferencesDelegate {
    var soundOn:                   Bool = true
    var drawFunctions:   [(Void) -> ()] = []
    var saveFunctions:   [(Void) -> ()] = []
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    override init() {
        super.init()
        self.soundOn = self.userDefaults.bool(forKey: "soundOn")
        self.saveFunctions = [ self.savePreferences ]
        return
    }
    
    func savePreferences() -> (Void) {
        self.userDefaults.set(self.soundOn, forKey: "soundOn")
        return
    }
    
}


