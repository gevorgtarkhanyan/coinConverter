//
//  CoinFiatFooterView.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/30/20.
//

import UIKit

protocol CoinFiatFooterViewDelegate: AnyObject {
    func textFieldTextChanged(count: Double)
}

class CoinFiatFooterView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var separatorTopView: BigSeparatorView!
    @IBOutlet weak var separatorBottomView: BigSeparatorView!
    
    @IBOutlet weak var backView: BaseView!
    @IBOutlet weak var currentCriptoSymbolLabel: BaseLabel!
    @IBOutlet weak var priceTextField: BaseTextField!
    
    static var height: CGFloat = 76 // must be more than 44px, the rest is distance from surrounding
    weak var delegate: CoinFiatFooterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CoinFiatFooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupBackView()
        
    }
    func setupBackView (){
        backView.roundCorners([.topLeft, .topRight])
        let borderWidth: CGFloat = 1
        backView.frame = frame.insetBy(dx: -borderWidth, dy: -borderWidth)
        backView.layer.borderColor = UIColor.startGradient.cgColor
        backView.layer.borderWidth = borderWidth
        
    }
    
    
    public func setup(symbol: String) {
        let num = Defaults.load(key: .multiplier) ?? 1.0
        if let intValue = Int(exactly: num) {
            if intValue == 1 {
                priceTextField.placeholder = String(intValue)
            } else {
                priceTextField.text = String(intValue)
            }
        } else {
            priceTextField.text = String(num)
        }
        
        currentCriptoSymbolLabel.text = symbol
    }
    
    
}

extension CoinFiatFooterView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        priceTextField.textColor = darkMode ? .white : .black
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if updatedText.isEmpty || (priceTextField.text == "0." && string == "") {
                delegate?.textFieldTextChanged(count: 1)
            } else {
                if let count = Double(updatedText) {
                    delegate?.textFieldTextChanged(count: count)
                    Defaults.save(data: count, key: .multiplier)
                }
            }
        }
        
        return textField.allowOnlyNumbers(string: string)
        
        
    }
    
   
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = textField.text {
//            if let num = Double(text) {
//                Defaults.save(data: num, key: .multiplier)
//            } else {
//                Defaults.removeObject(forKey: .multiplier)
//            }
//        }
//        
//    }
    
}
