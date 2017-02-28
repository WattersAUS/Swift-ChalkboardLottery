//
//  UserDrawDelegate.swift
//  ChalkboardLottery
//
//  Created by Graham on 24/02/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//
//----------------------------------------------------------------------------
// this class allows retrieval of user defined draws stored on the device
// stored in JSON the data will determine also if the app needs to get the 
// online data
//----------------------------------------------------------------------------

import Foundation

protocol UserDrawDelegate: class {
    //
    // what we use to populate the pref dialog
    //
    var draws:         [UserDraw] { get set }
    //
    // allow a user to be able to save the prefs into the delegate via a helper function
    //
    var saveFunctions: [(Void) -> ()] { get set }
}

class UserDrawHandler: NSObject, UserDrawDelegate {

    internal var draws: [UserDraw] = []
    internal var saveFunctions: [(Void) -> ()]
    
    override init() {
        super.init()
        self.draws = []
        return
    }
    
    private func createBlankUserDrawHistory() -> [UserDraw] {
        let array: [UserDraw] = []
        return array
    }
    
    //-------------------------------------------------------------------------------
    // extract from the JSON values, build into
    //-------------------------------------------------------------------------------
    private func translateDrawFromDictionary(dictDraws: [String: AnyObject]) -> UserDraw {
        var draw: UserDraw = UserDraw()
        for (key, value) in dictDraws {
            switch key {
            case jsonUser.DrawDate.rawValue:
                draw.date = value as! String
                break
            case jsonUser.Numbers.rawValue:
                draw.numbers.append(value as! Int)
                break
            case jsonUser.Specials.rawValue:
                draw.specials.append(value as! Int)
                break
            default:
                break
            }
        }
        return draw
    }
    
    // placeholder function
    private func translateLotteryFromDictionary(dictLottery: [String: AnyObject]) -> [String: AnyObject] {
        return [:]
    }
    
    //-------------------------------------------------------------------------------
    // move between the enum values for image and active states to the Int value
    //-------------------------------------------------------------------------------
    func convertDrawEntry(draw: UserDraw) -> [String: AnyObject] {
        var array: [String: AnyObject]       = [:]
        array[jsonUser.DrawDate.rawValue]    = draw.date as AnyObject?
        array[jsonUser.Numbers.rawValue]     = draw.numbers as AnyObject?
        array[jsonUser.Specials.rawValue]    = draw.specials as AnyObject?
        return array
    }

    //-------------------------------------------------------------------------------
    // load/save the dictionary object
    //-------------------------------------------------------------------------------
    private func getFilename() -> String {
        let directory: String = getDocumentDirectory() + "/" + "chalkboardlottery.json"
        return directory
    }
    
    private func getDocumentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func loadDraws() {
        let filename: String = self.getFilename()
        do {
            let fileContents: String = try NSString(contentsOfFile: filename, usedEncoding: nil) as String
            let fileData: Data = fileContents.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            self.gameSave = try JSONSerialization.jsonObject(with: fileData, options: .allowFragments) as! Dictionary<String, AnyObject>
            self.loadGameSaveObjects()
        } catch {
            print("Failed to read to file: \(filename)")
        }
        return
    }
    
    func saveUserDraws() {
        self.updateUserDrawObjects()
        if JSONSerialization.isValidJSONObject(self.gameSave) { // True
            do {
                let rawData: Data = try JSONSerialization.data(withJSONObject: self.gameSave, options: .prettyPrinted)
                //Convert NSString to String
                let resultString: String = String(data: rawData as Data, encoding: String.Encoding.utf8)! as String
                let filename: String = self.getFilename()
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


