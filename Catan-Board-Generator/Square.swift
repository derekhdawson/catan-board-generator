import UIKit

class Square: NSObject {
    var squareType: SquareType!
    var number: Int!
    var squareCord: SquareCord!
    var x: Int!
    var y: Int!
    
    init(squareType: SquareType, number: Int, squareCord: SquareCord) {
        self.squareType = squareType
        self.number = number
        self.squareCord = squareCord
        self.x = squareCord.x
        self.y = squareCord.y
    }
    
    convenience init(squareType: SquareType, squareCord: SquareCord) {
        self.init(squareType: squareType, number: -1, squareCord: squareCord)
    }
    
    convenience init(squareType: SquareType, x: Int, y: Int) {
        self.init(squareType: squareType, squareCord: SquareCord(x: x, y: y))
    }
    
    func isRedNum() -> Bool {
        return number == 6 || number == 8
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if !(object is Square) {
            return false
        }
        let other = object as! Square
        return other.squareType == self.squareType &&
            other.number == self.number &&
            other.squareCord.isEqual(self.squareCord)
    }
    
    override var hash: Int {
        let prime: Int = 31
        var result = 1
        result = prime * result + x
        result = prime * result + y
        result = prime * result + number
        result = prime * result + squareType.hashValue
        return result
    }
}

