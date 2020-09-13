import UIKit

class Board: NSObject {
    static let NUM_SIDES = 30
    static let NUM_PORTS = 9
    static let ROW_SIZES = [3, 4, 5, 4, 3]
    static let NUM_ROWS = 5
    
    let squares: [Square]
    let ports: [Port]
    
    override init() {
        self.squares = Board.createSquares()
        self.ports = Board.createPorts()
    }
    
    private class func createSquares() -> [Square] {
        let DICE_NUMS: [Int] = [ 5, 2, 6, 3, 8, 10, 9, 12, 11, 4, 8, 10, 9, 4, 5, 6, 3, 11]
        let CENTER_SQUARE: SquareCord = SquareCord(x: 2, y: 2)
        let INNER_CIRCLE_SQUARES: [SquareCord] = [SquareCord(x: 1, y: 1),
                                                  SquareCord(x: 2, y: 1),
                                                  SquareCord(x: 3, y: 2),
                                                  SquareCord(x: 2, y: 3),
                                                  SquareCord(x: 1, y: 3),
                                                  SquareCord(x: 1, y: 2)]
        let OUTTER_CIRCLE_SQUARES: [SquareCord] = [SquareCord(x: 0, y: 0),
                                                   SquareCord(x: 1, y: 0),
                                                   SquareCord(x: 2, y: 0),
                                                   SquareCord(x: 3, y: 1),
                                                   SquareCord(x: 4, y: 2),
                                                   SquareCord(x: 3, y: 3),
                                                   SquareCord(x: 2, y: 4),
                                                   SquareCord(x: 1, y: 4),
                                                   SquareCord(x: 0, y: 4),
                                                   SquareCord(x: 0, y: 3),
                                                   SquareCord(x: 0, y: 2),
                                                   SquareCord(x: 0, y: 1)]
        let ITERATION_ORDER: [SquareCord] = [CENTER_SQUARE] + INNER_CIRCLE_SQUARES + OUTTER_CIRCLE_SQUARES
        let NUM_OUTTER_SQUARE_CIRCLE: Int = OUTTER_CIRCLE_SQUARES.count
        let NUM_INNER_SQUARE_CIRCLE: Int = INNER_CIRCLE_SQUARES.count
        let CLUSTER_THRESHOLD: Int = 2
        let RED_NUM_THRESHOLD: Int = 2
        let SQUARE_TYPE_COUNTS: [SquareType:Int] = [SquareType.BRICK: 3,
                                                    SquareType.DESERT: 1,
                                                    SquareType.ORE: 3,
                                                    SquareType.SHEEP: 4,
                                                    SquareType.WHEAT: 4,
                                                    SquareType.WOOD: 4]
        
        func getNeighbors(parent: Square, squares: [Square]) -> [Square] {
            let neighborSquareCords: [SquareCord] = getSquareCordNeighbors(parent: parent.squareCord)
            var result: [Square] = []
            for neighbor in neighborSquareCords {
                result.append(getSquareWithSquareCord(squareCord: neighbor, squares: squares)!)
            }
            return result
        }
        
        func getSquareCordNeighbors(parent: SquareCord) -> [SquareCord] {
            func squareCordIsInBounds(squareCord: SquareCord) -> Bool {
                return squareCord.y >= 0 && squareCord.y <= Board.NUM_ROWS - 1 &&
                    squareCord.x >= 0 && squareCord.x <= Board.ROW_SIZES[squareCord.y] - 1
            }
            
            let childA = SquareCord(x: parent.x + 1, y: parent.y)
            let childB = SquareCord(x: parent.x - 1, y: parent.y)
            let childC = SquareCord(x: parent.x, y: parent.y - 1)
            let childD = SquareCord(x: parent.x, y: parent.y + 1)
            var childE: SquareCord! = nil
            var childF: SquareCord! = nil
            if parent.y == Board.NUM_ROWS - 1 || Board.ROW_SIZES[parent.y] > Board.ROW_SIZES[parent.y + 1] {
                childE = SquareCord(x: parent.x - 1, y: parent.y + 1)
            } else  {
                childE = SquareCord(x: parent.x + 1, y: parent.y + 1)
            }
            if parent.y == 0 || Board.ROW_SIZES[parent.y] > Board.ROW_SIZES[parent.y - 1] {
                childF = SquareCord(x: parent.x - 1, y: parent.y - 1)
            } else {
                childF = SquareCord(x: parent.x + 1, y: parent.y - 1)
            }
            var result: [SquareCord] = []
            if squareCordIsInBounds(squareCord: childA) {
                result.append(childA)
            }
            
            if squareCordIsInBounds(squareCord: childB) {
                result.append(childB)
            }
            
            if squareCordIsInBounds(squareCord: childC) {
                result.append(childC)
            }
            
            if squareCordIsInBounds(squareCord: childD) {
                result.append(childD)
            }
            
            if squareCordIsInBounds(squareCord: childE) {
                result.append(childE)
            }
            
            if squareCordIsInBounds(squareCord: childF) {
                result.append(childF)
            }
            return result
        }
        
        func getSquares() -> [Square] {
            func getSquaresHelper(map: inout [SquareCord:[SquareType:Int]], index: Int, list: inout [SquareType], result: inout [Square]) -> Bool {
                if index == ITERATION_ORDER.count {
                    return true
                } else {
                    let currSquareCord: SquareCord = ITERATION_ORDER[index]
                    let neighbors: [SquareCord] = getSquareCordNeighbors(parent: currSquareCord)
                    var arr: [Int] = Array(0...(list.count - 1))
                    Utils.shuffle(&arr)
                    for i in arr {
                        let currSquareType: SquareType = list[i]
                        if map[currSquareCord]![currSquareType]! == 0 {
                            list.remove(at: i)
                            for neighbor in neighbors {
                                map[neighbor]![currSquareType]! = map[neighbor]![currSquareType]! + 1
                            }
                            result.append(Square(squareType: currSquareType, squareCord: currSquareCord))
                            let worked: Bool = getSquaresHelper(map: &map, index: index + 1, list: &list, result: &result)
                            if worked {
                                return true
                            } else {
                                list.insert(currSquareType, at: i)
                                for neighbor in neighbors {
                                    map[neighbor]![currSquareType]! = map[neighbor]![currSquareType]! - 1
                                }
                                result.remove(at: result.count - 1)
                            }
                        }
                    }
                    return false
                }
            }
            
            
            
            var map: [SquareCord:[SquareType:Int]] = [:]
            for squareCord in ITERATION_ORDER {
                var squareTypeMap: [SquareType:Int] = [:]
                for squareType in SQUARE_TYPE_COUNTS {
                    squareTypeMap[squareType.key] = 0
                }
                map[squareCord] = squareTypeMap
            }
            
            var list: [SquareType] = []
            for squareTypeCount in SQUARE_TYPE_COUNTS {
                for _ in 1...squareTypeCount.value {
                    list.append(squareTypeCount.key)
                }
            }
            
            var result: [Square] = []
            let _ = getSquaresHelper(map: &map, index: 0, list: &list, result: &result)
            return result
        }
        
        func getSquareWithSquareCord(squareCord: SquareCord, squares: [Square]) -> Square? {
            for square in squares {
                if square.squareCord.isEqual(squareCord) {
                    return square
                }
            }
            return nil
        }
        
        func placeDiceNums(squares: inout [Square]) {
            var startIndex: Int = Utils.random(0, NUM_OUTTER_SQUARE_CIRCLE - 1)
            var diceNumIndex: Int = 0
            for i in 0...(NUM_OUTTER_SQUARE_CIRCLE - 1) {
                let square: Square = getSquareWithSquareCord(squareCord: OUTTER_CIRCLE_SQUARES[(startIndex + i) % NUM_OUTTER_SQUARE_CIRCLE], squares: squares)!
                if square.squareType != SquareType.DESERT {
                    square.number = DICE_NUMS[diceNumIndex]
                    diceNumIndex += 1
                }
            }
            
            var shuffledRemainingDiceNumbers: [Int] = Array(DICE_NUMS[diceNumIndex...(DICE_NUMS.count - 1)])
            Utils.shuffle(&shuffledRemainingDiceNumbers)
            diceNumIndex = 0
            
            startIndex = Utils.random(0, NUM_INNER_SQUARE_CIRCLE - 1)
            for i in 0...(NUM_INNER_SQUARE_CIRCLE - 1) {
                let square: Square = getSquareWithSquareCord(squareCord: INNER_CIRCLE_SQUARES[(startIndex + i) % NUM_INNER_SQUARE_CIRCLE], squares: squares)!
                if square.squareType != SquareType.DESERT {
                    square.number = shuffledRemainingDiceNumbers[diceNumIndex]
                    diceNumIndex += 1
                }
            }
            
            let centerSquare: Square = getSquareWithSquareCord(squareCord: CENTER_SQUARE, squares: squares)!
            if centerSquare.squareType != SquareType.DESERT {
                centerSquare.number = shuffledRemainingDiceNumbers[diceNumIndex]
            }
        }
        
        func squaresAreFair(squares: [Square]) -> Bool {
            func redNumsDistributed() -> Bool {
                var map: [SquareType:Int] = [:]
                for square in squares {
                    if square.isRedNum() {
                        if map[square.squareType] == nil {
                            map[square.squareType] = 0
                        }
                        map[square.squareType] = map[square.squareType]! + 1
                        if map[square.squareType]! > RED_NUM_THRESHOLD {
                            return false
                        }
                    }
                }
                return true
            }
            
            func redNumsNotTouching() -> Bool {
                for square in squares {
                    if square.isRedNum() {
                        let neighbors: [Square] = getNeighbors(parent: square, squares: squares)
                        for neighbor in neighbors {
                            if neighbor.isRedNum() {
                                return false
                            }
                        }
                    }
                }
                return true
            }
            
            return redNumsDistributed() && redNumsNotTouching()
        }
        
        func swapSquareTypes(squares: inout [Square]) {
            if CLUSTER_THRESHOLD > 0 {
                var index: Int = Utils.random(0, ITERATION_ORDER.count - 1)
                for _ in 1...CLUSTER_THRESHOLD {
                    let nextIndex: Int = Utils.random(0, ITERATION_ORDER.count - 1)
                    let temp = squares[index].squareType
                    squares[index].squareType = squares[nextIndex].squareType
                    squares[nextIndex].squareType = temp
                    // Utils.swap(&squares[index].squareType, &squares[nextIndex].squareType)
                    index = nextIndex
                }
            }
        }
        
        while true {
            var result: [Square] = getSquares()
            swapSquareTypes(squares: &result)
            placeDiceNums(squares: &result)
            if squaresAreFair(squares: result) {
                return result
            }
        }
    }
    
    private class func createPorts() -> [Port] {
        var portTypes = [PortType.BRICK,
                         PortType.ORE,
                         PortType.SHEEP,
                         PortType.WHEAT,
                         PortType.WOOD,
                         PortType.THREE_FOR_ONE,
                         PortType.THREE_FOR_ONE,
                         PortType.THREE_FOR_ONE,
                         PortType.THREE_FOR_ONE]
        
        func getIndices() -> [Int] {
            var gapSizes: [Int] = [ 2, 2, 2, 2, 2, 2, 3, 3, 3 ]
            Utils.shuffle(&gapSizes)
            var result: [Int] = []
            var index: Int = Utils.random(0, Board.NUM_SIDES - 1)
            for i in 0...(Board.NUM_PORTS - 1) {
                result.append(index)
                index = (index + gapSizes[i] + 1) % Board.NUM_SIDES
            }
            return result
        }
        
        func isDistributed(ports: [Port]) -> Bool {
            for i in 0...(ports.count - 1) {
                if (ports[i].portType == PortType.THREE_FOR_ONE &&
                    ports[(i + 1) % ports.count].portType == PortType.THREE_FOR_ONE &&
                    ports[(i + 2) % ports.count].portType == PortType.THREE_FOR_ONE) {
                    
                    return false
                }
            }
            return true
        }
        
        while true {
            let portIndices: [Int] = getIndices()
            Utils.shuffle(&portTypes)
            var result: [Port] = []
            
            for i in 0...(portIndices.count - 1) {
                result.append(Port(portType: portTypes[i], index: portIndices[i]))
            }
            
            if isDistributed(ports: result) {
                return result
            }
        }
    }
}

