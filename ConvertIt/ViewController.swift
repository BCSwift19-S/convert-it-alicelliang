//
//  ViewController.swift
//  ConvertIt
//
//  Created by Alice Liang on 2/21/19.
//  Copyright © 2019 Alice Liang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    struct Formula {
        var conversionString: String
        var formula: (Double) -> Double
    }
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    let formulasArray = [Formula(conversionString: "miles to kilometers", formula: {$0 / 0.62137}),
                        Formula(conversionString: "kilometers to miles", formula: {$0 * 0.62137}),
                        Formula(conversionString: "feet to meters", formula: {$0 / 3.2808}),
                        Formula(conversionString: "yards to meters", formula: {$0 / 1.0936}),
                        Formula(conversionString: "meters to feet", formula: {$0 * 3.2808}),
                        Formula(conversionString: "meters to yards", formula: {$0 * 1.093}),
                        Formula(conversionString: "inches to cm", formula: {$0 / 0.3937}),
                        Formula(conversionString: "cm to inches", formula: {$0 * 0.3937}),
                        Formula(conversionString: "fahrenheit to celsius", formula: {($0-32) * (5/9)}),
                        Formula(conversionString: "celsius to fahrenheit", formula: {($0 * (9/5)) + 32}),
                        Formula(conversionString: "quarts to liters", formula: {$0 / 1.05669}),
                        Formula(conversionString: "liters to quarts", formula: {$0 * 1.05669})]
    var fromUnit = ""
    var toUnit = ""
    var conversionString = ""
    
    
    
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        conversionString = formulasArray[formulaPicker.selectedRow(inComponent: 0)].conversionString
        let unitsArray = conversionString.components(separatedBy: " to ")
        fromUnit = unitsArray[0]
        fromUnitsLabel.text = fromUnit
        toUnit = unitsArray[1]
        
        userInput.becomeFirstResponder()
        signSegment.isHidden = true
    }
    
    
    func calculateConversion() {
        guard let inputValue = Double(userInput.text!) else {
            if userInput.text != "" {
                showAlert(title: "Cannot Convert Value", message: "\"\(userInput.text!)\" is a valid number.")
            }
            return
        }
            let outputValue = formulasArray[formulaPicker.selectedRow(inComponent: 0)].formula(inputValue)
        
            let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments-1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f" : "%f")
            let outputString = String (format: formatString, outputValue)
            resultsLabel.text = "\(inputValue) \(fromUnit) = \(outputString) \(toUnit)"
    }
    
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }


    //MARK:- IBActions
    @IBAction func userInputChanged(_ sender: UITextField) {
        resultsLabel.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
        
    }
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConversion()
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        calculateConversion()
    }
    
    @IBAction func signSegmentSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0 {
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        if userInput.text != "-"{
        calculateConversion()
        }
    }
}


//MARK: -Pickerview Extension
    extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return formulasArray.count
        }
    
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return formulasArray[row].conversionString
        }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            conversionString = formulasArray [row].conversionString
            
            //Will be true regardless of case but if both are the word "celsius"
            if conversionString.lowercased().contains("celsius".lowercased()) {
                signSegment.isHidden = false
            } else {
                signSegment.isHidden = true
                userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
                signSegment.selectedSegmentIndex = 0
            }
            
            let unitsArray = formulasArray[row].conversionString.components(separatedBy: " to ")
            fromUnit = unitsArray[0]
            toUnit = unitsArray[1]
            fromUnitsLabel.text = fromUnit
            calculateConversion()
        }
    }
