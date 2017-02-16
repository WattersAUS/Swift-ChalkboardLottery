//
//  ViewController.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 13/09/2016.
//  Copyright © 2016 Graham Watson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //
    // onlne lottery history retrieval
    //
    var jsonOnline:        JSONOnlineDelegateHandler!
    var useOnlineResults:  Bool = false
    
    //
    // sounds
    //
    var drawSound: AVAudioPlayer!
    
    //
    // prefs
    //
    var userPrefs: PreferencesHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userPrefs  = PreferencesHandler()
        //
        // get the online JSON file with Lottery Results (if we can)
        // and store whether we were able to or not
        //
        self.jsonOnline       = JSONOnlineDelegateHandler()
        self.useOnlineResults = self.jsonOnline.loadOnlineResults()
        //
        // load sounds
        //
        self.drawSound        = self.loadSound(soundName: "DrawNumbers_001")
        //
        // register routines for app transiting to b/g (used in saving game state etc)
        //
        self.setupApplicationNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------------
    // app transition events
    //----------------------------------------------------------------------------
    func setupApplicationNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(applicationMovingToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationMovingToForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationToClose),            name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        return
    }
    
    func applicationToClose() {
        return
    }
    
    func applicationMovingToForeground() {
        return
    }
    
    func applicationMovingToBackground() {
        return
    }
    
    //----------------------------------------------------------------------------
    // Sound handling
    //----------------------------------------------------------------------------
    func loadSound(soundName: String) -> AVAudioPlayer! {
        var value: AVAudioPlayer! = nil
        if let loadAsset: NSDataAsset = NSDataAsset(name: soundName) {
            do {
                value = try AVAudioPlayer(data: loadAsset.data, fileTypeHint: AVFileTypeAIFF)
            } catch {
                return nil
            }
        }
        return value
    }
    
    func playGenerateSound() {
        guard self.drawSound != nil && self.userPrefs.soundOn == true else {
            return
        }
        self.drawSound.play()
        return
    }
    
    //----------------------------------------------------------------------------
    // View placement
    //----------------------------------------------------------------------------

}

