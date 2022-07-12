//
//  ViewController.swift
//  HW 2
//
//  Created by Alexey Efimov on 12.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet var redTF: UITextField!
    @IBOutlet var greenTF: UITextField!
    @IBOutlet var blueTF: UITextField!
    
    
    var mainColorBG: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = 15
        setInitialSettings()
        setupKeyboardHiding()
        
        redTF.delegate = self
        blueTF.delegate = self
        greenTF.delegate = self
        
        redTF.addDoneButtonOnKeyboard()
        blueTF.addDoneButtonOnKeyboard()
        greenTF.addDoneButtonOnKeyboard()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        changeColor()
        switch sender {
        case redSlider:
            redLabel.text = stringFromSlider(from: redSlider)
            redTF.text = stringFromSlider(from: redSlider)
        case greenSlider:
            greenLabel.text = stringFromSlider(from: greenSlider)
            greenTF.text = stringFromSlider(from: greenSlider)
        default:
            blueLabel.text = stringFromSlider(from: blueSlider)
            blueTF.text = stringFromSlider(from: blueSlider)
        }
    }
    
    @IBAction func doneButtonPressed() {
        view.endEditing(true)
        delegate.setNewColor(for: colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    
    private func setInitialSettings() {
        colorView.backgroundColor = mainColorBG
        setValue(for: mainColorBG)
        setLabels(for: mainColorBG)
        setTFtext(for: mainColorBG)
    }
    
    private func changeColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue(for labels: UIColor) {
        guard let components = mainColorBG.cgColor.components else { return }
        redLabel.text = stringFromCGFloat(from: components[0])
        greenLabel.text = stringFromCGFloat(from: components[1])
        blueLabel.text = stringFromCGFloat(from: components[2])
        
    }
    
    private func setLabels(for labels: UIColor) {
        guard let components = mainColorBG.cgColor.components else { return }
        redSlider.value = float(from: components[0])
        greenSlider.value = float(from: components[1])
        blueSlider.value = float(from: components[2])
        
    }
    
    private func setTFtext(for labels: UIColor) {
        guard let components = mainColorBG.cgColor.components else { return }
        redTF.text = stringFromCGFloat(from: components[0])
        greenTF.text = stringFromCGFloat(from: components[1])
        blueTF.text = stringFromCGFloat(from: components[2])
        
    }
    
    private func stringFromSlider(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func stringFromCGFloat(from color: CGFloat) -> String {
        String(format: "%.2f", color)
    }
    
    private func float(from color: CGFloat) -> Float {
        Float(color)
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
}

// MARK: - UITextFieldsDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue) else { return }
        if textField == redTF {
            redSlider.value = numberValue
            redLabel.text = String(format: "%.2f", numberValue)
        } else if textField == blueTF {
            blueSlider.value = numberValue
            blueLabel.text = String(format: "%.2f", numberValue)
        } else {
            greenSlider.value = numberValue
            greenLabel.text = String(format: "%.2f", numberValue)
        }
        changeColor()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        view.frame.origin.y = 0 - keyboardSize.height / 6
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: - UITextField
extension UITextField {
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}
