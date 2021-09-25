//
//  ViewController.swift
//  textfield+button
//
//  Created by harris ali on 9/23/21.
//
import UIKit

class ViewController: UIViewController {
    
    enum Constants {
        static let initialValue = "+1"
    }
    
    @IBOutlet var tfPhoneNumber: UITextField!
    @IBOutlet var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable button first
        self.btnNext.isEnabled = false
        
        //delegate
        self.tfPhoneNumber.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       //customize text and button
        self.tfPhoneNumber.borderStyle = .none
        self.tfPhoneNumber.layer.cornerRadius = 10.0
        self.tfPhoneNumber.layer.borderWidth = 1.0
        self.tfPhoneNumber.keyboardType = .numberPad //customize keyboard
        self.tfPhoneNumber.layer.borderColor = UIColor.gray.cgColor
        self.tfPhoneNumber.leftView = UIView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50.0, height: tfPhoneNumber.bounds.height)))
        self.tfPhoneNumber.leftViewMode = .always
        self.btnNext.layer.cornerRadius = 10.0
    }
    
    
    ///  example: `+X XXX XXX XXXX`
    func format(with mask: String, phone: String) -> String {
        //use replacing occurrencies to get space
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // use loop over the mask characters until the  numbers ends
        for ch in mask {
            if index < numbers.endIndex {
                if ch == "X" {
                    // loop needs a number in this place, so take the next one
                    result.append(numbers[index])
                    
                    // move numbers iterator to the next index
                    index = numbers.index(after: index)
                    
                } else {
                    result.append(ch) // just add a mask character
                }
            }
        }
        return result
    }
    
}

extension ViewController : UITextFieldDelegate {
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        //keep +1
        //Just return without doing format
        if newString.count < Constants.initialValue.count {
            textField.text = Constants.initialValue
            return false
        }
        
        //Get string according to given string just to use count 
        let formatString = "+X XXX XXX XXXX"
        textField.text = format(with: formatString, phone: newString)
        
        if newString.count == formatString.count {
            //hide keyboard
            self.tfPhoneNumber.resignFirstResponder()
            self.btnNext.isEnabled = true
        }else {
            self.btnNext.isEnabled = false
            if newString.isEmpty {
                self.tfPhoneNumber.text = Constants.initialValue
                self.btnNext.isEnabled = false
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //as soon as typing starts +1 should be there
        if let currentText = textField.text, !currentText.hasPrefix(Constants.initialValue) {
            textField.text = "\(Constants.initialValue)\(currentText)"
        }
    }
    
    
}

