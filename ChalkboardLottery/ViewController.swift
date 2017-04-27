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
    var labelCollection: [LotteryDisplay] = []
    
    //
    // Positioning info we'll save for transitioning portrait / landscape for the draws
    //
    var displayPosns: [Positioning] = []
    
    //
    // prefs
    //
    var userPrefs: PreferencesHandler!
    
    //
    // views
    //
    var appViews:        [UIView] = []
    var mainViews:       [UIView] = []
    
    //----------------------------------------------------------------------------
    // Here we go!
    //----------------------------------------------------------------------------
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userPrefs  = PreferencesHandler()
        
        //
        // load the local user data / lotteries and draws, then go get the online
        //
        self.jsonLocalData = JSONLocalDelegateHandler()
        //
        // ** NEEDS WORK **
        //
        //self.jsonLocalData.loadLocalResults()
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
        
        return
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //----------------------------------------------------------------------------
    // Sound handling
    //----------------------------------------------------------------------------
    //
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
    // app transition events
    //----------------------------------------------------------------------------
    //
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
    // Set views positioning/size when orientation changes
    //----------------------------------------------------------------------------
    //
    override func viewWillLayoutSubviews() {
        if self.appViews.count == 0 {
            return
        }
        self.setViewOrientation(landscape: (view.bounds.size.width >= view.bounds.size.height))
        self.setLabelPositioning()
        self.updateLabelsPositioning()
    }
    
    func setViewOrientation(landscape: Bool) {

        func setViewsInPortraitOrientation() {
            let bounds: ViewBounds  = ViewBounds(screenWidth: self.view.bounds.width, screenHeight: self.view.bounds.height)
            let tabHeight:  CGFloat = bounds.yScale * 4
            let ctrlHeight: CGFloat = bounds.yScale * 4
            let tabRect:    CGRect  = CGRect(x: bounds.x, y: bounds.y,                                    width: bounds.w, height: tabHeight)
            let mainRect:   CGRect  = CGRect(x: bounds.x, y: bounds.y + tabRect.height,                   width: bounds.w, height: bounds.h - bounds.x - tabHeight - ctrlHeight)
            let ctrlRect:   CGRect  = CGRect(x: bounds.x, y: bounds.y + tabRect.height + mainRect.height, width: bounds.w, height: ctrlHeight)
            self.appViews[viewType.tab.rawValue].frame  = tabRect
            self.appViews[viewType.main.rawValue].frame = mainRect
            self.appViews[viewType.ctrl.rawValue].frame = ctrlRect
            return
        }
        
        func setViewsInLandscapeOrientation() {
            let bounds: ViewBounds = ViewBounds(screenWidth: self.view.bounds.width, screenHeight: self.view.bounds.height)
            let tabHeight: CGFloat = bounds.yScale * 4
            let ctrlWidth: CGFloat = bounds.xScale * 4
            let tabRect:   CGRect  = CGRect(x: bounds.x,                 y: bounds.y,                  width: bounds.w - bounds.x - ctrlWidth, height: tabHeight)
            let mainRect:  CGRect  = CGRect(x: bounds.x,                 y: bounds.y + tabRect.height, width: bounds.w - bounds.x - ctrlWidth, height: bounds.h - bounds.y - tabHeight)
            let ctrlRect:  CGRect  = CGRect(x: bounds.x + tabRect.width, y: bounds.y,                  width: ctrlWidth,                       height: bounds.h - bounds.y)
            self.appViews[viewType.tab.rawValue].frame  = tabRect
            self.appViews[viewType.main.rawValue].frame = mainRect
            self.appViews[viewType.ctrl.rawValue].frame = ctrlRect
            return
        }
        
        if landscape {
            setViewsInLandscapeOrientation()
        } else {
            setViewsInPortraitOrientation()
        }
        
        //
        // reflect the main view size change to the active lottery view only
        //
        for mainView: UIView in self.mainViews {
            if mainView.isHidden {
                continue
            } else {
                mainView.frame = CGRect(x: 0, y: 0, width: self.appViews[viewType.main.rawValue].frame.width, height: self.appViews[viewType.main.rawValue].frame.height)
            }
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // Set main views positioning/size when orientation changes
    //----------------------------------------------------------------------------
    // we need to attach each set of labels (for a lottery) to the corresponding 'main' view
    // where they may be displayed
    //
    // the positioning is calculated when the view orientation changes (see viewWillLayoutSubviews)
    //
    func addLabelsToMainViews() {
        for j: Int in 0 ..< self.mainViews.count {
            for i: Int in 0 ..< self.labelCollection[j].numbers.count {
                self.labelCollection[j].numbers[i].displayLabel.frame.origin.x = self.displayPosns[j].numbers[i].minX
                self.labelCollection[j].numbers[i].displayLabel.frame.origin.y = self.displayPosns[j].numbers[i].minY
                self.mainViews[j].addSubview(self.labelCollection[j].numbers[i].displayLabel)
            }
        }
        return
    }
    
    func updateLabelsPositioning() {
        for j: Int in 0 ..< self.mainViews.count {
            for i: Int in 0 ..< self.labelCollection[j].numbers.count {
                self.labelCollection[j].numbers[i].displayLabel.frame.origin.x = self.displayPosns[j].numbers[i].minX
                self.labelCollection[j].numbers[i].displayLabel.frame.origin.y = self.displayPosns[j].numbers[i].minY
            }
        }
        return
    }
    
    //----------------------------------------------------------------------------
    // 1. On the first run, need to sync up lottery defaults
    // 2. If we didn't connect keep reminding the user until we do
    //----------------------------------------------------------------------------
    //
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
        // we can start building the 'main' views (for now make the first active)
        //
        self.jsonLocalData.history.activetab = 0

        //
        // now we have the 'loaded' lotteries we can build displays and positioning
        //
        self.setupInitialViews()
        self.setupLabelsForLotteries()
        self.setLabelPositioning()
        self.addLabelsToMainViews()
        return
    }


    //----------------------------------------------------------------------------
    // View handling, positioning of labels in response to orientation changes
    //----------------------------------------------------------------------------
    //
    func setupInitialViews() {

        //
        // setup view holders for tab. main and control (we'll set size and position later)
        //
        self.appViews = []
        self.appViews.append(UIView(frame: CGRect(x: 0, y: 0,   width: 100, height: 100)))
        self.appViews.append(UIView(frame: CGRect(x: 0, y: 200, width: 100, height: 100)))
        self.appViews.append(UIView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
        
        //
        // setup dummy bg colours for debug on the view holders
        //
        self.appViews[viewType.tab.rawValue].backgroundColor  = UIColor.blue
        self.appViews[viewType.main.rawValue].backgroundColor = UIColor.red
        self.appViews[viewType.ctrl.rawValue].backgroundColor = UIColor.green
        
        //
        // one view for each lottery (only one will be visible at a time), show the first only for now
        //
        self.mainViews = []
        self.mainViews.append(UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        self.mainViews.append(UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        self.mainViews.append(UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        self.mainViews[0].backgroundColor = UIColor.lightGray
        self.mainViews[1].backgroundColor = UIColor.darkGray
        self.mainViews[2].backgroundColor = UIColor.brown
        self.mainViews[0].isHidden = false
        self.mainViews[1].isHidden = true
        self.mainViews[2].isHidden = true
        
        //
        // attach to the 'main' view holder
        //
        self.appViews[viewType.main.rawValue].addSubview(self.mainViews[0])
        self.appViews[viewType.main.rawValue].addSubview(self.mainViews[1])
        self.appViews[viewType.main.rawValue].addSubview(self.mainViews[2])
        
        //
        // add to the main view
        //
        self.view.addSubview(self.appViews[viewType.tab.rawValue])
        self.view.addSubview(self.appViews[viewType.main.rawValue])
        self.view.addSubview(self.appViews[viewType.ctrl.rawValue])
        return
    }
    
    func setupLabelsForLotteries() {
        self.labelCollection = []
        for draw: LocalLottery in self.jsonLocalData.history.lotteries {
            self.labelCollection.append(LotteryDisplay(ident: draw.ident, numbers: draw.numbers, specials: draw.specials, bonus: draw.bonus, active: draw.active))
        }
        return
    }
    
    func setLabelPositioning() {

        //
        // needs to deal with possible starting positions for 'numbers' with and without specials
        //
        func setNumberPositions(dimension: CGFloat, startHeight: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            var startx:      CGFloat = increment
            var positions:  [CGRect] = []
            for i: Int in 0 ..< draw.numbers {
                if (i % 2) == 0 {
                    positions.append(CGRect(x: startx, y: startHeight - (increment * 2), width: (increment * 2), height: (increment * 2)))
                } else {
                    positions.append(CGRect(x: startx, y: startHeight + (increment * 2), width: (increment * 2), height: (increment * 2)))
                }
                startx = startx + (dimension / CGFloat((draw.numbers * 2) + (draw.numbers + 1)) * 3)
            }
            return positions
        }
        
        func setNumberPositionsAtMidPoint(dimension: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            let startHeight: CGFloat = dimension / 2
            return setNumberPositions(dimension: dimension, startHeight: startHeight, increment: increment, draw: draw)
        }
        
        func setNumberPositionsAboveMidPoint(dimension: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            let startHeight: CGFloat = (dimension / 2) - (increment * 2)
            return setNumberPositions(dimension: dimension, startHeight: startHeight, increment: increment, draw: draw)
        }
        
        //
        // place the specials (if any)
        //
        func setSpecialPositions(dimension: CGFloat, startHeight: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            var startx:      CGFloat = increment
            var positions:  [CGRect] = []
            for _: Int in 0 ..< draw.specials {
                positions.append(CGRect(x: startx, y: startHeight, width: (increment * 2), height: (increment * 2)))
                startx = startx + (dimension / CGFloat((draw.numbers * 2) + (draw.numbers + 1)) * 3)
            }
            return positions
        }
        
        func setSpecialPositionsBelowMidPoint(dimension: CGFloat, increment: CGFloat, draw: LocalLottery) -> [CGRect] {
            let startHeight: CGFloat = (dimension / 2) + (increment * 2)
            return setSpecialPositions(dimension: dimension, startHeight: startHeight, increment: increment, draw: draw)
        }
        
        //
        // need to iterate thro lottery list to build the Positioning objects
        //
        func positionLotteries(dimension: CGFloat) -> [Positioning] {
            var forOrientation: [Positioning]  = []
            for lottery: LocalLottery in self.jsonLocalData.history.lotteries {
                var numbersPositions: [CGRect] = []
                var specialPositions: [CGRect] = []
                let incrementPosition: CGFloat = dimension / CGFloat((lottery.numbers * 2) + (lottery.numbers + 1))
                if lottery.specials == 0 {
                    numbersPositions.append(contentsOf: setNumberPositionsAtMidPoint(dimension: dimension, increment: incrementPosition, draw: lottery))
                } else {
                    numbersPositions.append(contentsOf: setNumberPositionsAboveMidPoint(dimension: dimension, increment: incrementPosition, draw: lottery))
                    specialPositions.append(contentsOf: setSpecialPositionsBelowMidPoint(dimension: dimension, increment: incrementPosition, draw: lottery))
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
        self.displayPosns = positionLotteries(dimension: mainView.width)
        return
    }
    
//    //----------------------------------------------------------------------------
//    // Touch Setup / detection
//    //----------------------------------------------------------------------------
//    //
//    func processUserTapOnMainScreen(location: CGPoint) -> (row: Int, column: Int) {
////        for y: Int in 0 ..< self.controlPanelImages.getRows() {
////            for x: Int in 0 ..< self.controlPanelImages.getColumns() {
////                if self.isTapWithinImage(location: location, image: self.controlPanelImages.contents[y][x].imageView) == true {
////                    return(y, x)
////                }
////            }
////        }
//        
//        func foundTapInTabsMenu() -> Bool {
//            // 1. run thro array of labels and does tap fall in boundaries of one of the labels
//            // 2. use the 'index' into the array
//            return false
//        }
//        
//        func foundTapInNumbers() -> Bool {
//            return false
//        }
//        
//        func foundTapInSpecials() -> Bool {
//            return false
//        }
//        
//        func foundTapInOptions() -> Bool {
//            return false
//        }
//        
//        if foundTapInTabsMenu() == false {
//            if foundTapInNumbers() == false {
//                if foundTapInSpecials() == false {
//                    if foundTapInOptions() == true {
//                        
//                    }
//                }
//            }
//        }
//        return(-1, -1)
//    }
//    
//    func isTapWithinImage(location: CGPoint, image: UIImageView) -> Bool {
//        if (location.x >= image.frame.origin.x) && (location.x <= (image.frame.origin.x + image.frame.width)) {
//            if (location.y >= image.frame.origin.y) && (location.y <= (image.frame.origin.y + image.frame.height)) {
//                return true
//            }
//        }
//        return false
//    }
//    
//    func isTapWithinLabel(location: CGPoint, label: UILabel) -> Bool {
//        if (location.x >= label.frame.origin.x) && (location.x <= (label.frame.origin.x + label.frame.width)) {
//            if (location.y >= label.frame.origin.y) && (location.y <= (label.frame.origin.y + label.frame.height)) {
//                return true
//            }
//        }
//        return false
//    }
    
    //----------------------------------------------------------------------------
    // default lottery setup (JSON parsing)
    //----------------------------------------------------------------------------
    // parse through draws extracting the date played (YYYY-MM-DD) to give 'day number' game was played (0 - 6)
    //
    func getDaysOnlineLotteryPlayed(online: OnlineLottery) -> [Int] {
        
        func getDayNumberGamePlayed(draw: String) -> Int {
            let dateFormat        = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            let drawDate          = dateFormat.date(from: draw)!
            let calendar          = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            return calendar.components(.weekday, from: drawDate).weekday!
        }
        
        var daysPlayed: [Int] = []
        for i: OnlineDraw in online.draws {
            let day: Int = getDayNumberGamePlayed(draw: i.date) - 1
            if !daysPlayed.contains(day) {
                daysPlayed.append(day)
            }
        }
        return daysPlayed.sorted()
    }
    
    //
    // only used if we've saved local results before
    //
    func setupLocalLotteryDefaults() {
        self.jsonLocalData.history.lotteries = []
        for online: OnlineLottery in self.jsonOnlineData.history.lotteries {
            var local: LocalLottery = LocalLottery()
            local.ident        = online.ident
            local.description  = online.description
            local.numbers      = online.numbers
            local.upperNumber  = online.upperNumber
            local.specials     = online.specials
            local.upperSpecial = online.upperSpecial
            local.bonus        = online.bonus
            local.days         = []
            local.days.append(contentsOf: getDaysOnlineLotteryPlayed(online: online))
            local.active       = true
            self.jsonLocalData.history.lotteries.append(local)
        }
        return
    }
    
    //
    // if we've had a save, need to compare online settings and see they haven't changed since the last save
    //
    func checkLotteryDefaults() -> Bool {
        
        func isLotteryChanged(local: LocalLottery, online: OnlineLottery) -> Bool {
            if local.numbers       == online.numbers &&
                local.upperNumber  == online.upperNumber &&
                local.specials     == online.specials &&
                local.upperSpecial == online.upperSpecial &&
                local.bonus        == online.bonus {
                return true
            }
            return false
        }
        
        func findMatchingLocalLottery(online: OnlineLottery) -> lotteryIdent {
            for local: LocalLottery in self.jsonLocalData.history.lotteries {
                if local.ident == online.ident {
                    return local.ident
                }
            }
            return lotteryIdent.Undefined
        }
        
        func updateLocalLotteryDefaults(local: inout LocalLottery, online: OnlineLottery) {
            local.description  = online.description
            local.numbers      = online.numbers
            local.upperNumber  = online.upperNumber
            local.specials     = online.specials
            local.upperSpecial = online.upperSpecial
            local.bonus        = online.bonus
            local.days         = []
            local.days.append(contentsOf: getDaysOnlineLotteryPlayed(online: online))
            local.active       = true
            return
        }
        
        func addLocalLotteryDefaults(online: OnlineLottery) -> LocalLottery {
            var newLottery: LocalLottery = LocalLottery()
            newLottery.ident             = online.ident
            newLottery.description       = online.description
            newLottery.numbers           = online.numbers
            newLottery.upperNumber       = online.upperNumber
            newLottery.specials          = online.specials
            newLottery.upperSpecial      = online.upperSpecial
            newLottery.bonus             = online.bonus
            newLottery.days              = []
            newLottery.days.append(contentsOf: getDaysOnlineLotteryPlayed(online: online))
            newLottery.active            = true
            return newLottery
        }
        
        //
        // need to check if the lotteries downloaded are recognised
        //
        // 1. if so have they changed, update if needed and let's tell the caller
        // 2. if not add it!
        //
        var changed: Bool = false
        for online: OnlineLottery in self.jsonOnlineData.history.lotteries {
            let local: lotteryIdent = findMatchingLocalLottery(online: online)
            if local == lotteryIdent.Undefined {
                self.jsonLocalData.history.lotteries.append(addLocalLotteryDefaults(online: online))
                changed = true
            } else {
                if isLotteryChanged(local: self.jsonLocalData.history.lotteries[local.rawValue], online: online) {
                    updateLocalLotteryDefaults(local: &self.jsonLocalData.history.lotteries[local.rawValue], online: online)
                    changed = true
                }
            }
        }
        
        
        
        return changed
    }
    
}

