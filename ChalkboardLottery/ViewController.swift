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
    // place holders for the UILabels we'll use for the display
    //
    var displayDraws: [LotteryDisplay]!
    //
    // Positioning info we'll save for transitioning portrait / landscape for the draws
    //
    var displayPosns: [[Positioning]]!
    
    //
    // prefs
    //
    var userPrefs: PreferencesHandler!
    
    //
    // views / scaling / orientation
    //
    var appViews:        [UIImageView]!
    var viewOrientation: UIDeviceOrientation = .unknown

    //
    // images used for drawing top tab and main area
    //
    var tabViewImage: [UIImage] = [
        UIImage(named:"Image_Tab_001.png")!,
        UIImage(named:"Image_Tab_002.png")!,
        UIImage(named:"Image_Tab_003.png")!
    ]
    
    var mainViewImage: UIImage = UIImage(named:"Image_Main.png")!
    var ctrlViewImage: UIImage = UIImage(named:"Image_Control.png")!
    
    //
    // active Tab (to be loaded yet from save state)
    //
    
    //----------------------------------------------------------------------------
    // Here we go!
    //----------------------------------------------------------------------------
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
        
        //
        // setup view holders for tab. main and control (we'll set size and position later)
        //
        self.appViews = []
        self.appViews.append(UIImageView(frame: CGRect(x: 0, y: 0,   width: 100, height: 100)))
        self.appViews.append(UIImageView(frame: CGRect(x: 0, y: 200, width: 100, height: 100)))
        self.appViews.append(UIImageView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
        
        //
        // setup dummy bg colours for debug
        //
        self.view.backgroundColor = UIColor.blue
//        self.appViews[viewType.tab.rawValue].backgroundColor  = UIColor.blue
//        self.appViews[viewType.main.rawValue].backgroundColor = UIColor.red
//        self.appViews[viewType.ctrl.rawValue].backgroundColor = UIColor.green
        
        //
        // add images to views (using 0 is placeholder until we get save state work done)
        //
        self.appViews[viewType.tab.rawValue].image  = self.tabViewImage[0]
        self.appViews[viewType.main.rawValue].image = self.mainViewImage
        self.appViews[viewType.ctrl.rawValue].image = self.ctrlViewImage
        
        //
        // add to the main view
        //
        self.view.addSubview(self.appViews[viewType.tab.rawValue])
        self.view.addSubview(self.appViews[viewType.main.rawValue])
        self.view.addSubview(self.appViews[viewType.ctrl.rawValue])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------------
    // orientation handling
    //----------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //
        // Initial device orientation
        //
        self.viewOrientation = UIDevice.current.orientation
        self.setInitialViewsOrientation()
        return
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
        return
    }

    func deviceDidRotate(notification: NSNotification) {
        self.viewOrientation = UIDevice.current.orientation
        //
        // Ignore changes in device orientation if unknown, face up, or face down.
        //
        if !UIDeviceOrientationIsValidInterfaceOrientation(self.viewOrientation) {
            return
        }
        self.setViewsOrientation()
        return
    }
    
    //----------------------------------------------------------------------------
    // Set main views positioning and size
    //----------------------------------------------------------------------------
    // first time in *need* to set an orientation, so choose port or land
    //
    func setInitialViewsOrientation() {
        if UIDeviceOrientationIsLandscape(self.viewOrientation) {
            self.setViewsInLandscapeOrientation()
        } else {
            self.setViewsInPortraitOrientation()
        }
        return
    }
    
    func setViewsOrientation() {
        if UIDeviceOrientationIsPortrait(self.viewOrientation) {
            self.setViewsInPortraitOrientation()
        } else {
            if UIDeviceOrientationIsLandscape(self.viewOrientation) {
                self.setViewsInLandscapeOrientation()
            }
        }
        return
    }
    
    func setViewsInPortraitOrientation() {
        let bounds: ViewBounds  = ViewBounds(screenWidth: self.view.frame.width, screenHeight: self.view.frame.height)
        let tabHeight: CGFloat  = bounds.yScale * 4
        let ctrlHeight: CGFloat = bounds.yScale * 4
        self.appViews[viewType.tab.rawValue].frame  = CGRect(x: bounds.x, y: bounds.y,              width: bounds.w, height: tabHeight)
        self.appViews[viewType.main.rawValue].frame = CGRect(x: bounds.x, y: bounds.y + tabHeight,  width: bounds.w, height: bounds.h - (tabHeight + ctrlHeight))
        self.appViews[viewType.ctrl.rawValue].frame = CGRect(x: bounds.x, y: bounds.h - ctrlHeight, width: bounds.w, height: ctrlHeight)
        return
    }

    func setViewsInLandscapeOrientation() {
        let bounds: ViewBounds = ViewBounds(screenWidth: self.view.frame.width, screenHeight: self.view.frame.height)
        let tabHeight: CGFloat = bounds.yScale * 4
        let ctrlWidth: CGFloat = bounds.xScale * 4
        self.appViews[viewType.tab.rawValue].frame  = CGRect(x: bounds.x,             y: bounds.y,             width: bounds.w - ctrlWidth, height: tabHeight)
        self.appViews[viewType.main.rawValue].frame = CGRect(x: bounds.x,             y: bounds.y + tabHeight, width: bounds.w - ctrlWidth, height: bounds.h - tabHeight)
        self.appViews[viewType.ctrl.rawValue].frame = CGRect(x: bounds.w - ctrlWidth, y: bounds.y,             width: ctrlWidth,            height: bounds.h)
        return
    }
    
    func setLabelsDisplay() {
        return
    }
    
    //----------------------------------------------------------------------------
    // 1. On the first run, need to sync up lottery defaults
    // 2. If we didn't connect keep reminding the user until we do
    //----------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.userPrefs.firstTime || self.jsonLocalData.history.lotteries.count == 0 {
            if self.jsonOnlineData.online {
                let message: String = "We need to sychronise some lottery draw details!"
                let alertController = UIAlertController(title: "Setup Lotteries", message: message, preferredStyle: .alert)
                let goAction = UIAlertAction(title: "Go!", style: .default) { (action:UIAlertAction!) in
                    self.setupLocalLotteryDefaults()
                }
                alertController.addAction(goAction)
                self.present(alertController, animated: true, completion:nil)
                //return
            }
            
            while self.jsonOnlineData.online == false {
                let message: String = "We'd like to download some lottery defaults, but I can't see the Interwebs right now! Make sure we can see a network, or are on WiFi!"
                let alertController = UIAlertController(title: "Setup Lotteries", message: message, preferredStyle: .alert)
                let goAction = UIAlertAction(title: "Try Again!", style: .default) { (action:UIAlertAction!) in
                    self.jsonOnlineData.loadOnlineResults()
                    if self.jsonOnlineData.online {
                        self.setupLocalLotteryDefaults()
                    }
                }
                alertController.addAction(goAction)
                self.present(alertController, animated: true, completion:nil)
            }
            //return
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
        
        //
        // if we got here then we need to check the setup of the local lotteries we've loaded against those we've got from online
        // and force a save to local storage, if they've been updated
        //
        if self.checkLotteryDefaults() {
            self.jsonLocalData.saveLocalResults()
        }
        //
        // now we have the 'loaded' lotteries we can build displays and positioning
        //
        self.setupLotteryDisplays()
        self.setDisplayPositioning()
        self.addDisplayLabelsToMainView()
    }
    
    //----------------------------------------------------------------------------
    // app transition events
    //----------------------------------------------------------------------------
    func setupApplicationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationMovingToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationMovingToForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationToClose),            name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
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
    // default lottery setup
    //----------------------------------------------------------------------------
    // parse through draws extracting the date played (YYYY-MM-DD) to give 'day number' game was played (0 - 6)
    //
    func getDaysOnlineLotteryPlayed(online: Int) -> [Int] {
        
        func getDayNumberGamePlayed(draw: String) -> Int {
            let dateFormat        = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let drawDate          = dateFormat.date(from: draw)!
            let calendar          = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            return calendar.components(.weekday, from: drawDate).weekday!
        }
        
        var daysPlayed: [Int] = []
        for i: OnlineDraw in self.jsonOnlineData.history.lotteries[online].draws {
            let day: Int = getDayNumberGamePlayed(draw: i.date) - 1
            if !daysPlayed.contains(day) {
                daysPlayed.append(day)
            }
        }
        return daysPlayed.sorted()
    }
    
    //
    // only used we've saved local results before
    //
    func setupLocalLotteryDefaults() {
        self.jsonLocalData.history.lotteries = []
        for i: Int in 0 ..< self.jsonOnlineData.history.lotteries.count {
            var local: LocalLottery = LocalLottery()
            local.ident        = self.jsonOnlineData.history.lotteries[i].ident
            local.description  = self.jsonOnlineData.history.lotteries[i].description
            local.numbers      = self.jsonOnlineData.history.lotteries[i].numbers
            local.upperNumber  = self.jsonOnlineData.history.lotteries[i].upperNumber
            local.specials     = self.jsonOnlineData.history.lotteries[i].specials
            local.upperSpecial = self.jsonOnlineData.history.lotteries[i].upperSpecial
            local.bonus        = self.jsonOnlineData.history.lotteries[i].bonus
            local.days         = []
            local.days.append(contentsOf: getDaysOnlineLotteryPlayed(online: i))
            local.active       = true
            self.jsonLocalData.history.lotteries.append(local)
        }
        return
    }
    
    //
    // if we've had a save, need to compare online settings and see they haven't changed since the last save
    //
    func checkLotteryDefaults() -> Bool {
        
        func isLotteryChanged(online: Int, local: Int) -> Bool {
            if self.jsonOnlineData.history.lotteries[online].numbers == self.jsonLocalData.history.lotteries[local].numbers &&
                self.jsonOnlineData.history.lotteries[online].upperNumber == self.jsonLocalData.history.lotteries[local].upperNumber &&
                self.jsonOnlineData.history.lotteries[online].specials == self.jsonLocalData.history.lotteries[local].specials &&
                self.jsonOnlineData.history.lotteries[online].upperSpecial == self.jsonLocalData.history.lotteries[local].upperSpecial &&
                self.jsonOnlineData.history.lotteries[online].bonus == self.jsonLocalData.history.lotteries[local].bonus {
                    return true
            }
            return false
        }
        
        func findMatchingLocalLottery(online: Int) -> Int {
            for i: Int in 0 ..< self.jsonLocalData.history.lotteries.count {
                if self.jsonOnlineData.history.lotteries[online].ident == self.jsonLocalData.history.lotteries[i].ident {
                    return i
                }
            }
            return -1
        }

        func updateLocalLotteryDefaults(online: Int, local: Int) {
            self.jsonLocalData.history.lotteries[local].description  = self.jsonOnlineData.history.lotteries[online].description
            self.jsonLocalData.history.lotteries[local].numbers      = self.jsonOnlineData.history.lotteries[online].numbers
            self.jsonLocalData.history.lotteries[local].upperNumber  = self.jsonOnlineData.history.lotteries[online].upperNumber
            self.jsonLocalData.history.lotteries[local].specials     = self.jsonOnlineData.history.lotteries[online].specials
            self.jsonLocalData.history.lotteries[local].upperSpecial = self.jsonOnlineData.history.lotteries[online].upperSpecial
            self.jsonLocalData.history.lotteries[local].bonus        = self.jsonOnlineData.history.lotteries[online].bonus
            self.jsonLocalData.history.lotteries[local].days         = []
            self.jsonLocalData.history.lotteries[local].days.append(contentsOf: getDaysOnlineLotteryPlayed(online: online))
            self.jsonLocalData.history.lotteries[local].active       = true
            return
        }
        
        func addLocalLotteryDefaults(online: Int) {
            var newLottery: LocalLottery = LocalLottery()
            newLottery.description       = self.jsonOnlineData.history.lotteries[online].description
            newLottery.numbers           = self.jsonOnlineData.history.lotteries[online].numbers
            newLottery.upperNumber       = self.jsonOnlineData.history.lotteries[online].upperNumber
            newLottery.specials          = self.jsonOnlineData.history.lotteries[online].specials
            newLottery.upperSpecial      = self.jsonOnlineData.history.lotteries[online].upperSpecial
            newLottery.bonus             = self.jsonOnlineData.history.lotteries[online].bonus
            newLottery.days              = []
            newLottery.days.append(contentsOf: getDaysOnlineLotteryPlayed(online: online))
            newLottery.active            = true
            self.jsonLocalData.history.lotteries.append(newLottery)
            return
        }
        
        //
        // need to check if the lotteries downloaded are recognised
        //
        // 1. if so have they changed, update if needed and let's tell the caller
        // 2. if not add it!
        //
        var changed: Bool = false
        
        for i: Int in 0 ..< self.jsonOnlineData.history.lotteries.count {
            let j: Int = findMatchingLocalLottery(online: i)
            if j > -1 {
                if isLotteryChanged(online: i, local: j) {
                    updateLocalLotteryDefaults(online: i, local: j)
                    changed = true
                }
            } else {
                addLocalLotteryDefaults(online: i)
                changed = true
            }
        }
        return changed
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
    // View handling
    //----------------------------------------------------------------------------
    func setupLotteryDisplays() {
        self.displayDraws = []
        for draw: LocalLottery in self.jsonLocalData.history.lotteries {
            self.displayDraws.append(LotteryDisplay(ident: draw.ident, numbers: draw.numbers, specials: draw.specials, bonus: draw.bonus, active: draw.active))
        }
        return
    }
    
    func setDisplayPositioning() {

        //
        // needs to deal with possible starting positions for 'numbers' with and without specials
        //
        func allocateNumberPositions(dimension: CGFloat, startHeight: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            var startx:      CGFloat = increment
            var positions:  [CGRect] = []
            for i: Int in 0 ..< draw.numbers {
                if (i % 2) == 1 {
                    positions.append(CGRect(x: startx, y: startHeight - (increment * 2), width: (increment * 2), height: (increment * 2)))
                } else {
                    positions.append(CGRect(x: startx, y: startHeight + (increment * 2), width: (increment * 2), height: (increment * 2)))
                }
                startx = startx + (dimension / CGFloat((draw.numbers * 2) + (draw.numbers + 1)) * 3)
            }
            return positions
        }
        
        func allocateNumberPositionsAtMidPoint(dimension: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            let startHeight: CGFloat = dimension / 2
            return allocateNumberPositions(dimension: dimension, startHeight: startHeight, increment: increment, draw: draw)
        }
        
        func allocateNumberPositionsAboveMidPoint(dimension: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            let startHeight: CGFloat = (dimension / 2) - (increment * 2)
            return allocateNumberPositions(dimension: dimension, startHeight: startHeight, increment: increment, draw: draw)
        }
        
        //
        // place the specials
        //
        func allocateSpecialPositions(dimension: CGFloat, startHeight: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            var startx:      CGFloat = increment
            var positions:  [CGRect] = []
            for _: Int in 0 ..< draw.specials {
                positions.append(CGRect(x: startx, y: startHeight, width: (increment * 2), height: (increment * 2)))
                startx = startx + (dimension / CGFloat((draw.numbers * 2) + (draw.numbers + 1)) * 3)
            }
            return positions
        }
        
        func allocateSpecialPositionsBelowMidPoint(dimension: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            let startHeight: CGFloat = (dimension / 2) + (increment * 2)
            return allocateSpecialPositions(dimension: dimension, startHeight: startHeight, increment: increment, draw: draw)
        }
        
        //
        // need to iterate thro lottery list to buold the Positioning objects
        //
        func processLotteries(dimension: CGFloat) -> [Positioning] {
            var forOrientation: [Positioning]  = []
            for lottery: LocalLottery in self.jsonLocalData.history.lotteries {
                var numbersPositions: [CGRect] = []
                var specialPositions: [CGRect] = []
                let incrementPosition: CGFloat = dimension / CGFloat((lottery.numbers * 2) + (lottery.numbers + 1))
                if lottery.specials == 0 {
                    numbersPositions.append(contentsOf: allocateNumberPositionsAtMidPoint(dimension: dimension, increment: incrementPosition, draw: lottery))
                } else {
                    numbersPositions.append(contentsOf: allocateNumberPositionsAboveMidPoint(dimension: dimension, increment: incrementPosition, draw: lottery))
                    specialPositions.append(contentsOf: allocateSpecialPositionsBelowMidPoint(dimension: dimension, increment: incrementPosition, draw: lottery))
                }
                forOrientation.append(Positioning(ident: lottery.ident, numberPositions: numbersPositions, specialPositions: specialPositions, active: true))
            }
            return forOrientation
        }
        
        //
        // for portrait / landscape build up positions for each
        //
        self.displayPosns = []
        let mainView: CGRect  = self.appViews[viewType.main.rawValue].bounds
        if UIDeviceOrientationIsLandscape(self.viewOrientation) {
            self.displayPosns.append(processLotteries(dimension: mainView.width))
            self.displayPosns.append(processLotteries(dimension: mainView.height))
        } else {
            self.displayPosns.append(processLotteries(dimension: mainView.height))
            self.displayPosns.append(processLotteries(dimension: mainView.width))
        }
        return
    }
    
    //
    // we need to attach the labels to the view where they are to be displayed
    // then depending on the initial orientation use the right Positioning
    // also keep in mind the active tab, as nonactive are not to be displayed
    //
    func addDisplayLabelsToMainView() {
        
        for i: Int in 0 ..< self.jsonLocalData.history.lotteries.count {
            if i == self.jsonLocalData.history.activetab {
                
            } else {

            }
        }
        
        
        
        for draw: Lottery in self.jsonLocalData.history.lotteries {
            if UIDeviceOrientationIsLandscape(self.viewOrientation) {
                
            } else {
                
            }
        }
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

