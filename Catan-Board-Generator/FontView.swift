import UIKit

class FontView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var fonts: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.frame)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let fontFamilyNames = UIFont.familyNames
        for fontFamilyName in fontFamilyNames {
            fonts.append(fontFamilyName)
        }
        tableView.reloadData()
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let fontName = fonts[indexPath.row]
        cell.textLabel?.text = fontName
        cell.textLabel?.font = UIFont(name: fontName, size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fontName = fonts[indexPath.row]
        print(fontName)
    }



}

