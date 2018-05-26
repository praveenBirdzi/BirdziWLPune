//
//  PHTextField.swift
//  PlaseHolderedTextField
//
//  Created by Alexander Smetannikov on 09/02/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

@IBDesignable
public class PHTextField: UIView {

    internal let textField = UITextField()
    private let placeholderLabel = UILabel()
    
    // MARK: - Placeholder properties
    
    @IBInspectable public var placeholder: String? {
        get { return placeholderLabel.text }
        set {
            placeholderLabel.text = newValue
            recalculateLayout()
        }
    }
    
    @IBInspectable public var placeholderFont: UIFont {
        get { return placeholderLabel.font }
        set {
            placeholderLabel.font = newValue
            recalculateLayout()
        }
    }
    
    @IBInspectable public var placeholderTextColor: UIColor? {
        get { return placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }
    
    @IBInspectable public var placeholderBackgroundColor: UIColor? {
        get { return placeholderLabel.backgroundColor }
        set { placeholderLabel.backgroundColor = newValue }
    }
    
    // MARK: - Text field properties
    
    public var delegate: UITextFieldDelegate? {
        get { return textField.delegate }
        set { textField.delegate = newValue }
    }
    
    @IBInspectable public var font: UIFont? {
        get { return textField.font }
        set { textField.font = newValue }
    }
    
    @IBInspectable public var textColor: UIColor? {
        get { return textField.textColor }
        set { textField.textColor = newValue }
    }
    
    @IBInspectable override public var backgroundColor: UIColor? {
        get { return textField.backgroundColor }
        set {
            textField.backgroundColor = newValue
            super.backgroundColor = newValue
        }
    }
    
    @IBInspectable public var textAlignment: NSTextAlignment {
        get { return textField.textAlignment }
        set { textField.textAlignment = newValue }
    }
    
    @IBInspectable public var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    private var _textOffset: CGFloat = 2.0
    
    @IBInspectable public var textOffset: CGFloat {
        get { return _textOffset }
        set {
            if _textOffset != newValue {
                _textOffset = newValue
                // TODO: нужно перерисовать контрол
            }
        }
    }
    
    @available(iOS 10.0, *)
    @IBInspectable public var textContentType: UITextContentType {
        get { return textField.textContentType }
        set { textField.textContentType = newValue }
    }
    
    @IBInspectable public var autocapitalizationType: UITextAutocapitalizationType {
        get { return textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }
    
    @IBInspectable public var autocorrectionType: UITextAutocorrectionType {
        get { return textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }
    
    @available(iOS 11.0, *)
    @IBInspectable public var smartDashesType: UITextSmartDashesType {
        get { return textField.smartDashesType }
        set { textField.smartDashesType = newValue }
    }
    
    @available(iOS 11.0, *)
    @IBInspectable public var smartInsertDeleteType: UITextSmartInsertDeleteType {
        get { return textField.smartInsertDeleteType }
        set { textField.smartInsertDeleteType = newValue }
    }
    
    @available(iOS 11.0, *)
    @IBInspectable public var smartQuotesType: UITextSmartQuotesType {
        get { return textField.smartQuotesType }
        set { textField.smartQuotesType = newValue }
    }
    
    @IBInspectable public var spellCheckingType: UITextSpellCheckingType {
        get { return textField.spellCheckingType }
        set { textField.spellCheckingType = newValue }
    }
    
    public override var isFirstResponder: Bool {
        get { return textField.isFirstResponder }
    }
    
    public override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: - Common properties
    
    private var _borderStyle: UITextBorderStyle = .none
    
    public var borderStyle: UITextBorderStyle {
        get { return _borderStyle }
        set {
            if _borderStyle != newValue {
                setBorderStyle(newValue)
            }
        }
    }
    
    private func setBorderStyle(_ newValue: UITextBorderStyle) {
        _borderStyle = newValue
        switch _borderStyle {
        case .none:
            layer.cornerRadius = 0
            layer.borderWidth = 0
        case .line:
            layer.cornerRadius = 0
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
        case .bezel:
            layer.cornerRadius = 0
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray.cgColor
        case .roundedRect:
            layer.cornerRadius = 5
            layer.borderWidth = 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(placeholderLabel)
        self.addSubview(textField)
        self.isUserInteractionEnabled = true
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(placeholderLabel)
        self.addSubview(textField)
        self.isUserInteractionEnabled = true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        recalculateLayout()
    }
    
    private func recalculateLayout() {
        let placeholderWidth = placeholderLabel.intrinsicContentSize.width
        placeholderLabel.frame = CGRect(x: 0.0, y: 0.0, width: placeholderWidth, height: frame.size.height)
        let textFieldWidth = frame.size.width - placeholderWidth - _textOffset
        textField.frame = CGRect(x: placeholderWidth + _textOffset, y: 0.0, width: textFieldWidth, height: frame.size.height)
    }
    
}
