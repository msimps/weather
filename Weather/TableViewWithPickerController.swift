//
//  TableViewWithPickerController.swift
//  Weather
//
//  Created by Matthew on 25.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class TableViewWithPickerController: UIViewController {
    
    @IBOutlet weak var arrayTableView: UITableView!
    @IBOutlet weak var letterPicker: UIPickerView!
    
    var arrayValues: [String] = ["Abuhov", "Boliev", "Bernov","Bushuev","Cedric","Sergiev Oleg", "Denisov Den", "Durov Kostantiv", "Durov Pavel", "Evklidov",  "Efremov", "Efrat"]
    var letterArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        
        // Do any additional setup after loading the view.
    }
    
    
    private func setupComponent(){
        // fill tmp users
        for i in 1...30 {
            arrayValues.append("user\(i)")
        }
        arrayValues = arrayValues.sorted()
        
        // obtain uniq first letters
        let s = Set(arrayValues.map {String($0.uppercased().first!)})
        letterArray = Array(s).sorted()
        
        letterPicker.dataSource = self
        letterPicker.delegate = self
        arrayTableView.delegate = self
        arrayTableView.dataSource = self
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TableViewWithPickerController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cell.groupName.text = "asd"//myGroups[indexPath.row].name
        cell.textLabel?.text = arrayValues[indexPath.row]
        //cell.imageView?.image = UIImage(named: myGroups[indexPath.row].avatar)
        // Configure the cell...
        
        return cell
    }
    
    
}

extension TableViewWithPickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return letterArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return letterArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let i = arrayValues.firstIndex(where: {$0.uppercased().hasPrefix(letterArray[row])})
        arrayTableView.scrollToRow(at: IndexPath(row: i!, section: 0), at: .top, animated: true)
    }
    
}
