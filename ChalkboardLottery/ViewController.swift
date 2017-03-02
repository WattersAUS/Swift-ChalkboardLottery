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
    var jsonOnlineData:    JSONOnlineDelegateHandler!
    var jsonLocalData:     JSONLocalDelegateHandler!
    
    //
    // sounds
    //
    var drawSound: AVAudioPlayer!
    
    //
    // place holders for the UILabels we'll use for the display (made up of 'numbers' and 'specials' arrays)
    //
    
    // ** needs a class to hold then???? **
    
    //
    // prefs
    //
    var userPrefs: PreferencesHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userPrefs  = PreferencesHandler()
        //
        // load the local user data / lotteries and draws
        //
        self.jsonLocalData = JSONLocalDelegateHandler()
        //
        // setup online JSON object we'll try access later
        //
        self.jsonOnlineData = JSONOnlineDelegateHandler()
        self.jsonOnlineData.loadOnlineResults()
        //
        // load sounds
        //
        self.drawSound = self.loadSound(soundName: "DrawNumbers_001")
        //
        // register routines for app transiting to b/g (used in saving state etc)
        //
        self.setupApplicationNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------------
    // 1. On the first run, need to sync up lottery defaults
    // 2. If we didn't connect keep reminding the user until we do
    //----------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.userPrefs.firstTime || self.jsonLocalData.history.lotteries.count == 0 {
            if self.jsonOnlineData.online {
                let message: String = "Wow! We need to sychronise some lottery draw details!"
                let alertController = UIAlertController(title: "Setup Lotteries", message: message, preferredStyle: .alert)
                let goAction = UIAlertAction(title: "Go!", style: .default) { (action:UIAlertAction!) in
                    self.setupLotteryDefaults()
                }
                alertController.addAction(goAction)
                self.present(alertController, animated: true, completion:nil)
                return
            }
            
            while self.jsonOnlineData.online == false {
                let message: String = "We'd like to download some lottery defaults, but I can't see the data right now! Make sure we can see a network!"
                let alertController = UIAlertController(title: "Setup Lotteries", message: message, preferredStyle: .alert)
                let goAction = UIAlertAction(title: "Try Again!", style: .default) { (action:UIAlertAction!) in
                    self.jsonOnlineData.loadOnlineResults()
                    if self.jsonOnlineData.online {
                        self.setupLotteryDefaults()
                    }
                }
                alertController.addAction(goAction)
                self.present(alertController, animated: true, completion:nil)
            }
            return
        }

        if self.jsonOnlineData.online == false {
            let message: String = "Warning! We haven't access to the online results, so we can't check the draw numbers!"
            let alertController = UIAlertController(title: "Setup Lotteries", message: message, preferredStyle: .alert)
            let goAction = UIAlertAction(title: "Oh!", style: .default) { (action:UIAlertAction!) in
                //
            }
            alertController.addAction(goAction)
            self.present(alertController, animated: true, completion:nil)
            return
        }
        
    }

    //----------------------------------------------------------------------------
    // default lottery setup
    //----------------------------------------------------------------------------
    func setupLotteryDefaults() {
        for i: OnlineLottery in self.jsonOnlineData.history.lotteries {
            var local: LocalLottery = LocalLottery()
            local.ident        = i.ident
            local.description  = i.description
            local.numbers      = i.numbers
            local.upperNumber  = i.upperNumber
            local.specials     = i.specials
            local.upperSpecial = i.upperSpecial
            local.active       = true
            
        }
        return
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
    func placementOfNumberLabels() {
        return
    }
    
    func placementOfSpecialsLabels() {
        return
    }
    
    func placementOfOptionsImages() {
        
    }
    
    func placemenOfTabLabels() {
        return
    }
    
    //----------------------------------------------------------------------------
    // Touch Setup / detection
    //----------------------------------------------------------------------------
    func processUserTapOnMainScreen(location: CGPoint) -> (row: Int, column: Int) {
//        for y: Int in 0 ..< self.controlPanelImages.getRows() {
//            for x: Int in 0 ..< self.controlPanelImages.getColumns() {
//                if self.isTapWithinImage(location: location, image: self.controlPanelImages.contents[y][x].imageView) == true {
//                    return(y, x)
//                }
//            }
//        }
        
        func foundTapInTabsMenu() -> Bool {
            // 1. run thro array of labels and does tap fall in boundaries of one of the labels
            // 2. use the 'index' into the array
            return false
        }
        
        func foundTapInNumbers() -> Bool {
            return false
        }
        
        func foundTapInSpecials() -> Bool {
            return false
        }
        
        func foundTapInOptions() -> Bool {
            return false
        }
        
        if foundTapInTabsMenu() == false {
            if foundTapInNumbers() == false {
                if foundTapInSpecials() == false {
                    if foundTapInOptions() == true {
                        
                    }
                }
            }
        }
        return(-1, -1)
    }
    
    func isTapWithinImage(location: CGPoint, image: UIImageView) -> Bool {
        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
                return true
            }
        }
        return false
    }
    
    func isTapWithinLabel(location: CGPoint, label: UILabel) -> Bool {
        if (location.x >= label.frame.origin.x) && (location.x <= (label.frame.origin.x + label.frame.width)) {
            if (location.y >= label.frame.origin.y) && (location.y <= (label.frame.origin.y + label.frame.height)) {
                return true
            }
        }
        return false
    }

}

