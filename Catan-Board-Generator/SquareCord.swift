import UIKit

class SquareCord: NSObject {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if !(object is SquareCord) {
            return false
        }
        let other = object as! SquareCord
        return other.x == self.x && other.y == self.y
    }
    
    override var hash: Int {
        let prime: Int = 31
        var result = 1
        result = prime * result + x
        result = prime * result + y
        return result
    }
}

