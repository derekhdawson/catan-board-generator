

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    var tileColorMap = [SquareType.BRICK: 0x94410B,
                        SquareType.WOOD: 0x5A5C34,
                        SquareType.WHEAT: 0xFBD769,
                        SquareType.ORE: 0x878A8F,
                        SquareType.SHEEP: 0xA5AF3D,
                        SquareType.DESERT: 0xC4AF73]
    
    var portColorMap = [PortType.BRICK: 0x94410B,
                        PortType.ORE: 0x878A8F,
                        PortType.SHEEP: 0xA5AF3D,
                        PortType.THREE_FOR_ONE: 0xFFFFFF,
                        PortType.WHEAT: 0xFBD769,
                        PortType.WOOD: 0x5A5C34]
    
    private var portMap: [Int: SquareCordSide]!
    var hexMap: [SquareCord: UITile] = [:]
    var coastCords: [SquareCord]!
    
    var boardArea: UIView!
    var generateButton: UIButton!
    var hexWidth: CGFloat!
    var player: AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hexWidth = view.frame.width / 6.25
        let generateButton = createGenerateButton()
        let top = (view.frame.height - hexWidth * 4)
        boardArea = UIView(frame: CGRect(x: 0, y: top, width: view.frame.width, height: view.frame.height - top))
        boardArea.center = CGPoint(x: view.center.x, y: generateButton.frame.origin.y / 2 + 20)
        portMap = getPortMap()
        createNewBoard()
        view.addSubview(boardArea)
    }
    
    private func getPortMap() -> [Int: SquareCordSide] {
        var portMap: [Int: SquareCordSide] = [:]
        portMap[0] = SquareCordSide(squareCord: SquareCord(x: 0, y: 0), side: 5)
        portMap[1] = SquareCordSide(squareCord: SquareCord(x: 0, y: 0), side: 4)
        portMap[2] = SquareCordSide(squareCord: SquareCord(x: 0, y: 0), side: 3)
        portMap[3] = SquareCordSide(squareCord: SquareCord(x: 0, y: 1), side: 4)
        portMap[4] = SquareCordSide(squareCord: SquareCord(x: 0, y: 1), side: 3)
        portMap[5] = SquareCordSide(squareCord: SquareCord(x: 0, y: 2), side: 4)
        portMap[6] = SquareCordSide(squareCord: SquareCord(x: 0, y: 2), side: 3)
        portMap[7] = SquareCordSide(squareCord: SquareCord(x: 0, y: 2), side: 2)
        portMap[8] = SquareCordSide(squareCord: SquareCord(x: 0, y: 3), side: 3)
        portMap[9] = SquareCordSide(squareCord: SquareCord(x: 0, y: 3), side: 2)
        portMap[10] = SquareCordSide(squareCord: SquareCord(x: 0, y: 4), side: 3)
        portMap[11] = SquareCordSide(squareCord: SquareCord(x: 0, y: 4), side: 2)
        portMap[12] = SquareCordSide(squareCord: SquareCord(x: 0, y: 4), side: 1)
        portMap[13] = SquareCordSide(squareCord: SquareCord(x: 1, y: 4), side: 2)
        portMap[14] = SquareCordSide(squareCord: SquareCord(x: 1, y: 4), side: 1)
        portMap[15] = SquareCordSide(squareCord: SquareCord(x: 2, y: 4), side: 2)
        portMap[16] = SquareCordSide(squareCord: SquareCord(x: 2, y: 4), side: 1)
        portMap[17] = SquareCordSide(squareCord: SquareCord(x: 2, y: 4), side: 6)
        portMap[18] = SquareCordSide(squareCord: SquareCord(x: 3, y: 3), side: 1)
        portMap[19] = SquareCordSide(squareCord: SquareCord(x: 3, y: 3), side: 6)
        portMap[20] = SquareCordSide(squareCord: SquareCord(x: 4, y: 2), side: 1)
        portMap[21] = SquareCordSide(squareCord: SquareCord(x: 4, y: 2), side: 6)
        portMap[22] = SquareCordSide(squareCord: SquareCord(x: 4, y: 2), side: 5)
        portMap[23] = SquareCordSide(squareCord: SquareCord(x: 3, y: 1), side: 6)
        portMap[24] = SquareCordSide(squareCord: SquareCord(x: 3, y: 1), side: 5)
        portMap[25] = SquareCordSide(squareCord: SquareCord(x: 2, y: 0), side: 6)
        portMap[26] = SquareCordSide(squareCord: SquareCord(x: 2, y: 0), side: 5)
        portMap[27] = SquareCordSide(squareCord: SquareCord(x: 2, y: 0), side: 4)
        portMap[28] = SquareCordSide(squareCord: SquareCord(x: 1, y: 0), side: 5)
        portMap[29] = SquareCordSide(squareCord: SquareCord(x: 1, y: 0), side: 4)
        return portMap
    }
    
    func createGenerateButton() -> UIButton {
        var m: CGFloat = 1.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            m = 1.5
        }
        generateButton = UIButton()
        generateButton.frame.size = CGSize(width: 180 * m, height: 45 * m)
        generateButton.center = CGPoint(x: view.center.x, y: view.frame.height - 70 * m)
        generateButton.backgroundColor = UIColor(rgb: 0xD3D3D3)
        generateButton.setTitle("Generate", for: .normal)
        generateButton.setTitleColor(UIColor(rgb: 0x434343), for: .normal)
        generateButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18 * m)
        generateButton.layer.cornerRadius = generateButton.frame.width / 7.5
        generateButton.addTarget(self, action: #selector(self.generatedBoardTapped), for: .touchUpInside)
        generateButton.addTarget(self, action: #selector(self.generateButtonDown), for: .touchDown)
        generateButton.addTarget(self, action: #selector(self.generateButtonUp), for: .touchUpOutside)
        generateButton.alpha = 0.95
        generateButton.layer.borderColor = UIColor.black.cgColor
        view.addSubview(generateButton)
        return generateButton
    }
    
    @objc func generateButtonDown() {
        generateButton.titleLabel?.alpha = 0.5
    }
    
    @objc func generateButtonUp() {
        generateButton.titleLabel?.alpha = 1
    }
    
    @objc func generatedBoardTapped() {
        generateButtonUp()
        playSound()
        clearOldBoard()
        createNewBoard()
    }

    
    func createNewBoard() {
        let board = Board()
        placeSquares(board: board)
        placePorts(board: board)
    }
    
    func clearOldBoard() {
        for subview in boardArea.subviews {
            subview.removeFromSuperview()
        }
        if let sublayers = boardArea.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func placeSquares(board: Board) {
        let squares = board.squares
        for square in squares {
            let row = square.y!
            let col = square.x!
            let xOffSet = (view.frame.width - hexWidth * 5) / 2
            let x = xOffSet + (hexWidth * CGFloat(col) + hexWidth - (hexWidth / 2) * CGFloat(Board.ROW_SIZES[row] - 3))
            let y = (hexWidth * (2 / sqrt(3)) * 0.75) * CGFloat(row)
            let color = UIColor(rgb: tileColorMap[square.squareType]!)
            let frame = CGRect(x: x, y: y, width: hexWidth, height: hexWidth * (2 / sqrt(3)))
            let tile = UITile(frame: frame, color: color, number: square.number)
            
            tile.hex.strokeColor = UIColor.black.cgColor
            tile.hex.lineWidth = (view.frame.width / 175)
            boardArea.addSubview(tile)
            hexMap[SquareCord(x: col, y: row)] = tile
        }
    }
    
    func placePorts(board: Board) {
        let ports = board.ports
        for port in ports {
            let squareCordSide = portMap[port.index]
            let squareCord = squareCordSide!.squareCord!
            let side = squareCordSide!.side!
            let tile = hexMap[squareCord]!
            let color = portColorMap[port.portType]!
            drawPort(tile: tile, color: UIColor(rgb: color), side: side)
        }
    }
    
    func drawPort(tile: UITile, color: UIColor, side: Int) {
        let frame = tile.frame
        let halfHeight = Double(frame.height / 2)
        let halfWidth = Double(frame.width / 2)
        var x1 = (Double(frame.origin.x) + (halfWidth + (halfHeight * cos((Double(side) * 2 - 1) * Double.pi / 6))))
        var y1 = (Double(frame.origin.y) + (halfHeight + (halfHeight * sin((Double(side) * 2 - 1) * Double.pi / 6))))
        var x2 = (Double(frame.origin.x) + (halfWidth + (halfHeight * cos((Double(side + 1) * 2 - 1) * Double.pi / 6))))
        var y2 = (Double(frame.origin.y) + (halfHeight + (halfHeight * sin((Double(side + 1) * 2 - 1) * Double.pi / 6))))
        let dx = x2 - x1
        let dy = y2 - y1
        let x3 = (cos(((2.0 * Double.pi) - Double.pi / 3)) * dx - sin(((2.0 * Double.pi) - Double.pi / 3)) * dy) + x1
        let y3 = (sin(((2.0 * Double.pi) - Double.pi / 3)) * dx + cos(((2.0 * Double.pi) - Double.pi / 3)) * dy) + y1
        
        x2 = x2 + (x3 - x2) / 5
        y2 = y2 + (y3 - y2) / 5
        x1 = x1 + (x3 - x1) / 5
        y1 = y1 + (y3 - y1) / 5
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.opacity = 1
        shapeLayer.lineWidth = (view.frame.width / 175)
        shapeLayer.lineJoin = CAShapeLayerLineJoin.miter
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        boardArea.layer.insertSublayer(shapeLayer, at: 0)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        path.addLine(to: CGPoint(x: x3, y: y3))
        path.close()
        shapeLayer.path = path.cgPath
        
    }
    
    func playSound2() {
        let url = Bundle.main.url(forResource: "shuffle", withExtension: "m4a")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            DispatchQueue.global(qos: .background).async {
                player.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "shuffle", withExtension: "m4a") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private class SquareCordSide {
        var squareCord: SquareCord!
        var side: Int!
    
        init(squareCord: SquareCord, side: Int) {
            self.squareCord = squareCord
            self.side = side
        }
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    
}

