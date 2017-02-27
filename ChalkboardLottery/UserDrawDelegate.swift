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
    
    init(applicationVersion: Int) {
        super.init()
        self.draws = []
        self.updateUserDrawObjects()
        return
    }
    
    private func createBlankUserDrawHistory() -> [UserDraw] {
        let array: [UserDraw] = []
        return array
    }
    
    //-------------------------------------------------------------------------------
    // for cell storage, generate the 'text' names for the JSON file
    //-------------------------------------------------------------------------------
    private func translateDrawFromDictionary(dictDraws: [String: Int]) -> UserDraw {
        var draw: UserDraw = UserDraw()
        for (key, value) in dictDraws {
            switch key {
            case jsonHistoryDictionary.DrawDate.rawValue:
                draw.drawDate = value
                break
            case jsonHistoryDictionary.Numbers.rawValue:
                draw.numbers.append(contentsOf: value)
                break
            case jsonHistoryDictionary.Specials.rawValue:
                draw.specials.append(contentsOf: value)
                break
            default:
                break
            }
        }
        return cell
    }
    
    //-------------------------------------------------------------------------------
    // for Position storage, generate the 'text' names for the JSON file
    //-------------------------------------------------------------------------------
    private func translatePositionFromDictionary(dictCell: [String: Int]) -> Position {
        var posn: Position = Position(row: -1, column: -1)
        for (key, value) in dictCell {
            switch key {
            case posnDictionary.row.rawValue:
                posn.posn.row    = value
                break
            case posnDictionary.column.rawValue:
                posn.posn.column = value
                break
            default:
                break
            }
        }
        return posn
    }
    
    //-------------------------------------------------------------------------------
    // for Coordinate storage, generate the 'text' names for the JSON file
    //-------------------------------------------------------------------------------
    private func translateCoordinateFromDictionary(dictCell: [String: Int]) -> Coordinate {
        var coord: Coordinate = Coordinate(row: -1, column: -1, cell: (row: -1, column: -1))
        for (key, value) in dictCell {
            switch key {
            case cellDictionary.row.rawValue:
                coord.row         = value
                break
            case cellDictionary.col.rawValue:
                coord.column      = value
                break
            case cellDictionary.crow.rawValue:
                coord.cell.row    = value
                break
            case cellDictionary.ccol.rawValue:
                coord.cell.column = value
                break
            default:
                break
            }
        }
        return coord
    }
    
    //-------------------------------------------------------------------------------
    // now for user history scores / moves etc
    //-------------------------------------------------------------------------------
    private func translateUserHistoryFromDictionary(dictDiff: [String: Int]) -> GameHistory {
        var history: GameHistory!
        //
        // when we find the difficulty we can init the obj and then start to build it!
        //
        for (key, value) in dictDiff {
            if key == userGameHistory.difficulty.rawValue {
                history = GameHistory(difficulty: self.translateDifficulty(difficulty: value))
            }
        }
        //
        // should never happen, but if is does!
        //
        if history == nil {
            history = GameHistory()
        }
        //
        // now we can populate the object
        //
        for (key, value) in dictDiff {
            switch key {
            case userGameHistory.difficulty.rawValue:
                // already used this to create the obj so can be ignored
                break
            case userGameHistory.gamesStarted.rawValue:
                history.setStartedGames(games: value)
                break
            case userGameHistory.gamesCompleted.rawValue:
                history.setCompletedGames(games: value)
                break
            case userGameHistory.totalTimePlayed.rawValue:
                history.setTotalGameTimePlayed(time: value)
                break
            case userGameHistory.totalMovesMade.rawValue:
                history.setTotalPlayerMovesMade(moves: value)
                break
            case userGameHistory.totalMovesDeleted.rawValue:
                history.setTotalPlayerMovesDeleted(moves: value)
                break
            case userGameHistory.highestScore.rawValue:
                let _: Bool = history.setHighestScore(score: value)
                break
            case userGameHistory.lowestScore.rawValue:
                let _: Bool = history.setLowestScore(score: value)
                break
            case userGameHistory.fastestTime.rawValue:
                let _: Bool = history.setFastestTime(newTime: value)
                break
            case userGameHistory.slowestTime.rawValue:
                let _: Bool = history.setSlowestTime(newTime: value)
                break
            default:
                break
            }
        }
        return history
    }
    
    //-------------------------------------------------------------------------------
    // move between the enum values for image and active states to the Int value
    //-------------------------------------------------------------------------------
    func updateUserDrawObjects() {
        return
    }
    
    func convertCellEntry(cell: BoardCell) -> [String: Int] {
        var array: [String: Int] = [:]
        array[cellDictionary.row.rawValue]    = cell.row
        array[cellDictionary.col.rawValue]    = cell.col
        array[cellDictionary.crow.rawValue]   = cell.crow
        array[cellDictionary.ccol.rawValue]   = cell.ccol
        array[cellDictionary.value.rawValue]  = cell.value
        array[cellDictionary.image.rawValue]  = self.translateImageStateToInt(state: cell.image)
        array[cellDictionary.active.rawValue] = self.translateActiveStateToInt(state: cell.active)
        return array
    }
    
    func convertPositionEntry(posn: Position) -> [String: Int] {
        var array: [String: Int] = [:]
        array[posnDictionary.row.rawValue]    = posn.posn.row
        array[posnDictionary.column.rawValue] = posn.posn.column
        return array
    }
    
    func convertCoordinateEntry(coord: Coordinate) -> [String: Int] {
        var array: [String: Int] = [:]
        array[cellDictionary.row.rawValue]  = coord.row
        array[cellDictionary.col.rawValue]  = coord.column
        array[cellDictionary.crow.rawValue] = coord.cell.row
        array[cellDictionary.ccol.rawValue] = coord.cell.column
        return array
    }
    
    //-------------------------------------------------------------------------------
    // load/save to/from internal 'currentgame' state and save dictionary 'gameSave'
    //-------------------------------------------------------------------------------
    private func updateGameSaveValue(keyValue: String, value: Int) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    private func updateGameSaveValue(keyValue: String, value: Bool) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    private func updateGameSaveValue(keyValue: String, value: AnyObject) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    private func updateGameSaveValue(keyValue: String, value: [[String: Int]]) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    private func updateGameSaveValue(keyValue: String, value: [String: Int]) {
        self.gameSave[keyValue] = value as? AnyObject
        return
    }
    
    func loadGameSaveObjects() {
        self.currentGame.applicationVersion    = self.getGameStateValue(keyValue: saveGameDictionary.ApplicationVersion)
        self.currentGame.gameInPlay            = self.getGameStateValue(keyValue: saveGameDictionary.GameInPlay)
        self.currentGame.penaltyValue          = self.getGameStateValue(keyValue: saveGameDictionary.PenaltyValue)
        self.currentGame.penaltyIncrementValue = self.getGameStateValue(keyValue: saveGameDictionary.PenaltyIncrementValue)
        self.currentGame.currentGameTime       = self.getGameStateValue(keyValue: saveGameDictionary.CurrentGameTime)
        self.currentGame.gameMovesMade         = self.getGameStateValue(keyValue: saveGameDictionary.GameMovesMade)
        self.currentGame.gameMovesDeleted      = self.getGameStateValue(keyValue: saveGameDictionary.GameMovesDeleted)
        self.currentGame.gameCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.GameBoard) {
            self.currentGame.gameCells.append(self.translateCellFromDictionary(dictCell: cell))
        }
        self.currentGame.originCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.OriginBoard) {
            self.currentGame.originCells.append(self.translateCellFromDictionary(dictCell: cell))
        }
        self.currentGame.solutionCells.removeAll()
        for cell: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.SolutionBoard) {
            self.currentGame.solutionCells.append(self.translateCellFromDictionary(dictCell: cell))
        }
        self.currentGame.controlPanel.removeAll()
        for cell: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.ControlPanel) {
            self.currentGame.controlPanel.append(self.translateCellFromDictionary(dictCell: cell))
        }
        self.currentGame.controlPosn = self.translatePositionFromDictionary(dictCell: self.getGameStateValue(keyValue: saveGameDictionary.ControlPosition))
        self.currentGame.boardPosn   = self.translateCoordinateFromDictionary(dictCell: self.getGameStateValue(keyValue: saveGameDictionary.BoardPosition))
        //
        // for user history we already have objects in an array waiting, so they just need updating
        //
        for history: [String: Int] in self.getGameStateValue(keyValue: saveGameDictionary.UserHistory) {
            self.updateUserHistoryObject(history: self.translateUserHistoryFromDictionary(dictDiff: history))
        }
        return
    }
    
    private func updateUserHistoryObject(history: GameHistory) {
        for i: GameHistory in self.currentGame.userHistory {
            if i.getDifficulty() == history.getDifficulty() {
                i.setStartedGames(games: history.getStartedGames())
                i.setCompletedGames(games: history.getCompletedGames())
                i.setTotalGameTimePlayed(time: history.getTotalTimePlayed())
                i.setTotalPlayerMovesMade(moves: history.getTotalMovesMade())
                i.setTotalPlayerMovesDeleted(moves: history.getTotalMovedDeleted())
                let _: Bool = i.setHighestScore(score: history.getHighestScore())
                let _: Bool = i.setLowestScore(score: history.getLowestScore())
                let _: Bool = i.setFastestTime(newTime: history.getFastestGame())
                let _: Bool = i.setSlowestTime(newTime: history.getSlowestGame())
            }
        }
        return
    }
    
    //-------------------------------------------------------------------------------
    // pick out the dictionary 'keys/value' when we load the game
    // if we don't yet have a value return a default (when we might add a new entry)
    //-------------------------------------------------------------------------------
    private func getGameStateValue(keyValue: saveGameDictionary) -> AnyObject {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? ([] as AnyObject) : self.gameSave[keyValue.rawValue]!
    }
    
    private func getGameStateValue(keyValue: saveGameDictionary) -> Bool {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? false : self.gameSave[keyValue.rawValue] as! Bool
    }
    
    private func getGameStateValue(keyValue: saveGameDictionary) -> Int {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? 0 : self.gameSave[keyValue.rawValue] as! Int
    }
    
    private func getGameStateValue(keyValue: saveGameDictionary) -> String {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? "" : self.gameSave[keyValue.rawValue] as! String
    }
    
    private func getGameStateValue(keyValue: saveGameDictionary) -> [String: Int] {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? ([:]) : self.gameSave[keyValue.rawValue] as! [String : Int]
    }
    
    private func getGameStateValue(keyValue: saveGameDictionary) -> [[String: Int]] {
        return (self.gameSave.index(forKey: keyValue.rawValue) == nil) ? ([[:]]) : self.gameSave[keyValue.rawValue] as! [[String : Int]]
    }
    
    //-------------------------------------------------------------------------------
    // load/save the dictionary object
    //-------------------------------------------------------------------------------
    private func getFilename() -> String {
        let directory: String = getDocumentDirectory() + "/" + "chalkboardsudoku.json"
        return directory
    }
    
    private func getDocumentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func loadGame() {
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


