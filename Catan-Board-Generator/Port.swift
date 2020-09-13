import UIKit

class Port: NSObject {
    var portType: PortType
    var index: Int
    
    init(portType: PortType, index: Int) {
        self.portType = portType
        self.index = index
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if !(object is Port) {
            return false
        }
        let other = object as! Port
        return other.portType == self.portType &&
            other.index == self.index
    }
    
    override var hash: Int {
        let prime: Int = 31
        var result = 1
        result = prime * result + portType.hashValue
        result = prime * result + index
        return result
    }
}

