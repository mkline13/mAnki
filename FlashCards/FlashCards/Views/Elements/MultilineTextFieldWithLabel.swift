//
//  MultilineTextFieldWithLabel.swift
//  FlashCards
//
//  Created by Work on 8/13/22.
//


import UIKit


class MultilineTextFieldWithLabel: UIView, UITextViewDelegate {
    init (labelText: String, initial: String, onUpdate: @escaping UpdateHandler) {
        updateHandler = onUpdate
        
        super.init(frame: .zero)
                
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.text = labelText
        label.textColor = .systemGray
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .systemGray
        
        textView = UITextView(frame: .zero)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        textView.text = initial
        textView.backgroundColor = .clear
        
        self.addSubview(label)
        self.addSubview(line)
        self.addSubview(textView)
        self.addConstraints([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: line.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            line.topAnchor.constraint(equalTo: textView.topAnchor, constant: 6),
            line.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -6),
            line.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 8),
            line.widthAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        updateHandler(textView.text ?? "")
    }
    
    // MARK: Properties
    var textView: UITextView!
    
    private var updateHandler: UpdateHandler
    typealias UpdateHandler = (String) -> Void
}
