//
//  LetterPicker.swift
//  Weather
//
//  Created by Matthew on 25.06.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit


protocol LetterPickerDelegate: class {
    func didSelectRow(index: Int)
}

@IBDesignable class LetterPicker: UIView {

    var letterPikerDelegate: LetterPickerDelegate?
    
    private var letterPicker: UIPickerView!
    
    public var letterArray: [String] = [] {
        didSet {
            updateComponent()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateComponent()
        // Do any additional setup after loading the view.
    }

    private func updateComponent(){
        letterPicker.frame = CGRect(x: 0, y: 0, width: 35, height: self.bounds.height)
        letterPicker.reloadAllComponents()
    }

    private func setupComponent(){
        letterPicker = UIPickerView()
        letterPicker.dataSource = self
        letterPicker.delegate = self
        self.addSubview(letterPicker)
        updateComponent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupComponent()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupComponent()
    }

}

extension LetterPicker: UIPickerViewDelegate, UIPickerViewDataSource {
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
        letterPikerDelegate?.didSelectRow(index: row)
    }
    
}

