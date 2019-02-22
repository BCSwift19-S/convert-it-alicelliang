//
//  ViewController.swift
//  ConvertIt
//
//  Created by Alice Liang on 2/21/19.
//  Copyright © 2019 Alice Liang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    
    
    var formulaArray = ["miles to kilometers", "kilometers to miles", "feet to meters", "yards to meters", "meters to feet", "meters to yard"]
    var fromUnit = ""
    var toUnit = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
    }

    @IBAction func convertButtonPressed(_ sender: UIButton) {
    }
    
}

extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulaArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let unitsArray = formulaArray[row].components(separatedBy: " to ")
        fromUnit = unitsArray[0]
        toUnit = unitsArray[1]
        fromUnitsLabel.text = fromUnit
        resultsLabel.text = toUnit
    }
}
